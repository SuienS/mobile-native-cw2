//
//  ExpensesViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-18.
//

import UIKit

class ExpensesViewController: UIViewController {

    var expenseCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation to Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            switch segueId {
            
            case "toExpenseCategory":
                let destViewController = segue.destination as! GraphicalDetailsViewController
                if let exCategory = self.expenseCategory?.name{
                    destViewController.expenseCategory=exCategory
                }
                
            case "toAddExpense":
                let destViewController = segue.destination as! AddExpenseViewController
                if let exCategory = self.expenseCategory{
                    destViewController.expenseCategory=exCategory
                }
            default:
                break
            }
             
        }
    }

}
