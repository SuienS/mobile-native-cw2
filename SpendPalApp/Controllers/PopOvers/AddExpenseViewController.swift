//
//  AddExpenseViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-20.
//

import UIKit

class AddExpenseViewController: UIViewController {

    @IBOutlet weak var textFieldExpenseName: UITextField!
    @IBOutlet weak var textFieldExpenseAmount: UITextField!
    @IBOutlet weak var datePicketDate: UIDatePicker!
    @IBOutlet weak var switchReminder: UISwitch!
    @IBOutlet weak var segControllerOccurence: UISegmentedControl!
    @IBOutlet weak var textFieldNotes: UITextField!
    
    var expenseCategory:Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonExpenseSavePressed(_ sender: UIButton) {
        let expenseName = textFieldExpenseName.text
        let strAmountVal = textFieldExpenseAmount.text ?? "0"
        let amountVal = SpendAppUtils.toNSDecimal(strAmountVal)
        if (expenseName != "") && amountVal.decimalValue >= 0.0 && amountVal.decimalValue < Decimal.greatestFiniteMagnitude{
            let expense = Expense(context:SpendAppUtils.managedAppObjContext)
            expense.name = expenseName
            expense.amount = amountVal
            expense.date = datePicketDate.date
            expense.occurrence = segControllerOccurence.titleForSegment(at: segControllerOccurence.selectedSegmentIndex)
            expense.dueReminder = switchReminder.isOn
            expense.notes = textFieldNotes.text
            expenseCategory?.addToExpenses(expense)
            SpendAppUtils.managedAppObj.saveContext()
            dismiss(animated: true, completion: nil)
        }
    }
    

}
