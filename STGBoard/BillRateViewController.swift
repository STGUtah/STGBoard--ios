//
//  BillRateViewController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/25/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit
import TextFieldEffects

class BillRateViewController: UIViewController {
    
    static let dismissNotificationName = Notification.Name("dismiss")
    @IBOutlet weak var salarySegmentedControl: UISegmentedControl!
    @IBOutlet weak var wageTextField: AkiraTextField!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: BillRateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wageTextField.placeholder = "Salary"
        wageTextField.keyboardType = .numberPad
        addAccessoryViewToTextfield()
        wageTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(forName: BillRateViewController.dismissNotificationName, object: nil, queue: OperationQueue.main) { (_) in
            self.wageTextField.resignFirstResponder()
        }
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addAccessoryViewToTextfield() {
        let toolbar:UIToolbar = UIToolbar()
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.wageTextField.inputAccessoryView = toolbar
    }
    
    @IBAction func salaryHourlySegmentedControllerChangeValue(_ sender: UISegmentedControl) {
        wageTextField.text = ""
        wageTextField.placeholder = salarySegmentedControl.selectedSegmentIndex == 0 ? "Salary" : "Hourly"
    }
    
    @objc private func doneButtonAction() {
        wageTextField.resignFirstResponder()
    }
    
    func myTextFieldDidChange(_ textField: UITextField) {
        switch salarySegmentedControl.selectedSegmentIndex {
        case 0:
            if let amountString = textField.text?.currencyInputFormattingForSalary() {
                textField.text = amountString
                guard var wageAmount = textField.text, wageAmount.characters.count > 0 else {
                    self.delegate?.updateFields(withWageType: salarySegmentedControl.selectedSegmentIndex == 0 ? .salary : .hourly, andWage: 0.00)
                    return
                }
                
                self.delegate?.updateFields(withWageType: salarySegmentedControl.selectedSegmentIndex == 0 ? .salary : .hourly, andWage: wageAmount.currencyDouble())
            }
        case 1:
            if let amountString = textField.text?.currencyInputFormattingForHourly() {
                textField.text = amountString
                guard var wageAmount = textField.text, wageAmount.characters.count > 0 else {
                    self.delegate?.updateFields(withWageType: salarySegmentedControl.selectedSegmentIndex == 0 ? .salary : .hourly, andWage: 0.00)
                    return
                }
                
                self.delegate?.updateFields(withWageType: salarySegmentedControl.selectedSegmentIndex == 0 ? .salary : .hourly, andWage: wageAmount.currencyDouble())
            }
        default: return
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let billRateCalcTVC = segue.destination as? BillRateCalculatorTableViewController {
            self.delegate = billRateCalcTVC
            billRateCalcTVC.frameOfView = containerView.frame.height
        }
    }
    
}

enum WageType {
    case hourly
    case salary
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormattingForSalary() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.generatesDecimalNumbers = false
        formatter.maximumFractionDigits = 0
        formatter.currencySymbol = "$"
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func currencyInputFormattingForHourly() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "$"
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double) / 100)
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func currencyDouble() -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        
        return formatter.number(from: self)!.doubleValue
    }
}

protocol BillRateViewControllerDelegate: class {
    func updateFields(withWageType wageType: WageType, andWage wage: Double)
}
