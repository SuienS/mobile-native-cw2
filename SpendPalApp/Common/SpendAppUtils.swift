/**
 Author       : Rammuni Ravidu Suien Silva
 UoW No   : 16267097 || IIT No: 2016134
 Mobile Native Development - Coursework 2
 
 File Desc: This file will contain all the utility Methods and static variables used throughout the app
 */

//
//  SpendAppUtils.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-18.
//

import Foundation
import UIKit
import EventKit
import EventKitUI


enum SpendType {
    case Category, Expense
}


class SpendAppUtils {
    
    // MARK: - Static constants
    
    // Handle to the App object
    static var managedAppObjContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var managedAppObj = (UIApplication.shared.delegate as! AppDelegate)
    
    // Current profile; default is set to 1
    static var profile = "Profile_1"
    
    // Acceptable range for input financial amounts
    static var maxBudgetAmount:Decimal = 999999999.0
    static var minCategoryAmount:Decimal = 10.0
    static var minExpenseAmount:Decimal = 0.5

    // Colour transparency
    static var colourAlpha = CGFloat(0.5)
    
    // Colour codes used in the app
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

    
    // Convertion from String to Decimal with two decimal point rounding
    static let NSDecimalFormatter = NumberFormatter()
    

    // MARK: - Utility functions
    
    // Convertion from String to Decimal with two decimal point rounding
    static func toNSDecimal(_ string: String) -> NSDecimalNumber {
        NSDecimalFormatter.generatesDecimalNumbers = true
        
        var decValue: Decimal = (NSDecimalFormatter.number(from: string) as? NSDecimalNumber ?? -1.0) as Decimal
        var roundedDecimal: Decimal = Decimal()
        
        NSDecimalRound(&roundedDecimal, &decValue, 2, .plain)
        
        return NSDecimalNumber(decimal: roundedDecimal)
    }
    
    // Adding reminders to System Calender App
    static func attemptToAddSystemCalender( reminderEventStore: EKEventStore, classDelegate: Any?, expense: Expense, inst: Any?) {
        
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
                    
                    // Setting reminder details
                    reminderEvent.title = "Payment: \(eventTitle)"
                    reminderEvent.startDate = dateTime
                    reminderEvent.endDate = dateTime
                    reminderEvent.notes = "You have an expense of \(expenseAmount) £ to pay. || Expense Notes: \(notes)"
                    reminderEvent.addAlarm(EKAlarm(relativeOffset: -86400))
                    reminderEvent.addAlarm(EKAlarm(relativeOffset: -3600))
                    
                    // Handling recurent events
                    if type != "One off" {
                        reminderEvent.recurrenceRules = [getRecurrenceEventRule(expenseType :type)]
                    }
                    
                    reminderEvent.calendar = reminderEventStore.defaultCalendarForNewEvents
                    
                    // Attempt saving to the system calender app
                    do {
                        try reminderEventStore.save(reminderEvent, span: .thisEvent)
                        showAlertMessage(activeVC: inst as! UIViewController, title: "Added to Calender", message: "SpendPalApp successfully added the expense to your Calender.")
                    } catch {
                        // Unexected Save Error
                        expense.dueReminder = false
                        SpendAppUtils.managedAppObj.saveContext()
                        showAlertMessage(activeVC: inst as! UIViewController, title: "Unexpected Error", message: "Error while saving the event")
                    }
                } else {
                    // No Permission error
                    expense.dueReminder = false
                    SpendAppUtils.managedAppObj.saveContext()
                    showAlertMessage(activeVC: inst as! UIViewController, title: "Permission Error", message: "Allow the permissions for the app to use Calender App in Settings")

                }
            }
        })
    }
    
    // Recuurence rule genrator
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
    
    // App notification alert dialogue
    static func showAlertMessage(activeVC: UIViewController, title: String, message: String){
        let messageAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // Action Button
        messageAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        activeVC.present(messageAlert, animated: true, completion: nil)
    }
    
    // Pay status update of expenses
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


// MARK: - Extensions

// Element Update animation extension
extension UIView {
    func fadeUpdateTransition(_ animDuration:CFTimeInterval) {
        let updateFadeAnimation = CATransition()
        updateFadeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        updateFadeAnimation.type = CATransitionType.fade
        updateFadeAnimation.duration = animDuration
        layer.add(updateFadeAnimation, forKey: CATransitionType.fade.rawValue)
    }
}



