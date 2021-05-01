//
//  AddExpenseViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-20.
//

import UIKit
import EventKit
import EventKitUI

class AddExpenseViewController: UIViewController, EKEventEditViewDelegate {
    

    @IBOutlet weak var textFieldExpenseName: UITextField!
    @IBOutlet weak var textFieldExpenseAmount: UITextField!
    @IBOutlet weak var datePickerDate: UIDatePicker!
    @IBOutlet weak var switchReminder: UISwitch!
    @IBOutlet weak var segControllerOccurence: UISegmentedControl!
    @IBOutlet weak var textFieldNotes: UITextField!
        
    
    var expenseCategory:Category?
    var expense: Expense?
    
    let reminderSetEventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptEditLoad(expense: expense)
        
        
//        textFieldsAll.forEach{txt in
//            let shortcut : UITextInputAssistantItem = txt.inputAssistantItem
//            shortcut.leadingBarButtonGroups = []
//            shortcut.trailingBarButtonGroups = []
//        }

    }
    
    @IBAction func buttonExpenseSavePressed(_ sender: UIButton) {
        let expenseName = textFieldExpenseName.text
        let strAmountVal = textFieldExpenseAmount.text ?? "0"
        let amountVal = SpendAppUtils.toNSDecimal(strAmountVal)
        if (expenseName != "") && amountVal.decimalValue >= 0.0 && amountVal.decimalValue < Decimal.greatestFiniteMagnitude{
            let expense = Expense(context:SpendAppUtils.managedAppObjContext)
            expense.name = expenseName
            expense.amount = amountVal
            expense.date = datePickerDate.date
            expense.occurrence = segControllerOccurence.titleForSegment(at: segControllerOccurence.selectedSegmentIndex)
            
            if switchReminder.isOn {
                SpendAppUtils.attemptToAddSystemCalender(reminderEventStore: reminderSetEventStore, classDelegate: self, dateTime: datePickerDate.date, eventTitle: expenseName ?? "N/A", notes: textFieldNotes.text ?? "", type: segControllerOccurence.titleForSegment(at: segControllerOccurence.selectedSegmentIndex) ?? "One off", inst: self)
            }
            expense.dueReminder = switchReminder.isOn
            
            expense.notes = textFieldNotes.text
            expense.category = expenseCategory?.name
            expenseCategory?.addToExpenses(expense)
            SpendAppUtils.managedAppObj.saveContext()
            

            
            dismiss(animated: true, completion: nil)
            
            print("Added to \(expense.category ?? "No Exp")")
        } else {
            print("Error Input!")
        }
    }
    
    @IBAction func buttonExpenseEditPressed(_ sender: UIButton) {
        let expenseName = textFieldExpenseName.text
        let expenseAmount = textFieldExpenseAmount.text ?? "0"
        let expenseAmountVal = SpendAppUtils.toNSDecimal(expenseAmount)
        if (expenseName != "") && expenseAmountVal.decimalValue >= 0.0 && expenseAmountVal.decimalValue < Decimal.greatestFiniteMagnitude{
            expense?.name = expenseName
            expense?.amount = expenseAmountVal
            expense?.date = datePickerDate.date
            expense?.notes = textFieldNotes.text
            expense?.occurrence = segControllerOccurence.titleForSegment(at: segControllerOccurence.selectedSegmentIndex)
            
            if !(expense?.dueReminder ?? false) && switchReminder.isOn {
                SpendAppUtils.attemptToAddSystemCalender(reminderEventStore: reminderSetEventStore, classDelegate: self, dateTime: datePickerDate.date, eventTitle: expenseName ?? "N/A", notes: textFieldNotes.text ?? "", type: segControllerOccurence.titleForSegment(at: segControllerOccurence.selectedSegmentIndex) ?? "One off", inst: self)

            } else if (expense?.dueReminder ?? false) && !(switchReminder.isOn) {
                // remove event form calender
            }
            
            expense?.dueReminder = switchReminder.isOn
            SpendAppUtils.managedAppObj.saveContext()
            dismiss(animated: true, completion: nil)
        } else {
            print("Error Input!")
        }
    }
    @IBAction func switchAddReminderChanged(_ sender: UISwitch) {

    }
    
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func attemptEditLoad(expense: Expense?) {
        if let expense = expense {
            textFieldExpenseName.text = expense.name
            textFieldExpenseAmount.text = "\(expense.amount?.decimalValue ?? 0.0)"
            textFieldNotes.text = expense.notes
            datePickerDate.date = expense.date ?? Date()
            switchReminder.isOn = expense.dueReminder
            
            segControllerOccurence.selectedSegmentIndex = SpendAppUtils.eventTypesIndex[expense.occurrence ?? "One off"] ?? 0
            

        }
    }
    

}

// Apple Bug UISwitch - https://developer.apple.com/forums/thread/132035
