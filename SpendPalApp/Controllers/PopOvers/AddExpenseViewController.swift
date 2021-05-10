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

    
    var expensesViewController: ExpensesViewController?
    
    
    let reminderSetEventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptEditLoad(expense: expense)
        
        let textFieldsAll = [textFieldNotes,textFieldExpenseName,textFieldExpenseName, textFieldExpenseAmount]
        
        textFieldsAll.forEach{txt in
            let kbItems : UITextInputAssistantItem = txt?.inputAssistantItem ?? UITextInputAssistantItem()
            kbItems.leadingBarButtonGroups = []
            kbItems.trailingBarButtonGroups = []
        }

    }
    
    @IBAction func buttonExpenseSavePressed(_ sender: UIButton) {
        
        
        let expenseName = textFieldExpenseName.text ?? ""
        
        let eventOccurrence = segControllerOccurence.titleForSegment(at: segControllerOccurence.selectedSegmentIndex) ?? ""
        
        let strAmountVal = textFieldExpenseAmount.text ?? "0"
        let amountValUnit = SpendAppUtils.toNSDecimal(strAmountVal)
        
        let amountVal = SpendAppUtils.totalAmountCal(expenseType: eventOccurrence, startDate: datePickerDate.date, unitAmount: amountValUnit)
                
        
        if isValidExpense(expenseName: expenseName, expenseTotAmount: amountVal) {
            
            let expense = Expense(context:SpendAppUtils.managedAppObjContext)
            expense.name = expenseName
            
            
            expense.amount = amountVal
            expense.unitAmount = amountValUnit
            
            expense.date = datePickerDate.date
            expense.occurrence = eventOccurrence
            
            
            expense.dueReminder = switchReminder.isOn
            
            expense.notes = textFieldNotes.text
            expense.category = expenseCategory?.name
            expenseCategory?.addToExpenses(expense)
            SpendAppUtils.managedAppObj.saveContext()
            
            if switchReminder.isOn {
                SpendAppUtils.attemptToAddSystemCalender(reminderEventStore: reminderSetEventStore, classDelegate: self, expense:expense, inst: expensesViewController)
            }

            
            dismiss(animated: true, completion: nil)
            
            print("Added to \(expense.category ?? "No Exp")")
//            expensesViewController?.updateGraphics()
            expensesViewController?.barButtonEditExpense.isEnabled=false
        } else {
            print("Error Input!")
        }
    }
    
    @IBAction func buttonExpenseEditPressed(_ sender: UIButton) {
        let expenseName = textFieldExpenseName.text ?? ""
        let expenseAmount = textFieldExpenseAmount.text ?? "0"
        let expenseUnitAmountVal = SpendAppUtils.toNSDecimal(expenseAmount)
        
        let eventOccurrence = segControllerOccurence.titleForSegment(at: segControllerOccurence.selectedSegmentIndex) ?? ""
        
        let expenseAmountVal = SpendAppUtils.totalAmountCal(expenseType: eventOccurrence, startDate: datePickerDate.date, unitAmount: expenseUnitAmountVal)
        
        // BUG when editing
        if isValidExpense(expenseName: expenseName, expenseTotAmount: expenseAmountVal) {
            
            expense?.name = expenseName
            expense?.amount = expenseAmountVal
            expense?.unitAmount = expenseUnitAmountVal
            expense?.date = datePickerDate.date
            expense?.notes = textFieldNotes.text
            expense?.occurrence = eventOccurrence
            
            let dueReminder = expense?.dueReminder ?? false
            
            expense?.dueReminder = switchReminder.isOn
            
            SpendAppUtils.managedAppObj.saveContext()
            
            if !dueReminder && switchReminder.isOn {
                SpendAppUtils.attemptToAddSystemCalender(reminderEventStore: reminderSetEventStore, classDelegate: self, expense:expense ?? Expense(), inst: expensesViewController)

            } else if dueReminder && !(switchReminder.isOn) {
                // remove event form calender
            }
            
            dismiss(animated: true, completion: nil)
            
//            expensesViewController?.updateGraphics()
            expensesViewController?.barButtonEditExpense.isEnabled=false

        } else {
            print("Error Input!")
        }
    }

        
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func attemptEditLoad(expense: Expense?) {
        if let expense = expense {
            textFieldExpenseName.text = expense.name
            textFieldExpenseAmount.text = "\(expense.unitAmount?.decimalValue ?? 0.0)"
            textFieldNotes.text = expense.notes
            datePickerDate.date = expense.date ?? Date()
            switchReminder.isOn = expense.dueReminder
            
            segControllerOccurence.selectedSegmentIndex = SpendAppUtils.eventTypesIndex[expense.occurrence ?? "One off"] ?? 0
            

        }
    }
    
    // MARK: - Validation Function
    
    func isValidExpense(expenseName: String, expenseTotAmount: NSDecimalNumber) -> Bool {
        let isValidated = true
        if (expenseName == ""){
            SpendAppUtils.showAlertMessage(viewController: self, title: "Input Error", message: "Please enter a Name for the expense")
            return false
        }
        
        if expenseTotAmount.decimalValue <= SpendAppUtils.minExpenseAmount || expenseTotAmount.decimalValue > SpendAppUtils.maxBudgetAmount{
            SpendAppUtils.showAlertMessage(viewController: self, title: "Input Error", message: "Expense amount is not within the valid range")
            return false
        }
        
        var remainingAmount = expensesViewController!.graphicsPieViewController?.remaining ?? 0.0
        
        if let expense = expense {
            let expenseAmountVal = SpendAppUtils.totalAmountCal(expenseType: expense.occurrence ?? "", startDate: expense.date ?? Date(), unitAmount: expense.amount ?? 0)
            
            remainingAmount += expenseAmountVal as Decimal
        }
        
        print("Validation: \(remainingAmount)")
        
        if remainingAmount < expenseTotAmount as Decimal {
            SpendAppUtils.showAlertMessage(viewController: self, title: "Input Error", message: "Expense amount exceeds the allocated budget for the Category")
            return false
        }
        
        return isValidated
    }
    
    
    
}

extension Date {

    var endDateMonth: Date {
        
        let curCalendar = Calendar(identifier: .gregorian)
        let comps = curCalendar.dateComponents([.year, .month], from: self)
        let startMonth = curCalendar.date(from: comps)!
        
        var dateComps = DateComponents()
        dateComps.month = 1
        //dateComps.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: dateComps, to: startMonth)!
    }
}

// Apple Bug UISwitch - https://developer.apple.com/forums/thread/132035
