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

import Alamofire
import CoreLocation
import HatForIOS
import RealmSwift
import SwiftyJSON
import UserNotifications

// MARK: Class

internal class LocationObject: Object, HATObject, UserCredentialsProtocol {

    // MARK: - Variables

    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var horizontalAccuracy: Double = -1
    @objc dynamic var verticalAccuracy: Double = -1
    @objc dynamic var dateCreated: Int = -1
    @objc dynamic var dateCreatedLocal: String = ""
    @objc dynamic var speed: Double = -1
    @objc dynamic var altitude: Double = -1
    @objc dynamic var course: Double = -1

    @objc dynamic var syncStatus: String = "unsynced"
    @objc dynamic var dateSyncStatusChanged: Int = -1
    @objc dynamic var dateSynced: Int = -1

    // MARK: - Initialisers

    func initialiseFrom(location: CLLocation) -> LocationObject {

        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.verticalAccuracy = location.verticalAccuracy
        self.horizontalAccuracy = location.horizontalAccuracy
        self.speed = location.speed
        self.course = location.course
        self.altitude = location.altitude
        self.dateCreated = Int(Date().timeIntervalSince1970)
        self.dateCreatedLocal = FormatterManager.formatDateToISO(date: Date())

        return self
    }

    // MARK: - Filter locations

    class func filterLocations(locationManager: CLLocationManager, locations: [CLLocation], userDomain: String, userString: String) {

        //get last location
        let latestLocation: CLLocation = locations[locations.count - 1]
        var dblocation: CLLocation? = nil

        if let dbLastPoint = RealmManager.getLastObject(type: LocationObject.self) {

            dblocation = CLLocation(latitude: (dbLastPoint.latitude), longitude: (dbLastPoint.longitude))
        }

        // test that the horizontal accuracy does not indicate an invalid measurement
        if latestLocation.horizontalAccuracy < 0 { return }

        // check we have a measurement that meets our requirements,
        if dblocation != nil {
            
            //calculate distance from previous spot
            let distance = latestLocation.distance(from: dblocation!)
            if !distance.isLess(than: latestLocation.horizontalAccuracy) {
                
                LocationObject.addLocationsToDB(locations: [latestLocation])
            }
        } else {
            
            LocationObject.addLocationsToDB(locations: [latestLocation])
        }

        LocationObject.syncLocationsToHAT(userDomain: userDomain, userToken: userString, completion: LocationObject.removeSyncedLocationsFromDB)
    }

    // MARK: - Get locations from db

    class func getLocationsFromDB() -> [LocationObject] {

        let realm = RealmManager.getRealm()

        let results = realm?.objects(LocationObject.self)

        var arrayToReturn: [LocationObject] = []
        for result in results! where !result.isInvalidated {

            arrayToReturn.append(result)
        }
        return arrayToReturn
    }
    
    class func getLocationsFromInMemoryDB() -> [LocationObject] {
        
        let realm = RealmManager.getInMemoryRealm()
        
        let results = realm?.objects(LocationObject.self)
        
        var arrayToReturn: [LocationObject] = []
        for result in results! where !result.isInvalidated {
            
            arrayToReturn.append(result)
        }
        return arrayToReturn
    }

    // MARK: - Add Locations To Database

    class func addLocationsToDB(locations: [CLLocation]) {

        guard !locations.isEmpty else {

            return
        }

        for location in locations {

            var locationObject = LocationObject()
            locationObject = locationObject.initialiseFrom(location: location)
            RealmManager.addData(type: [locationObject])
        }
    }
    
    class func addLocationsToMemoryDB(locations: [CLLocation]) {
        
        guard !locations.isEmpty else {
            
            return
        }
        
        var tempLocationArray: [LocationObject] = []
        
        for location in locations {
            
            var locationObject = LocationObject()
            locationObject = locationObject.initialiseFrom(location: location)
            tempLocationArray.append(locationObject)
        }
        
        RealmManager.addDataToInMemoryRealm(type: tempLocationArray)
    }

    class func removeSyncedLocationsFromDB(_ result: Bool) {

        guard let realm: Realm = RealmManager.getRealm() else {

            return
        }

        let sortProperties = [SortDescriptor(keyPath: "dateCreated", ascending: false)]
        let dbLocations: Results<LocationObject> = realm.objects(LocationObject.self).sorted(by: sortProperties)

        do {

            try realm.write {

                for location in dbLocations where !location.isInvalidated && location.syncStatus == "synced" {

                    realm.delete(location)
                }
            }
        } catch let error as NSError {

            print(error)
            print("error deleting objects")
        }
    }

    class func checkLocationForSync(location: LocationObject) -> LocationObject? {

        if location.syncStatus == "syncing" {

            let syncingDate = Date(timeIntervalSince1970: Double(location.dateSyncStatusChanged))
            let currentDate = Date()
            guard let minutes = Calendar.current.dateComponents([.minute], from: syncingDate, to: currentDate).minute else {

                return nil
            }

            if minutes > 5 {

                location.syncStatus = "unsynced"
                location.dateSyncStatusChanged = -1

                return location
            }
        } else if location.syncStatus == "unsynced" {

            return location
        }

        return nil
    }

    @discardableResult
    class func checkIfLocationsToSync(userDomain: String, userToken: String, taskID: UIBackgroundTaskIdentifier? =  nil, completionHandler: ((Bool) -> Void)? = nil) -> Bool {

        guard let realm: Realm = RealmManager.getRealm() else {

            return false
        }

        let sortProperties = [SortDescriptor(keyPath: "dateCreated", ascending: false)]
        let dbLocations: Results<LocationObject> = realm.objects(LocationObject.self).sorted(by: sortProperties).filter("%K like '%@'", "syncStatus", "unsynced")

        if dbLocations.count > 10 {

            LocationObject.syncLocationsToHAT(userDomain: userDomain, userToken: userToken, completion: LocationObject.removeSyncedLocationsFromDB, taskID: taskID)
            return true
        } else {

            completionHandler?(true)
            if taskID != nil {

                UIApplication.shared.endBackgroundTask(taskID!)
            }
        }

        return false
    }

    class func syncLocationsToHAT(userDomain: String, userToken: String, completion: ((Bool) -> Void)? = nil, taskID: UIBackgroundTaskIdentifier? = nil) {

        var array: [LocationObject] = []
        var arrayToUpload: [LocationObjectForUpload] = []

        guard let realm: Realm = RealmManager.getRealm(),
            userToken != "" else {

            return
        }

        let sortProperties = [SortDescriptor(keyPath: "dateCreated", ascending: false)]
        let dbLocations: Results<LocationObject> = realm.objects(LocationObject.self).sorted(by: sortProperties)

        do {

            try realm.write {

                for dbLocation in dbLocations where dbLocation.longitude != 0 && dbLocation.latitude != 0 && dbLocation.verticalAccuracy != 0 && !dbLocation.isInvalidated {

                    guard let location = LocationObject.checkLocationForSync(location: dbLocation) else {

                        continue
                    }

                    array.append(location)
                }
            }
        } catch let error as NSError {

            print(error)
        }

        if array.count > 100 {

            let temp = Array(array.prefix(100))
            array = temp
        }

        if array.count > 10 {

            do {

                try realm.write {

                    for location in array {

                        location.syncStatus = "syncing"
                        location.dateSyncStatusChanged = Int(Date().timeIntervalSince1970)

                        realm.add(location)
                    }
                }
            } catch let error as NSError {

                print(error)
            }

            for location in array {

                let tempLocation = LocationObjectForUpload(location: location)
                arrayToUpload.append(tempLocation)
            }
            
            let encoded = LocationObjectForUpload.encode(from: arrayToUpload)

            var urlRequest = URLRequest.init(url: URL(string: "https://\(userDomain)/api/v2.6/data/rumpel/locations/ios?skipErrors=true")!)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            urlRequest.addValue(userToken, forHTTPHeaderField: "x-auth-token")
            urlRequest.networkServiceType = .background
            urlRequest.httpBody = encoded

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {

                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let manager = Alamofire.SessionManager(configuration: configuration)
            
            manager.request(urlRequest).responseJSON(completionHandler: { response in

                let header = response.response?.allHeaderFields
                let token = header?["x-auth-token"] as? String
                let tokenToReturn = HATTokenHelper.checkTokenScope(token: token, applicationName: AppName.name)
                KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: tokenToReturn)

                if response.response?.statusCode == 400 && array.count > 10 {

                    Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { _ in

                        LocationObject.failbackDuplicateSyncing(dbLocations: array, userDomain: userDomain, userToken: userToken, completion: completion)
                    })
                } else if response.response?.statusCode == 201 {

                    do {

                        try realm.write {

                            for location in array {

                                location.syncStatus = "synced"
                                location.dateSyncStatusChanged = Int(Date().timeIntervalSince1970)
                            }
                            realm.add(array)
                        }
                    } catch let error as NSError {

                        print(error)
                    }

                    LocationObject.checkIfLocationsToSync(userDomain: userDomain, userToken: userToken, taskID: taskID, completionHandler: completion)
                }
            }).session.finishTasksAndInvalidate()
        } else {

            completion?(true)
            if taskID != nil {

                UIApplication.shared.endBackgroundTask(taskID!)
            }
        }
    }

    class func failbackDuplicateSyncing(dbLocations: [LocationObject], userDomain: String, userToken: String, completion: ((Bool) -> Void)?) {

        let midPoint = (dbLocations.count - 1) / 2
        let midPointNext = midPoint + 1
        let splitArray1 = Array(dbLocations[...midPoint])
        let splitArray2 = Array(dbLocations[midPointNext...])

        var urlRequest = URLRequest.init(url: URL(string: "https://\(userDomain)/api/v2.6/data/rumpel/locations/ios?skipErrors=true")!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue(userToken, forHTTPHeaderField: "x-auth-token")

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {

            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        func reccuring(array: [LocationObject], urlRequest: URLRequest, userDomain: String, userToken: String ) {

            var tempArray: [LocationObjectForUpload] = []

            for item in array {

                tempArray.append(LocationObjectForUpload(location: item))
            }
            var urlRequest = urlRequest
            let encoded = LocationObjectForUpload.encode(from: tempArray)
            urlRequest.httpBody = encoded
            
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let manager = Alamofire.SessionManager(configuration: configuration)
            
            manager.request(urlRequest).responseJSON(completionHandler: { response in

                if response.response?.statusCode == 400 && array.count > 1 {

                    Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { _ in

                        LocationObject.failbackDuplicateSyncing(dbLocations: array, userDomain: userDomain, userToken: userToken, completion: completion)
                    })
                } else {

                    guard let realm = RealmManager.getRealm() else {

                        completion?(true)
                        return
                    }

                    do {

                        try realm.write {

                            for location in array {

                                location.syncStatus = "synced"
                                location.dateSyncStatusChanged = Int(Date().timeIntervalSince1970)
                            }

                            realm.add(array)
                        }
                    } catch let error as NSError {

                        print(error)
                    }

                    completion?(true)
                }
            }).session.finishTasksAndInvalidate()
        }

        if !splitArray1.isEmpty {

            reccuring(array: splitArray1, urlRequest: urlRequest, userDomain: userDomain, userToken: userToken)
        }

        if !splitArray2.isEmpty {

            reccuring(array: splitArray2, urlRequest: urlRequest, userDomain: userDomain, userToken: userToken)
        }

        if dbLocations.count < 2 {

            completion?(true)
        }
    }
}
