//
//  AddExCategoryViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-19.
//

import UIKit

class AddExCategoryViewController: UIViewController {

    @IBOutlet weak var textFieldCategoryName: UITextField!
    @IBOutlet weak var textFieldBudget: UITextField!
    @IBOutlet weak var textFieldNotes: UITextField!
    @IBOutlet weak var segmentedControlColourCode: UISegmentedControl!
    var colourCode: String = "Green"
    override func viewDidLoad() {
        super.viewDidLoad()
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
    

}