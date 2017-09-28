//
//  AppDelegate.swift
//  STGBoard
//
//  Created by Ryan Plitt on 9/14/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import UIKit
import ChameleonFramework
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var lastUpdated: Date?
    
    let locationManager = CLLocationManager()
    let stgRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.75694, longitude: -111.882478), radius: 500, identifier: "STGHome")
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Chameleon.setGlobalThemeUsingPrimaryColor(FlatTeal(), with: .light)
        UIButton.appearance().backgroundColor = ClearColor()
        UIApplication.shared.statusBarStyle = .lightContent
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
        
        guard PersonController.currentLoggedInPerson != nil else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
            window?.rootViewController = vc
            return true
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate: CLLocationManagerDelegate {
    
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
            locationManager.startMonitoring(for: stgRegion)
            locationManager.startMonitoringVisits()
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

