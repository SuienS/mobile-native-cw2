/**
 Author      : Rammuni Ravidu Suien Silva
 UoW No   : 16267097 || IIT No: 2016134
 Mobile Native Development - Coursework 2
 
 File Desc: ViewController for Add Expense Add/Edit Popover
 */
//
//  AddExpenseViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-20.
//

import UIKit
import EventKit
import EventKitUI

class AddExpenseViewController: UIViewController {
    

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
        
        // Removing the toolbar of the built in keyboard
        let textFieldsAll = [textFieldNotes,textFieldExpenseName,textFieldExpenseName, textFieldExpenseAmount]
        textFieldsAll.forEach{txt in
            let kbItems : UITextInputAssistantItem = txt?.inputAssistantItem ?? UITextInputAssistantItem()
            kbItems.leadingBarButtonGroups = []
            kbItems.trailingBarButtonGroups = []
        }

    }
    
    
    // MARK: - Action Handles

    // Saving inst
    @IBAction func buttonExpenseSavePressed(_ sender: UIButton) {
        
        // Saving the inserted data into the CoreData
        let expenseName = textFieldExpenseName.text ?? ""
        let eventOccurrence = segControllerOccurence.titleForSegment(at: segControllerOccurence.selectedSegmentIndex) ?? ""
        let strAmountVal = textFieldExpenseAmount.text ?? "0"
        let amountValUnit = SpendAppUtils.toNSDecimal(strAmountVal)
        let amountVal = SpendAppUtils.totalAmountCal(expenseType: eventOccurrence, startDate: datePickerDate.date, unitAmount: amountValUnit)
                
        // Validation of the inputs
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
            
            // Saving Data to CoreData
            SpendAppUtils.managedAppObj.saveContext()
            
            if switchReminder.isOn {
                SpendAppUtils.attemptToAddSystemCalender(reminderEventStore: reminderSetEventStore, classDelegate: self, expense:expense, inst: expensesViewController)
            }

            dismiss(animated: true, completion: nil)
            
            expensesViewController?.barButtonEditExpense.isEnabled=false
        } else {
            print("Error Input!")
        }
    }
    
    // Saving the editted data into the CoreData
    @IBAction func buttonExpenseEditPressed(_ sender: UIButton) {
        
        let expenseName = textFieldExpenseName.text ?? ""
        let expenseAmount = textFieldExpenseAmount.text ?? "0"
        let expenseUnitAmountVal = SpendAppUtils.toNSDecimal(expenseAmount)
        let eventOccurrence = segControllerOccurence.titleForSegment(at: segControllerOccurence.selectedSegmentIndex) ?? ""
        let expenseAmountVal = SpendAppUtils.totalAmountCal(expenseType: eventOccurrence, startDate: datePickerDate.date, unitAmount: expenseUnitAmountVal)
        
        // Validation
        if isValidExpense(expenseName: expenseName, expenseTotAmount: expenseAmountVal) {
            
            expense?.name = expenseName
            expense?.amount = expenseAmountVal
            expense?.unitAmount = expenseUnitAmountVal
            expense?.date = datePickerDate.date
            expense?.notes = textFieldNotes.text
            expense?.occurrence = eventOccurrence
            
            let dueReminder = expense?.dueReminder ?? false
            expense?.dueReminder = switchReminder.isOn
            
            //Saving to CoreData
            SpendAppUtils.managedAppObj.saveContext()
            
            //Check whether the Reminder value has been editted
            if !dueReminder && switchReminder.isOn {
                SpendAppUtils.attemptToAddSystemCalender(reminderEventStore: reminderSetEventStore, classDelegate: self, expense:expense ?? Expense(), inst: expensesViewController)

            } else if dueReminder && !(switchReminder.isOn) {
                // remove event form calender [NI]
            }
            
            dismiss(animated: true, completion: nil)
            
            expensesViewController?.barButtonEditExpense.isEnabled=false
        } else {
            print("Error Input!")
        }
    }
    
    // MARK: - Utility Functions

    // Check whether the used tries to edit
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
    
    // MARK: - Validations
    
    // Function for all the validations related to adding a new Expense
    func isValidExpense(expenseName: String, expenseTotAmount: NSDecimalNumber) -> Bool {
        
        let isValidated = true
        if (expenseName == ""){
            SpendAppUtils.showAlertMessage(activeVC: self, title: "Input Error", message: "Please enter a Name for the expense")
            return false
        }
        
        // Limiting budget amounts
        if expenseTotAmount.decimalValue <= SpendAppUtils.minExpenseAmount || expenseTotAmount.decimalValue > SpendAppUtils.maxBudgetAmount{
            SpendAppUtils.showAlertMessage(activeVC: self, title: "Input Error", message: "Expense amount is not within the valid range")
            return false
        }
        
        var remainingAmount = expensesViewController!.graphicsPieViewController?.remaining ?? 0.0
        
        // Re calulating remaining amount for when Editting
        if let expense = expense {
            let expenseAmountVal = SpendAppUtils.totalAmountCal(expenseType: expense.occurrence ?? "", startDate: expense.date ?? Date(), unitAmount: expense.amount ?? 0)
            remainingAmount += expenseAmountVal as Decimal
        }
              
        // Check for sufficient budgets
        if remainingAmount < expenseTotAmount as Decimal {
            SpendAppUtils.showAlertMessage(activeVC: self, title: "Input Error", message: "Expense amount exceeds the allocated budget for the Category")
            return false
        }
        
        return isValidated
    }
    
    
    
}

// MARK: - Extenstions

// Extention for Date to get the end date of the month
extension Date {

    // End day of the month
    var endDateMonth: Date {
        let curCalendar = Calendar(identifier: .gregorian)
        let comps = curCalendar.dateComponents([.year, .month], from: self)
        let startMonth = curCalendar.date(from: comps)!
        
        var dateComps = DateComponents()
        dateComps.month = 1
        
        return Calendar(identifier: .gregorian).date(byAdding: dateComps, to: startMonth)!
    }
}

// Apple Bug UISwitch - https://developer.apple.com/forums/thread/132035
