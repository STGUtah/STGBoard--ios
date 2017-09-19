//
//  PersonController.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/14/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import Foundation


class PersonController {
    
    static let shared = PersonController()
    
    static let regionUpdateNotificationName = Notification.Name("RegionUpdateKey")
    
    private init(){}
    
    static private let loggedInUserKey = "LoggedInUser"
    
    static var currentLoggedInPerson: Person? {
        guard let personDictionary = UserDefaults.standard.object(forKey: PersonController.loggedInUserKey) as? [String : Any] else { return nil }
        return Person(dictionary: personDictionary)
    }
    
    private(set) var people: [Person] = []
    
    let baseURL = URL(string: "http://localhost:8080/contacts")!
    
    func addNewPerson(email: String, firstName: String, lastName: String){
        let person = Person(email: email, firstName: firstName, lastName: lastName, isInOffice: false)
        people.append(person)
        save(person: person)
        putPersonOnServer(person: person)
    }
    
    func save(person: Person) {
        UserDefaults.standard.set(person.dictionaryRepresentation, forKey: PersonController.loggedInUserKey)
    }
    
    func putPersonOnServer(person: Person) {
        
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
                print("Successfully saved data to endpoint. \nResponse: \(String(describing: response?.description))")
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
    
    func updateDatabase(withPerson person: Person, with inOfficeStatus: Bool, completion: @escaping (_ success: Bool) -> Void) {
        
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
                print("Successfully saved data to endpoint. \nResponse: \(String(describing: response?.description))")
                success = true
            }
        }
        
        dataTask.resume()

    }
}
