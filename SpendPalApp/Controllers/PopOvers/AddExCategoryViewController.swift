//
//  AddExCategoryViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-19.
//

import UIKit
import CoreData

class AddExCategoryViewController: UIViewController {

    @IBOutlet weak var textFieldCategoryName: UITextField!
    @IBOutlet weak var textFieldBudget: UITextField!
    @IBOutlet weak var textFieldNotes: UITextField!
    @IBOutlet weak var segmentedControlColourCode: UISegmentedControl!
    var colourCode: String = "Green"
    
    var expenseCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptEditLoad(category: expenseCategory)
        valueChangedSegControlColourCode(self.segmentedControlColourCode)
    }
    
    @IBAction func buttonCategorySavePressed(_ sender: UIButton) {

        let categoryName = textFieldCategoryName.text
        let strBudgetVal = textFieldBudget.text ?? "0"
        let budgetVal = SpendAppUtils.toNSDecimal(strBudgetVal)
        if (categoryName != "") && budgetVal.decimalValue >= 0.0 && budgetVal.decimalValue < Decimal.greatestFiniteMagnitude{
            let exCategory = Category(context:SpendAppUtils.managedAppObjContext)
            exCategory.name = categoryName
            exCategory.monthlyBudget = budgetVal
            exCategory.colour = colourCode
            exCategory.notes = textFieldNotes.text
            SpendAppUtils.managedAppObj.saveContext()
            dismiss(animated: true, completion: nil)
        } else {
            print("Error Input!")
        }
        
    }
    
    @IBAction func buttonCategoryEditPressed(_ sender: UIButton) {
//        expenseCategory?.name = textFieldCategoryName.text
//        expenseCategory?.monthlyBudget = textFieldBudget.text
//        expenseCategory?.colour = colourCode
//        expenseCategory?.notes = textFieldNotes.text
//        SpendAppUtils.managedAppObj.saveContext()
//        dismiss(animated: true, completion: nil)
        
        let categoryName = textFieldCategoryName.text
        let strBudgetVal = textFieldBudget.text ?? "0"
        let budgetVal = SpendAppUtils.toNSDecimal(strBudgetVal)
        if (categoryName != "") && budgetVal.decimalValue >= 0.0 && budgetVal.decimalValue < Decimal.greatestFiniteMagnitude{
            expenseCategory?.name = categoryName
            expenseCategory?.monthlyBudget = budgetVal
            expenseCategory?.colour = colourCode
            expenseCategory?.notes = textFieldNotes.text
            SpendAppUtils.managedAppObj.saveContext()
            dismiss(animated: true, completion: nil)
        } else {
            print("Error Input!")
        }
    }
    
    
    @IBAction func valueChangedSegControlColourCode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sender.selectedSegmentTintColor = UIColor.systemGreen
            colourCode = "Green"
        case 1:
            sender.selectedSegmentTintColor = UIColor.systemBlue
            colourCode = "Blue"

        case 2:
            sender.selectedSegmentTintColor = UIColor.systemYellow
            colourCode = "Yellow"

        case 3:
            sender.selectedSegmentTintColor = UIColor.systemPink
            colourCode = "Pink"

        case 4:
            sender.selectedSegmentTintColor = UIColor.systemPurple
            colourCode = "Purple"

        case 5:
            sender.selectedSegmentTintColor = UIColor.systemTeal
            colourCode = "Teal"

        default:
            sender.selectedSegmentTintColor = UIColor.systemBlue
            colourCode = "DEFAULT"
        }
    }
    
    func attemptEditLoad(category: Category?) {
        if let category = category {
            textFieldCategoryName.text = category.name
            textFieldBudget.text = "\(category.monthlyBudget?.decimalValue ?? 0.0)"
            textFieldNotes.text = category.notes
            segmentedControlColourCode.selectedSegmentIndex = SpendAppUtils.colourCodesIndex[category.colour ?? "Blue"] ?? 0
        }
    }

}
