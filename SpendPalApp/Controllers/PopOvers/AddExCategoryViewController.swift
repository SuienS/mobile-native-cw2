/**
 Author      : Rammuni Ravidu Suien Silva
 UoW No   : 16267097 || IIT No: 2016134
 Mobile Native Development - Coursework 2
 
 File Desc: ViewController for Add Category Add/Edit Popover
 */
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
    
    // Default colour
    var colourCode: String = "Green"
    
    var expenseCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptEditLoad(category: expenseCategory)
        valueChangedSegControlColourCode(self.segmentedControlColourCode)
        
        // Removing the toolbar of the built in keyboard
        let textFieldsAll = [textFieldCategoryName,textFieldBudget,textFieldNotes]
        textFieldsAll.forEach{txt in
            let kbItems : UITextInputAssistantItem = txt?.inputAssistantItem ?? UITextInputAssistantItem()
            kbItems.leadingBarButtonGroups = []
            kbItems.trailingBarButtonGroups = []
        }
        
    }
    
    
    // MARK: - Action Handles
    
    // Saving the inserted data into the CoreData
    @IBAction func buttonCategorySavePressed(_ sender: UIButton) {

        let categoryName = textFieldCategoryName.text ?? ""
        let strBudgetVal = textFieldBudget.text ?? "0"
        let budgetVal = SpendAppUtils.toNSDecimal(strBudgetVal)
        
        // Validation of the inputs
        if isValidExCategory(categoryName: categoryName, categoryAmount: budgetVal){
            let exCategory = Category(context:SpendAppUtils.managedAppObjContext)
            exCategory.name = categoryName
            exCategory.monthlyBudget = budgetVal
            exCategory.colour = colourCode
            exCategory.notes = textFieldNotes.text
            exCategory.profile = SpendAppUtils.profile
            
            // Saving Data to CoreData
            SpendAppUtils.managedAppObj.saveContext()
            
            dismiss(animated: true, completion: nil)
        } else {
            print("Error Input!")
        }
        
    }
    
    // Saving the editted data into the CoreData
    @IBAction func buttonCategoryEditPressed(_ sender: UIButton) {
        
        let categoryName = textFieldCategoryName.text ?? ""
        let strBudgetVal = textFieldBudget.text ?? "0"
        let budgetVal = SpendAppUtils.toNSDecimal(strBudgetVal)
        
        // Validation
        if isValidExCategory(categoryName: categoryName, categoryAmount: budgetVal){
            expenseCategory?.name = categoryName
            expenseCategory?.monthlyBudget = budgetVal
            expenseCategory?.colour = colourCode
            expenseCategory?.notes = textFieldNotes.text
            
            // Saving to CoreData
            SpendAppUtils.managedAppObj.saveContext()
            
            dismiss(animated: true, completion: nil)
        } else {
            print("Error Input!")
        }
    }
    
    // Colour code for Category
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
    
    // MARK: - Utility Functions
    
    // Check whether the used tries to edit
    func attemptEditLoad(category: Category?) {
        if let category = category {
            textFieldCategoryName.text = category.name
            textFieldBudget.text = "\(category.monthlyBudget?.decimalValue ?? 0.0)"
            textFieldNotes.text = category.notes
            segmentedControlColourCode.selectedSegmentIndex = SpendAppUtils.colourCodesIndex[category.colour ?? "Blue"] ?? 0
        }
    }
    
    
    // MARK: - Validations
    
    // Function for all the validations related to adding a new Category
    func isValidExCategory(categoryName: String, categoryAmount: NSDecimalNumber) -> Bool {
        let isValidated = true
        if (categoryName == ""){
            SpendAppUtils.showAlertMessage(activeVC: self, title: "Input Error", message: "Please enter a Name for the Expense Category")
            return false
        }
        
        // Limiting the budget amounts
        if categoryAmount.decimalValue <= SpendAppUtils.minCategoryAmount || categoryAmount.decimalValue > SpendAppUtils.maxBudgetAmount{
            SpendAppUtils.showAlertMessage(activeVC: self, title: "Input Error", message: "Expense Category amount is not within the valid range")
            return false
        }

        return isValidated
    }

}
