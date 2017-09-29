//
//  BillRateCalculatorTableViewController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/25/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit
import ChameleonFramework
import Presentr

class BillRateCalculatorTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BillRateViewControllerDelegate {
    
    @IBOutlet weak var hourlyRateLabel: UILabel!
    @IBOutlet weak var taxesAndBenefitsLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var taxesAndBenfitisButton: UIButton!
    @IBOutlet weak var benefitsSwitch: UISwitch!
    
    var wageType: WageType?
    var wage: Double?
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    
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
        return hourlyRate * KeyNumbers.estimatedTaxes + (benefitsSwitch.isOn ? KeyNumbers.benefitDollarAmount : 0) + KeyNumbers.awardDollarAmount
    }
    
    var totalCostPerHour: Double {
        return hourlyRate + taxesAndBenefitsDollarAmount
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        benefitsSwitch.isOn = true
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.allowsSelection = false
        taxesAndBenfitisButton.backgroundColor = FlatTealDark()
        taxesAndBenfitisButton.layer.cornerRadius = taxesAndBenfitisButton.bounds.height / 2
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        tableView.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    func tapRecognized() {
        NotificationCenter.default.post(name: BillRateViewController.dismissNotificationName, object: self)
    }

    let presenter: Presentr = {
        let taxesAndBenefitsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "taxesAndBenefitsTVC") as! TaxesAndBenefitsTableViewController
        let width = ModalSize.fluid(percentage: 0.9)
        let height = ModalSize.custom(size: 344)
        let center = ModalCenterPosition.center
        
        let customPresenter = Presentr(presentationType: .custom(width: width, height: height, center: center))
        let customTransition = CrossDissolveAnimation(options: .normal(duration: 0.2))
        customPresenter.dismissTransitionType = TransitionType.custom(customTransition)
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = 15
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissAnimated = true
        return customPresenter
    }()

    @IBAction func taxesAndBenefitsButtonTapped(_ sender: UIButton) {
        let taxesAndBenefitsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "taxesAndBenefitsTVC")
        customPresentViewController(presenter, viewController: taxesAndBenefitsVC, animated: true, completion: nil)
    }
    
    @IBAction func benefitsSwitchChangedValue(_ sender: UISwitch) {
        guard let wageType = wageType, let wage = wage else { return }
        updateFields(withWageType: wageType, andWage: wage)
    }
    
    func updateFields(withWageType wageType: WageType, andWage wage: Double) {
        self.wageType = wageType
        self.wage = wage
        self.hourlyRateLabel.text = hourlyRate.currencyString
        self.taxesAndBenefitsLabel.text = taxesAndBenefitsDollarAmount.currencyString
        self.totalCostLabel.text = "\(totalCostPerHour.currencyString) /hr"
        collectionView.reloadData()
    }
    
    var frameOfView: CGFloat?
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row == 4 else { return super.tableView(tableView, heightForRowAt: indexPath) }
        return tableView.layer.preferredFrameSize().height - (4 * 44) + 12
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
        return CGSize(width: dim, height: 70)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            self.tapRecognized()
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
    
    var percentString2Decimals: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        guard let result = formatter.string(from: self as NSNumber) else { return "" }
        return result
    }
}
