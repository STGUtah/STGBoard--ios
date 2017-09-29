//
//  TaxesAndBenefitsTableViewController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/29/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit
import ChameleonFramework

class TaxesAndBenefitsTableViewController: UITableViewController {
    
    @IBOutlet weak var socialSecurityMedicareLabel: UILabel!
    @IBOutlet weak var stateUnemploymentLabel: UILabel!
    @IBOutlet weak var federalUnemployment: UILabel!
    @IBOutlet weak var workersCompLabel: UILabel!
    @IBOutlet weak var k401kMatchingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var runningPercentageTotal: Double = 0
        
        socialSecurityMedicareLabel.text = KeyNumbers.socialSecurityAndMedicare.percentString2Decimals
        runningPercentageTotal += KeyNumbers.socialSecurityAndMedicare
        
        stateUnemploymentLabel.text = KeyNumbers.stateUnemployment.percentString2Decimals
        runningPercentageTotal += KeyNumbers.stateUnemployment
        
        federalUnemployment.text = KeyNumbers.federalUnemployment.percentString2Decimals
        runningPercentageTotal += KeyNumbers.federalUnemployment
        
        workersCompLabel.text = KeyNumbers.workersComp.percentString2Decimals
        runningPercentageTotal += KeyNumbers.workersComp
        
        k401kMatchingLabel.text = KeyNumbers.k401kMatching.percentString2Decimals
        runningPercentageTotal += KeyNumbers.k401kMatching
        
        totalLabel.text = runningPercentageTotal.percentString2Decimals
        
        
        okayButton.backgroundColor = FlatWhite()
        okayButton.tintColor = FlatTealDark()
    }
    
    @IBAction func okayButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = FlatWhite()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


}
