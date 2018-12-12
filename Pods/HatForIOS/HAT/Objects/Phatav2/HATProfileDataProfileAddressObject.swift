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

public struct HATProfileDataProfileAddressObject: HATObject, HatApiType {

    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    struct Fields {
        
        static let city: String = "city"
        static let county: String = "county"
        static let country: String = "country"
    }
    
    // MARK: - Variables
    
    /// The user's city
    public var city: String = ""
    /// The user's county
    public var county: String = ""
    /// The user's country
    public var country: String = ""
    
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
        
        self.init()
        
        self.initialize(dict: dict)
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dict: The JSON file received from the HAT
     */
    public mutating func initialize(dict: Dictionary<String, JSON>) {
        
        if let tempCity = (dict[Fields.city]?.stringValue) {
            
            city = tempCity
        }
        if let tempCounty = (dict[Fields.county]?.stringValue) {
            
            county = tempCounty
        }
        if let tempCountry = (dict[Fields.country]?.stringValue) {
            
            country = tempCountry
        }
    }
    
    // MARK: - HatApiType protocol
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            Fields.city: self.city,
            Fields.county: self.county,
            Fields.country: self.country
        ]
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let json = JSON(fromCache)
        self.initialize(dict: json.dictionaryValue)
    }
}
