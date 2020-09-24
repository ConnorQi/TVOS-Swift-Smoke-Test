//
//  AppDelegate.swift
//  tv-swift-release-test
//
//  Created by bys on 2019/8/27.
//  Copyright © 2019 bys. All rights reserved.
//

import UIKit
import CoreLocation
import AppCenter;
import AppCenterAnalytics;
import AppCenterCrashes;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MSCrashesDelegate, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager = CLLocationManager()
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MSAppCenter.setLogLevel(MSLogLevel.verbose);
        // Crashes Delegate.
        MSCrashes.setDelegate(self)
        MSAppCenter.start("6893e130-4850-4bb8-b563-e5dde72d7c10", withServices : [MSAnalytics.self, MSCrashes.self]);
        MSAppCenter.setLogUrl("https://in-integration.dev.avalanch.es");
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.requestWhenInUseAuthorization()
        MSCrashes.setUserConfirmationHandler({ (errorReports: [MSErrorReport]) in
            
            // Your code to present your UI to the user, e.g. an UIAlertController.
            let alertController = UIAlertController(title: "Sorry about that!",
                                                    message: "Do you want to send an anonymous crash report so we can fix the issue?",
                                                    preferredStyle:.alert)
            
            alertController.addAction(UIAlertAction(title: "Don't send", style: .cancel) {_ in
                MSCrashes.notify(with: .dontSend)
            })
            
            alertController.addAction(UIAlertAction(title: "Send", style: .default) {_ in
                MSCrashes.notify(with: .send)
            })
            
            alertController.addAction(UIAlertAction(title: "Always send", style: .default) {_ in
                MSCrashes.notify(with: .always)
            })
            
            // Show the alert controller.
            self.window?.rootViewController?.present(alertController, animated: true)
            return true // Return true if the SDK should await user confirmation, otherwise return false.
        })
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    
    
    // Crashes Delegate
    func crashes(_ crashes: MSCrashes!, shouldProcessErrorReport errorReport: MSErrorReport!) -> Bool {
        return true
    }
    
    func crashes(_ crashes: MSCrashes!, willSend errorReport: MSErrorReport!) {
    }
    
    func crashes(_ crashes: MSCrashes!, didSucceedSending errorReport: MSErrorReport!) {
    }
    
    func crashes(_ crashes: MSCrashes!, didFailSending errorReport: MSErrorReport!, withError error: Error!) {
    }
    
    func attachments(with crashes: MSCrashes, for errorReport: MSErrorReport) -> [MSErrorAttachmentLog] {
        let attachment1 = MSErrorAttachmentLog.attachment(withText: "Hello world!", filename: "hello.txt")
        let attachment2 = MSErrorAttachmentLog.attachment(withBinary: "Fake image".data(using: String.Encoding.utf8), filename: nil, contentType: "image/jpeg")
        return [attachment1!, attachment2!]
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error == nil {
                MSAppCenter.setCountryCode(placemarks?.first?.isoCountryCode)
            }
        }
    }
    
    func locationManager(_ Manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

}

