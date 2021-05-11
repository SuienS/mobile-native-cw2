/**
 Author      : Rammuni Ravidu Suien Silva
 UoW No   : 16267097 || IIT No: 2016134
 Mobile Native Development - Coursework 2
 
 File Desc: UITableViewCell for Expenses
 */
//
//  ExpenseTableViewCell.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-20.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldExpenseName: UILabel!
    @IBOutlet weak var textFieldExpenseAmount: UILabel!
    @IBOutlet weak var textFieldDateNType: UILabel!
    @IBOutlet weak var viewBarChart: UIView!
    @IBOutlet weak var buttonCompletePay: UIButton!
    @IBOutlet weak var textFieldExpenseNotes: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
