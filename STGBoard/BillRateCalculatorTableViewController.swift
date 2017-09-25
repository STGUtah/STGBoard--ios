//
//  BillRateCalculatorTableViewController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/25/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit

class BillRateCalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var hourlyRateLabel: UILabel!
    @IBOutlet weak var taxesAndBenefitsLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var taxesAndBenfitisButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func taxesAndBenefitsButtonTapped(_ sender: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
