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

import CoreLocation
import MapKit
import UserNotifications

// MARK: Class

internal class LocationManager: NSObject, CLLocationManagerDelegate, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    /// The delegate variable of the protocol for gps tracking
    weak var locationDelegate: LocationsDelegate?
    
    static let shared: LocationManager = LocationManager()
    
    // The region currently monitoring
    private var region: CLCircularRegion?
    
    /// The LocationManager responsible for the settings used for gps tracking
    var locationManager: CLLocationManager? = CLLocationManager()
    
    // MARK: - Initialiser
    
    override init() {
        
        super.init()
        
        self.setUpLocationManager()
        
        let authStatus = LocationManager.checkAuthorisation().1
        
        if authStatus != .notDetermined {
            
            self.resumeLocationServices()
        }
    }
    
    // MARK: - Set up location manager
    
    /**
     Sets up the location manager
     */
    private func setUpLocationManager() {
        
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = 100
        self.locationManager?.distanceFilter = 150
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.disallowDeferredLocationUpdates()
        self.locationManager?.pausesLocationUpdatesAutomatically = false
        self.locationManager?.activityType = .otherNavigation
        self.locationManager?.delegate = self
    }
    
    // MARK: - Location Manager Delegate Functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // add locations gather to database
        LocationObject.filterLocations(locationManager: manager, locations: locations, userDomain: userDomain, userString: userToken)
        
        // stop monitoring for regions
        self.stopMonitoringAllRegions()
        
        // create a new region
        self.region = CLCircularRegion(
            center: locations[locations.count - 1].coordinate,
            radius: 150,
            identifier: "UpdateCircle")
        self.region!.notifyOnExit = true
        
        // call delegate method
        self.locationDelegate?.updateLocations(locations: locations)
        
        // stop using gps and start monitoring for the new region
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.startMonitoring(for: region!)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        // create a new region everytime the user exits the region
        if region is CLCircularRegion {
            
            self.locationManager?.requestLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
        //let message = "Monitoring failed for region with identifier: \(region!.identifier)"
        //CrashLoggerHelper.customErrorLog(message: message, error: error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //let message = "Location Manager failed with the following error: \(error)"
        //CrashLoggerHelper.customErrorLog(message: message, error: error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
        if error != nil {
            
            //let message = "error: \(error!.localizedDescription), status code: \(String(describing: manager.monitoredRegions))"
            //CrashLoggerHelper.customErrorLog(message: message, error: error!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        self.resumeLocationServices()
    }
    // MARK: - Wrappers to enable disable tracking
    
    /**
     Start updating location
     */
    public func startUpdatingLocation() {
        
        /*
         If not authorised, we can ignore.
         Once user is logged in and has accepted the authorization, this will always be true
         */
        if let manager: CLLocationManager = locationManager {
            
            if let result = KeychainManager.getKeychainValue(key: KeychainConstants.trackDeviceKey) {
                
                if result == "true" {
                    
                    manager.requestLocation()
                }
            } else {
                
                KeychainManager.setKeychainValue(
                    key: KeychainConstants.trackDeviceKey,
                    value: KeychainConstants.Values.setTrue)
                self.stopMonitoringAllRegions()
                self.locationManager?.stopUpdatingLocation()
                self.locationManager = nil
                self.locationManager?.stopMonitoringSignificantLocationChanges()
            }
        }
    }
    
    /**
     Stop updating location
     */
    public func stopUpdatingLocation() {
        
        self.locationManager?.stopUpdatingLocation()
    }
    
    /**
     Stop monitoring ALL regions
     */
    public func stopMonitoringAllRegions() {
        
        if let regions = self.locationManager?.monitoredRegions {
            
            for region in regions {
                
                self.locationManager?.stopMonitoring(for: region)
            }
        }
        
        self.region = nil
    }
    
    /**
     Start monitoring for significant, >500m, location changes
     */
    public func startMonitoringSignificantLocationChanges() {
        
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    /**
     Stop monitoring for significant, >500m, location changes
     */
    public func stopMonitoringSignificantLocationChanges() {
        
        self.locationManager?.stopMonitoringSignificantLocationChanges()
    }
    
    /**
     Request user's location
     */
    public func requestLocation() {
        
        self.locationManager?.requestLocation()
    }
    
    /**
     Resume location services as they were previously, if user had locations disabled then disabled it.
     */
    public func resumeLocationServices() {
        
        let locationPermissionAsked = KeychainManager.getKeychainValue(key: KeychainConstants.locationScreenShown)
        if locationPermissionAsked == "true" {
            
            let result = KeychainManager.getKeychainValue(key: KeychainConstants.trackDeviceKey)
            
            if result == "true" {
                
                if self.locationManager == nil {
                    
                    self.setUpLocationManager()
                }
                self.locationManager?.requestAlwaysAuthorization()
                self.locationManager?.startUpdatingLocation()
                self.locationManager?.startMonitoringSignificantLocationChanges()
                self.locationManager?.requestLocation()
            } else if result == "false" {
                
                self.stopMonitoringAllRegions()
                self.locationManager?.stopUpdatingLocation()
                self.locationManager?.stopMonitoringSignificantLocationChanges()
                self.locationManager = nil
            } else {
                
                _ = KeychainManager.setKeychainValue(key: KeychainConstants.trackDeviceKey, value: KeychainConstants.Values.setTrue)
                
                if self.locationManager == nil {
                    
                    self.setUpLocationManager()
                }
                self.locationManager?.requestAlwaysAuthorization()
                self.locationManager?.startUpdatingLocation()
                self.locationManager?.startMonitoringSignificantLocationChanges()
                self.locationManager?.requestLocation()
            }
        }
    }
    
    /**
     Requests authorisation from user
     */
    public func requestAuthorisation() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            self.locationManager?.requestAlwaysAuthorization()
        }
    }
    
    public static func isLocationServiceEnabled() -> Bool {
        
        return CLLocationManager.locationServicesEnabled()
    }
    
    /**
     Checks if app is authorised to collect location data
     
     - returns: A tuple of Bool, true, and the type of the CLAuthorizationStatus
     */
    public class func checkAuthorisation() -> (Bool, CLAuthorizationStatus) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
                
            case .notDetermined:
                
                return (true, .notDetermined)
            case .restricted:
                
                return (true, .restricted)
            case .denied:
                
                return (true, .denied)
            case .authorizedAlways, .authorizedWhenInUse:
                
                return (true, .authorizedAlways)
            }
        }
        
        return (false, .denied)
    }
    
    // MARK: - Geocode
    
    /**
     Reverse geocode the address and produce an image of the map of that area
     
     - parameter address: The address to reverse geocode
     - parameter completion: A function to execute after generating the image of the map for that address
     */
    public class func geoCodeUsingAddress(address: String, completion: @escaping(UIImage) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            
            let geocoder: CLGeocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: { placemarks, error in
                
                guard let placemarks = placemarks else {
                    
                    return
                }
                
                if !placemarks.isEmpty {
                    
                    // Set the region of the map that is rendered.
                    if let location = placemarks[0].location?.coordinate {
                        
                        LocationManager.generateImageBaseOn(coordinates: location, completion: { image in
                            
                            completion(image)
                        })
                    }
                }
            })
        }
    }
    
    /**
     Reverse geocode the address and produce the coordinates of that address
     
     - parameter address: The address to reverse geocode
     - parameter completion: A function to execute after getting the coordinates for that address
     */
    public class func geoCodeUsingAddress(address: String, completionLocation: @escaping(CLLocationCoordinate2D) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            
            let geocoder: CLGeocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: { placemarks, error in
                
                guard let placemarks = placemarks else {
                    
                    return
                }
                
                if !placemarks.isEmpty {
                    
                    // Set the region of the map that is rendered.
                    if let location = placemarks[0].location?.coordinate {
                        
                        completionLocation(location)
                    }
                }
            })
        }
    }
    
    // MARK: - Generate images
    
    /**
     Generates the image based on the coordinates
     
     - parameter latitude: The latitude of the coordinate
     - parameter longitude: The longitude of the coordinate
     - parameter completion: A function to execute after generating the image
     */
    public class func generateImageBaseOn(latitude: Double, longitude: Double, completion: @escaping (UIImage) -> Void) {
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        LocationManager.generateImageBaseOn(coordinates: coordinates, completion: completion)
    }
    
    /**
     Generates the image based on the coordinates
     
     - parameter coordinates: The coordinates to generate image for
     - parameter completion: A function to execute upon generating the image
     */
    public class func generateImageBaseOn(coordinates: CLLocationCoordinate2D, completion: @escaping (UIImage) -> Void) {
        
        let scale = UIScreen.main.scale
        DispatchQueue.global(qos: .background).async {
            
            let mapSnapshotOptions = MKMapSnapshotter.Options()
            
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 300, longitudinalMeters: 300)
            mapSnapshotOptions.region = region
            
            // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
            mapSnapshotOptions.scale = scale
            
            // Set the size of the image output.
            mapSnapshotOptions.size = CGSize(width: 300, height: 300)
            
            // Show buildings and Points of Interest on the snapshot
            mapSnapshotOptions.showsBuildings = true
            mapSnapshotOptions.showsPointsOfInterest = true
            
            let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
            snapShotter.start { snapshot, error in
                
                if let image = snapshot?.image {
                    
                    completion(image)
                }
            }
        }
    }
}
