//
//  GraphicalDetailsViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-20.
//

import UIKit
import CoreData

class GraphicalDetailsViewController: UIViewController  {
    @IBOutlet weak var labelExCategory: UILabel!
    @IBOutlet weak var labelTotalBudget: UILabel!
    @IBOutlet weak var labelTotalSpent: UILabel!
    @IBOutlet weak var labelRemaining: UILabel!
    
    @IBOutlet var labelsGraphicView: [UILabel]!
    
    
    @IBOutlet var viewGraphics: UIView!
    var expenseCategory = ""
    var category: Category?
    var dataExpenses: [Decimal] = [1.0]
    var dataPieChart: [Float] = [1.0]
    var expensesFetch: [Expense]?
    var totalBudget: Decimal = 0
    var totalSpent: Decimal = 0
    var remaining: Decimal = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let expensesFetch = expensesFetch{
            labelTotalBudget.isHidden = false
            labelTotalSpent.isHidden = false
            labelRemaining.isHidden = false
            labelsGraphicView.forEach{$0.isHidden = false}
            
            dataCalc(expensesFetch: expensesFetch)
            
            labelExCategory.text = expenseCategory
            labelTotalBudget.text = "\(totalBudget)"
            labelTotalSpent.text = "\(totalSpent)"
            labelRemaining.text = "\(remaining)"

            SpendAppCustomGraphics.buildPieChartReduced(reduction:4, with: dataPieChart, on: viewGraphics, arcCenter: viewGraphics.center)
        }
    }
    
    func dataCalc(expensesFetch: [Expense]){
        
        if let category = self.category{
            
            expenseCategory = category.name ?? ""
            dataExpenses = expensesFetch.map { $0.amount?.decimalValue ?? 0.0 }
            dataPieChart = dataExpenses.map { Float(truncating: $0 as NSNumber ) }
            
            totalSpent = dataExpenses.reduce(0, +)
            totalBudget = category.monthlyBudget?.decimalValue ?? 0.0
            remaining = totalBudget - totalSpent

        }
        
    }

    
}

