//
//  TaxesAndBenefitsTableViewController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/29/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit

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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func okayButtonTapped(_ sender: UIButton) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


}
