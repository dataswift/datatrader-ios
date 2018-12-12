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

import SwiftyJSON

// MARK: Struct

public struct HATLocationsDataObject: HATObject, HatApiType {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    public struct Fields {
        
        static let altitude: String = "altitude"
        static let latitude: String = "latitude"
        static let course: String = "course"
        static let horizontalAccuracy: String = "horizontalAccuracy"
        static let verticalAccuracy: String = "verticalAccuracy"
        static let longitude: String = "longitude"
        static let speed: String = "speed"
        static let dateCreated: String = "dateCreated"
        static let dateCreatedLocal: String = "dateCreatedLocal"
        static let floor: String = "floor"
    }
    
    // MARK: - Variables
    
    /// The location's latitude
    public var latitude: Double = 0
    /// The location's longitude
    public var longitude: Double = 0
    /// The location's date created as unix time stamp
    public var dateCreated: Int = 0
    /// The location's date created as an ISO format
    public var dateCreatedLocal: String = ""
    /// The location's speed date
    public var speed: Float?
    /// The location's floor date
    public var floor: Int?
    /// The location's vertical accuracy
    public var verticalAccuracy: Float?
    /// The location's horizontal accuracy
    public var horizontalAccuracy: Float?
    /// The location's altitude data
    public var altitude: Float?
    /// The location's course data
    public var course: Float?
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dict: The JSON file received from the HAT
     */
    public init(dict: Dictionary<String, JSON>) {
        
        // check for values and assign them if not empty
        if let tempAltitude = dict[Fields.altitude]?.floatValue {
            
            altitude = tempAltitude
        }
        
        if let tempVerticalAccuracy = dict[Fields.verticalAccuracy]?.floatValue {
            
            verticalAccuracy = tempVerticalAccuracy
        }
        
        if let tempHorizontalAccuracy = dict[Fields.horizontalAccuracy]?.floatValue {
            
            horizontalAccuracy = tempHorizontalAccuracy
        }
        
        if let tempLatitude = dict[Fields.latitude]?.doubleValue {
            
            latitude = tempLatitude
        }
        
        if let tempLongitude = dict[Fields.longitude]?.doubleValue {
            
            longitude = tempLongitude
        }
        
        if let tempHeading = dict[Fields.course]?.floatValue {
            
            course = tempHeading
        }
        
        if let tempFloor = dict[Fields.floor]?.intValue {
            
            floor = tempFloor
        }
        
        if let tempSpeed = dict[Fields.speed]?.floatValue {
            
            speed = tempSpeed
        }
        
        if let tempDateCreated = dict[Fields.dateCreated]?.intValue {
            
            dateCreated = tempDateCreated
        }
        
        if let tempDateCreatedLocal = dict[Fields.dateCreatedLocal]?.stringValue {
            
            dateCreatedLocal = tempDateCreatedLocal
        }
    }
    
    /**
     It initialises everything from the received Dictionary file from the cache
     
     - fromCache: The Dictionary file received from the cache
     */
    public func initialize(fromCache: Dictionary<String, Any>) {
        
    }
    
    // MARK: - JSON Mapper
    
    /**
     Returns the object as Dictionary, JSON
     
     - returns: Dictionary<String, String>
     */
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            
            Fields.altitude: self.altitude ?? 0,
            Fields.verticalAccuracy: self.verticalAccuracy ?? 0,
            Fields.horizontalAccuracy: self.horizontalAccuracy ?? 0,
            Fields.latitude: self.latitude,
            Fields.course: self.course ?? 0,
            Fields.floor: self.floor ?? 0,
            Fields.dateCreated: self.dateCreated,
            Fields.dateCreatedLocal: self.dateCreatedLocal,
            Fields.longitude: self.longitude,
            Fields.speed: self.speed ?? 0
        ]
    }
}
