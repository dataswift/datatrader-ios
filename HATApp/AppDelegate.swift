
/**
 * Copyright (C) 2018 HAT Data Exchange Ltd
 *
 * SPDX-License-Identifier: MPL2
 *
 * This file is part of the Hub of All Things project (HAT).
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/
 */

import Crashlytics
import Fabric
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UserCredentialsProtocol {

    var window: UIWindow?
    
    //let locationManager: LocationManager = LocationManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        RealmManager.migrateDB()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.openSansCondenstBold(ofSize: 16)]
        
        // define the interval for background fetch interval
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let taskID = beginBackgroundUpdateTask()
        if LocationObject.checkIfLocationsToSync(userDomain: userDomain, userToken: userToken, taskID: taskID) == true {
            
            completionHandler(.newData)
        } else {
            
            completionHandler(.noData)
            self.endBackgroundUpdateTask(taskID: taskID)
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        let url = userActivity.webpageURL
        
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else {
                
            if url != nil {
              
                application.open(url!, options: [:], completionHandler: nil)
            }
            
            return false
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

    // MARK: - oAuth handler function
    
    /*
     Callback handler oAuth
     */
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let urlHost: String = url.host else { return true }
        
        let stringURL = String(describing: url)
        if stringURL.contains("dismisssafari") {
            
            NotificationCenter.default.post(name: NotificationNamesConstants.dataPlugMessage, object: url)
        } else if stringURL.contains("dataDebitFailure") {
            
            NotificationCenter.default.post(name: NotificationNamesConstants.dataDebitFailure, object: url)
        }
            
        if urlHost == Auth.localAuthHost {
            
            let result: String? = KeychainManager.getKeychainValue(key: KeychainConstants.logedIn)
            if result == KeychainConstants.Values.expired {
                
                NotificationCenter.default.post(name: NotificationNamesConstants.reauthorisedUser, object: url)
            } else {
                
                NotificationCenter.default.post(name: NotificationNamesConstants.notificationHandlerName, object: url)
                
                KeychainManager.setKeychainValue(key: KeychainConstants.logedIn, value: KeychainConstants.Values.setTrue)
            }
        } else if urlHost == Auth.dataplugsapphost {
            
            NotificationCenter.default.post(name: NotificationNamesConstants.dataPlugMessage, object: url)
        } else if urlHost == Auth.dataDebitHost {
            
            NotificationCenter.default.post(name: NotificationNamesConstants.dataDebitAccepted, object: url)
        }
        
        return true
    }
    
    // MARK: - Background Task Functions
    
    // background task
    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        
        return UIApplication.shared.beginBackgroundTask(expirationHandler: {})
    }
    
    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier) {
        
        UIApplication.shared.endBackgroundTask(taskID)
    }
}
