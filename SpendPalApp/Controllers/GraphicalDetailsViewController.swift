//
//  GraphicalDetailsViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-20.
//

import UIKit

class GraphicalDetailsViewController: UIViewController {
    @IBOutlet weak var labelExCategory: UILabel!
    @IBOutlet var viewGraphics: UIView!
    var expenseCategory = ""
    var category: Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelExCategory.text = expenseCategory
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        SpendAppCustomGraphics.buildPieChart(with: [50,10,10,30,30,12.5,20.3], on: viewGraphics, arcCenter: viewGraphics.center)
        
    }
    
}

