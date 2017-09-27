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
    
    let dataSource: [Double] = {
        var dataSource = [Double]()
        for i in 0..<KeyNumbers.percentagePoints.count {
            dataSource.append(KeyNumbers.percentagePoints[i])
            dataSource.append(KeyNumbers.dollarPoints[i])
        }
        return dataSource
    }()
    
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
    
    func updateFields(withWageType wageType: WageType, andWage wage: Double) {
        self.wageType = wageType
        self.wage = wage
        self.hourlyRateLabel.text = hourlyRate.currencyString
        self.taxesAndBenefitsLabel.text = taxesAndBenefitsDollarAmount.currencyString
        self.totalCostLabel.text = "\(totalCostPerHour.currencyString) /hr"
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "billRateCell", for: indexPath) as? BillRateCollectionViewCell else { return UICollectionViewCell() }
        
        let data = dataSource[indexPath.row]
        
        if data > 1.00 {
            cell.set(withDollarAmount: data, andTotalCost: totalCostPerHour)
        } else {
            cell.set(withPercentAmount: data, andTotalCost: totalCostPerHour)
        }
        
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

extension Double {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        guard let result = formatter.string(from: self as NSNumber) else { return "" }
        return result
    }
    
    var percentString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: Locale.current.identifier)
        guard let result = formatter.string(from: self as NSNumber) else { return "" }
        return result
    }
}
