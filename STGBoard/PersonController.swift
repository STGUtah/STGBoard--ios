//
//  PersonController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/14/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import Foundation
import Reachability

class PersonController {
    
    static let shared = PersonController()
    
    let reachability: Reachability
    
    static let regionUpdateNotificationName = Notification.Name("RegionUpdateKey")
    
    private init(){
        reachability = Reachability()!
    }
    
    static private let loggedInUserKey = "LoggedInUser"
    
    static var currentLoggedInPerson: Person? {
        guard let personDictionary = UserDefaults.standard.object(forKey: PersonController.loggedInUserKey) as? [String : Any] else { return nil }
        return Person(dictionary: personDictionary)
    }
    
    private(set) var people: [Person] = [] {
        didSet {
            people = people.sorted(by: { $0.0.fullName.lowercased() < $0.1.fullName.lowercased() })
        }
    }
    
    let baseURL = URL(string: "http://localhost:8080/contacts")!
    
    func addNewPerson(email: String, firstName: String, lastName: String){
        let person = Person(email: email, firstName: firstName, lastName: lastName, isInOffice: false)
        putPersonOnServer(person: person) { person in
            self.people.append(person)
            self.save(person: person)
            NotificationCenter.default.post(name: PersonController.regionUpdateNotificationName, object: self)
        }
    }
    
    func save(person: Person) {
        UserDefaults.standard.set(person.dictionaryRepresentation, forKey: PersonController.loggedInUserKey)
    }
    
    func putPersonOnServer(person: Person, completion: @escaping (Person) -> Void) {
        
        var request = URLRequest(url: baseURL)
        
        request.httpBody = person.jsonData
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil else {
                print("No data returned from data task")
                return
            }
            
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Successfully saved data to endpoint.")
                guard let data = data else { return }
                guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any] else { return }
                if let downloadedPerson = Person(dictionary: jsonDictionary) {
                completion(downloadedPerson)
                }
            }
        }
        
        dataTask.resume()
        
    }
    
    func getAllPeopleFromServer(completion: @escaping ([Person]) -> Void) {
        
        let request = URLRequest(url: baseURL)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data returned from data task")
                completion([])
                return
            }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: [String : Any]], let contactsArray = jsonDictionary["_embedded"]?["contacts"] as? [[String : Any]] else {
                print("Could not serialize json \nResponse: \(String(describing: response))")
                completion([])
                return
            }
            
            let people = contactsArray.flatMap({ Person(dictionary: $0) })
            self.people = people
            
            completion(people)
        }
        
        dataTask.resume()
    }
    
    func updateDatabase(withPerson person: Person, to inOfficeStatus: Bool, completion: @escaping (_ success: Bool) -> Void) {
        
        guard let id = person.id else { print("There is no id for the current user. Cannot update database") ; return }
        
        var request = URLRequest(url: baseURL.appendingPathComponent(id))
        
        let httpBodyDictionary = ["inOffice" : inOfficeStatus]
        
        person.isInOffice = inOfficeStatus
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: httpBodyDictionary, options: .prettyPrinted)
        
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var success = false
            defer { completion(success) }
            
            guard data != nil else {
                print("No data returned from data task")
                return
            }
            
            if let error = error {
                print("Error: \(error)")
            } else {
                success = true
            }
        }
        dataTask.resume()
    }
    
    func isLocationAlwaysEnabled() -> Bool {
        
    }
    
    func isNetworkReachable() -> Bool {
        return reachability.connection != .none
    }
}
