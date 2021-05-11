/**
 Author      : Rammuni Ravidu Suien Silva
 UoW No   : 16267097 || IIT No: 2016134
 Mobile Native Development - Coursework 2
 
 File Desc: UITableViewCell for Category Cell
 */
//
//  ExCategoryTableViewCell.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-18.
//

import UIKit

class ExCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var textLabelExCategoryName: UILabel!
    @IBOutlet weak var textLabelCurrencySign: UILabel!
    @IBOutlet weak var textLabelBudgetAmount: UILabel!
    @IBOutlet weak var textLabelNotes: UILabel!
    @IBOutlet weak var labelColour: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
