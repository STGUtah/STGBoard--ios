//
//  BillRateCalculatorTableViewController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/25/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit

class BillRateCalculatorTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BillRateViewControllerDelegate {
    
    @IBOutlet weak var hourlyRateLabel: UILabel!
    @IBOutlet weak var taxesAndBenefitsLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var taxesAndBenfitisButton: UIButton!
    
    var wageType: WageType?
    var wage: Double?
    
    var hourlyRate: Double {
        guard let wage = wage, let wageType = wageType else { return 0.00 }
        switch wageType  {
        case .hourly: return wage
        case .salary: return wage / Double(KeyNumbers.yearlyHours)
        }
    }
    
    var taxesAndBenefitsDollarAmount: Double {
        return hourlyRate * KeyNumbers.estimatedTaxes + KeyNumbers.benefitDollarAmount + KeyNumbers.awardDollarAmount
    }
    
    var totalCostPerHour: Double {
        return hourlyRate + taxesAndBenefitsDollarAmount
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }


    @IBAction func taxesAndBenefitsButtonTapped(_ sender: UIButton) {
        
    }
    
    func updateCollectionView(withWageType wageType: WageType, andWage wage: Double) {
        self.wageType = wageType
        self.wage = wage
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "billRateCell", for: indexPath) as? BillRateCollectionViewCell else { return UICollectionViewCell() }
        
        cell.dollarLabel.text = "$3"
        cell.percentLabel.text = "%2"
        cell.titleLabel.text = String(describing: wage)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceBetweenCells: CGFloat = 8
        let dim = (collectionView.bounds.width - 2 * spaceBetweenCells) / 2
        return CGSize(width: dim, height: 90)
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
