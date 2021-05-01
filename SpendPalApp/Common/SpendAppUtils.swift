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
    
    static func attemptToAddSystemCalender( reminderEventStore: EKEventStore, classDelegate: Any?, dateTime: Date, eventTitle: String, notes: String, type: String, inst: Any?) {
        
        // Handle Permission Request reject
        // Recurring event
        // Deleting
        
        // Happens safely in a new thread
        reminderEventStore.requestAccess( to: EKEntityType.event, completion:{(permission, errorPermission) in
            DispatchQueue.main.async {
                if (permission) && (errorPermission == nil) {
                    let reminderEvent = EKEvent(eventStore: reminderEventStore)
                    
                    reminderEvent.title = eventTitle
                    reminderEvent.startDate = dateTime
                    reminderEvent.endDate = dateTime
                    reminderEvent.notes = notes
                    reminderEvent.addAlarm(EKAlarm(relativeOffset: -86400))
                    reminderEvent.addAlarm(EKAlarm(relativeOffset: -3600))
                    
                    if type != "One off" {
                        reminderEvent.recurrenceRules = [getRecurrenceEventRule(expenseType :type)]
                    }
                    
                    reminderEvent.calendar = reminderEventStore.defaultCalendarForNewEvents
                    do {
                        try reminderEventStore.save(reminderEvent, span: .thisEvent)
                    } catch let error as NSError {
                        print("Reminder Save Error : \(error)")
                    }
                    
//                    let alert = UIAlertController(title: "Alert", message: "Added to Calender App Successfully", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//
//                    (inst as? UIViewController)?.present(alert, animated: true, completion: nil)


//                    let calReminderController = EKEventEditViewController()
//                    calReminderController.event = reminderEvent
//                    calReminderController.eventStore = reminderEventStore
//
//                    calReminderController.editViewDelegate = classDelegate as? EKEventEditViewDelegate
//                    (classDelegate as? UIViewController)?.present(calReminderController, animated: true, completion: nil)
                    
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



