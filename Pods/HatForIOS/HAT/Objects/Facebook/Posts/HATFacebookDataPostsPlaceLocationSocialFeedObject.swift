//
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

// MARK: truct

public struct HATFacebookDataPostsPlaceLocationSocialFeedObject: HatApiType, HATObject {

    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    public struct Fields {
        
        static let zip: String = "zip"
        static let city: String = "city"
        static let street: String = "street"
        static let country: String = "country"
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
    }
    
    public var zip: String = ""
    public var city: String = ""
    public var street: String = ""
    public var country: String = ""
    public var latitude: Double = 0
    public var longitude: Double = 0

    public init() {
        
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dictionary: The JSON file received
     */
    public init(from dictionary: Dictionary<String, JSON>) {
        
        self.inititialize(dict: dictionary)
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dict: The JSON file received
     */
    public mutating func inititialize(dict: Dictionary<String, JSON>) {
        
        if let tempZip = dict[Fields.zip]?.stringValue {
            
            zip = tempZip
        }
        if let tempCity = dict[Fields.city]?.stringValue {
            
            city = tempCity
        }
        if let tempStreet = dict[Fields.street]?.stringValue {
            
            street = tempStreet
        }
        if let tempCountry = dict[Fields.country]?.stringValue {
            
            country = tempCountry
        }
        if let tempLatitude = dict[Fields.latitude]?.doubleValue {
            
            latitude = tempLatitude
        }
        if let tempLongitude = dict[Fields.longitude]?.doubleValue {
            
            longitude = tempLongitude
        }
    }
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            
            Fields.zip: self.zip,
            Fields.city: self.city,
            Fields.country: self.country,
            Fields.street: self.street,
            Fields.latitude: self.latitude,
            Fields.longitude: self.longitude
        ]
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let dictionary = JSON(fromCache)
        self.inititialize(dict: dictionary.dictionaryValue)
    }
}
