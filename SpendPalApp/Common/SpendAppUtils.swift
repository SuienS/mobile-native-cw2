//
//  SpendAppUtils.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-18.
//
// This file will contain all the utility Methods for the app

import Foundation
import UIKit
import EventKit
import EventKitUI


class SpendAppUtils {
    static var managedAppObjContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var managedAppObj = (UIApplication.shared.delegate as! AppDelegate)
    
    static var profile = "Profile_1"
    
    static var colourAlpha = CGFloat(0.5)
    
    static let colourCodes = ["Green":
                                UIColor.systemGreen.withAlphaComponent(colourAlpha),
                              "Blue":
                                UIColor.systemBlue.withAlphaComponent(colourAlpha),
                              "Yellow": UIColor.systemYellow.withAlphaComponent(colourAlpha),
                              "Pink": UIColor.systemPink.withAlphaComponent(colourAlpha),
                              "Purple": UIColor.systemPurple.withAlphaComponent(colourAlpha),
                              "Teal": UIColor.systemTeal.withAlphaComponent(colourAlpha),
                              "DEFAULT": UIColor.systemGray6,
                              "SELECTED": UIColor.systemBlue.withAlphaComponent(0.1)] as [String : UIColor]
    
    static let colourCodesIndex = ["Green": 0,
                                   "Blue": 1,
                                   "Yellow":2,
                                   "Pink":3,
                                   "Purple":4,
                                   "Teal":5] as [String : Int]
    
    static let eventTypesIndex = ["One off": 0,
                                  "Daily": 1,
                                  "Weekly":2,
                                  "Monthly":3] as [String : Int]
    
    
    static let NSDecimalFormatter = NumberFormatter()
    
    static func getCodeColour(_ strColour: String) -> UIColor{
        
        switch strColour {
        case "Green":
            return colourCodes[strColour]!
        case "Blue":
            return colourCodes[strColour]!
        case "Yellow":
            return colourCodes[strColour]!
        case "Pink":
            return colourCodes[strColour]!
        case "Purple":
            return colourCodes[strColour]!
        case "Teal":
            return colourCodes[strColour]!
        case "SELECTED":
            return colourCodes[strColour]!
        default:
            return colourCodes["DEFAULT"]!
        }
        
    }

    
    
    static func toNSDecimal(_ string: String) -> NSDecimalNumber {
        NSDecimalFormatter.generatesDecimalNumbers = true
        return NSDecimalFormatter.number(from: string) as? NSDecimalNumber ?? 0
    }
    
    static func attemptToAddSystemCalender( reminderEventStore: EKEventStore, classDelegate: Any?, expense: Expense, inst: Any?) {
        
        // Handle Permission Request reject
        // Deleting
        
        // Happens safely in a new thread
        reminderEventStore.requestAccess( to: EKEntityType.event, completion:{(permission, errorPermission) in
            DispatchQueue.main.async {
                if (permission) && (errorPermission == nil) {
                    let reminderEvent = EKEvent(eventStore: reminderEventStore)
                    
                    let dateTime = expense.date ?? Date()
                    let eventTitle = expense.name ?? "N/A"
                    let expenseAmount = expense.amount ?? 0
                    let notes = expense.notes ?? ""
                    let type = expense.occurrence ?? "One off"
                    
                    
                    
                    reminderEvent.title = eventTitle
                    reminderEvent.startDate = dateTime
                    reminderEvent.endDate = dateTime
                    reminderEvent.notes = "You have an expense of \(expenseAmount) £ to pay. || Expense Notes: \(notes)"
                    reminderEvent.addAlarm(EKAlarm(relativeOffset: -86400))
                    reminderEvent.addAlarm(EKAlarm(relativeOffset: -3600))
                    
                    if type != "One off" {
                        reminderEvent.recurrenceRules = [getRecurrenceEventRule(expenseType :type)]
                    }
                    
                    reminderEvent.calendar = reminderEventStore.defaultCalendarForNewEvents
                    do {
                        try reminderEventStore.save(reminderEvent, span: .thisEvent)
                        showAlertMessage(viewController: inst as! UIViewController, title: "Added to Calender", message: "SpendPalApp successfully added the expense to your Calender.")
                    } catch {
                        expense.dueReminder = false
                        SpendAppUtils.managedAppObj.saveContext()
                        showAlertMessage(viewController: inst as! UIViewController, title: "Permission Error", message: "Error while saving the event")
                    }
                } else {
                    expense.dueReminder = false
                    SpendAppUtils.managedAppObj.saveContext()
                    showAlertMessage(viewController: inst as! UIViewController, title: "Permission Error", message: "Allow the permissions for the app to use Calender App in Settings")

                }
            }
        })
    }
    
    static func getRecurrenceEventRule(expenseType :String) -> EKRecurrenceRule{
        switch expenseType {
        case "Daily":
            return EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.daily, interval: 1, end: EKRecurrenceEnd(occurrenceCount: 30))
        case "Weekly":
            return EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.weekly, interval: 1, end: EKRecurrenceEnd(occurrenceCount: 54))
        case "Monthly":
            return EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.monthly, interval: 1, end: EKRecurrenceEnd(occurrenceCount: 24))
        default:
            return EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.monthly, interval: 0, end: EKRecurrenceEnd(occurrenceCount: 24))
        }
        
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    static func showAlertMessage(viewController: UIViewController, title: String, message: String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // Pay update of expenses
    static func totalAmountCal(expenseType: String, startDate: Date, unitAmount: NSDecimalNumber) -> NSDecimalNumber{
        var calAmount = unitAmount
        let curCalendar = NSCalendar.current
        var occurenceCount = 1

        switch expenseType {
        case "Daily":
            occurenceCount = curCalendar.dateComponents([.day], from: curCalendar.startOfDay(for: startDate), to: curCalendar.startOfDay(for: startDate.endDateMonth)).day ?? 1
                        
        case "Weekly":
            occurenceCount = Int((curCalendar.dateComponents([.day], from: curCalendar.startOfDay(for: startDate), to: curCalendar.startOfDay(for: startDate.endDateMonth)).day ?? 1) / 7)
        default:
            return calAmount
        }
        
        calAmount = NSDecimalNumber(decimal: calAmount as Decimal * Decimal(occurenceCount))
        return calAmount
        
    }
}



extension UIView {
    func fadeUpdateTransition(_ animDuration:CFTimeInterval) {
        let updateAnimation = CATransition()
        updateAnimation.timingFunction = CAMediaTimingFunction(name:
                                                                CAMediaTimingFunctionName.easeInEaseOut)
        updateAnimation.type = CATransitionType.fade
        updateAnimation.duration = animDuration
        layer.add(updateAnimation, forKey: CATransitionType.fade.rawValue)
    }
}



