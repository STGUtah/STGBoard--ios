//
//  Person.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/14/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import Foundation


struct Person {
    
    let email: String
    let firstName: String
    let lastName: String
    var isInOffice: Bool
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var dictionaryRepresentation: [String : Any] {
        return [
            "email" : email,
            "firstName" : firstName,
            "lastName" : lastName,
            "inOffice" : isInOffice
        ]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
}

extension Person {
    
    init?(dictionary: [String : Any]) {
        guard let email = dictionary["email"] as? String,
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let inOffice = dictionary["inOffice"] as? Bool else { return nil }
        
        self.init(email: email, firstName: firstName, lastName: lastName, isInOffice: inOffice)
    }
}
