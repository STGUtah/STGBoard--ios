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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let locationManager = CLLocationManager()
    
    let stgRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.75694, longitude: -111.882478), radius: 500, identifier: "STGHome")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Chameleon.setGlobalThemeUsingPrimaryColor(FlatTeal(), with: .light)
        
        guard PersonController.currentLoggedInPerson != nil else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
            window?.rootViewController = vc
            return true
        }
        
        locationManager.delegate = self
        
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        
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
        PersonController.shared.updateDatabase(withPerson: person, with: true) { (_) in
            NotificationCenter.default.post(name: PersonController.regionUpdateNotificationName, object: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited Region")
        guard let person = PersonController.currentLoggedInPerson else { return }
        PersonController.shared.updateDatabase(withPerson: person, with: false) { (_) in
            NotificationCenter.default.post(name: PersonController.regionUpdateNotificationName, object: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated Location")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.startMonitoring(for: stgRegion)
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
}

