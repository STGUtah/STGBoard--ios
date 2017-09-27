//
//  KeyNumbers.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/27/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import Foundation

struct KeyNumbers {
    
    static let yearlyHours = 1904
    
    static let benefitDollarAmount = 9.00
    static let awardDollarAmount = 1.00
    
    // Taxes
    static let socialSecurityAndMedicare = 0.0775
    static let stateUnemployment = 0.02
    static let federalUnemployment = 0.006
    static let workersComp = 0.015
    static let k401kMatching = 0.03
    
    static let estimatedTaxes = 0.15
    static var taxTotal: Double {
        return socialSecurityAndMedicare +
            stateUnemployment +
            federalUnemployment +
            workersComp +
            k401kMatching
    }
    
    // Cell Numbers
    
    static let percentagePoints: [Double] = [0.35, 0.30, 0.25, 0.20, 0.23, 0.23]
    static let dollarPoints: [Double] = [35.00, 30.00, 25.00, 20.00, 23.00, 15.00]
    
}
