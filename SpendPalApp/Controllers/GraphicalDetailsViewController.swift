//
//  GraphicalDetailsViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-20.
//

import UIKit

class GraphicalDetailsViewController: UIViewController {

    @IBOutlet weak var labelExCategory: UILabel!
    var expenseCategory = ""
    var category: Category?
    override func viewDidLoad() {
        super.viewDidLoad()
        labelExCategory.text = expenseCategory
    }

}
