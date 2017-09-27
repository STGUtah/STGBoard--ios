//
//  BillRateCollectionViewCell.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/25/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit

class BillRateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    func set(withDollarAmount dollarAmount: Double, andTotalCost totalCost: Double) {
        titleLabel.text = dollarAmount.currencyString
        leftLabel.text = (totalCost + dollarAmount).currencyString
        rightLabel.text = (1 - (totalCost / leftLabel.text!.currencyDouble())).percentString
    }
    
    func set(withPercentAmount percentAmount: Double, andTotalCost totalCost: Double) {
        titleLabel.text = percentAmount.percentString
        leftLabel.text = (totalCost / (1 - percentAmount)).currencyString
        rightLabel.text = (leftLabel.text!.currencyDouble() - totalCost).currencyString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
