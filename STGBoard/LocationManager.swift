//
//  LocationManager.swift
//  STGBoard
//
//  Created by Ryan Plitt on 10/2/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var lastUpdated: Date?
    
    static let shared = LocationManager()
    
    let manager: CLLocationManager
    
    let stgRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.75694, longitude: -111.882478), radius: 500, identifier: "STGHome")
    
    override init() {
        
        manager = CLLocationManager()
        
        super.init()
        
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region")
        guard let person = PersonController.currentLoggedInPerson else { return }
        PersonController.shared.updateDatabase(withPerson: person, to: true) { (_) in
            NotificationCenter.default.post(name: PersonController.regionUpdateNotificationName, object: self)
        }
        lastUpdated = Date()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited Region")
        guard let person = PersonController.currentLoggedInPerson else { return }
        PersonController.shared.updateDatabase(withPerson: person, to: false) { (_) in
            NotificationCenter.default.post(name: PersonController.regionUpdateNotificationName, object: self)
        }
        lastUpdated = Date()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            manager.startMonitoring(for: stgRegion)
            manager.startMonitoringVisits()
        } else {
            // TODO: Provide Error Handling if user is not always sharing location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // determine if the visit info needs to update the database or if the region monitoring has already updated it
        if let lastUpdated = lastUpdated {
            if visit.arrivalDate < lastUpdated && visit.departureDate < lastUpdated {
                print("The visit information is coming after the last boundary crossing. Doing nothing")
                return
            } else if visit.departureDate == Date.distantFuture {
                if visit.arrivalDate < lastUpdated {
                    print("The visit information is coming after the last boundary crossing. Doing nothing")
                    return
                }
            }
        }
        guard let currentLoggedOnPerson = PersonController.currentLoggedInPerson else { print("There is no logged in person") ; return }
        PersonController.shared.updateDatabase(withPerson: currentLoggedOnPerson, to: stgRegion.contains(visit.coordinate)) { (_) in
            NotificationCenter.default.post(name: PersonController.regionUpdateNotificationName, object: self)
        }
        lastUpdated = Date()
    }
    
    // TODO: Provide Better error handling here -->
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error with the location manager! \(error.localizedDescription)")
    }
}
