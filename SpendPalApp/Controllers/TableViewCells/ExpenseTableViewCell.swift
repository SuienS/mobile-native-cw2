//
//  ExpenseTableViewCell.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-20.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldExpenseName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
