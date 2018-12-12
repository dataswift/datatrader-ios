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

public struct HATProfileAddress: HatApiType {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    private struct Fields {
        
        static let streetAddress: String = "streetAddress"
        static let houseNumber: String = "houseNumber"
        static let postCode: String = "postCode"
    }
    
    // MARK: - Variables
    
    /// The user's street address
    public var streetAddress: String = ""
    /// The user's house number
    public var houseNumber: String = ""
    /// The user's post code
    public var postCode: String = ""

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
    public init(from dict: JSON) {
        
        self.initialize(dict: dict.dictionaryValue)
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dict: The JSON file received from the HAT
     */
    public mutating func initialize(dict: Dictionary<String, JSON>) {
        
        if let tempStreetAddress = (dict[Fields.streetAddress]?.stringValue) {
            
            streetAddress = tempStreetAddress
        }
        
        if let tempHouseNumber = (dict[Fields.houseNumber]?.stringValue) {
            
            houseNumber = tempHouseNumber
        }
        
        if let tempPostCode = (dict[Fields.postCode]?.stringValue) {
            
            postCode = tempPostCode
        }
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let json = JSON(fromCache)
        self.initialize(dict: json.dictionaryValue)
    }
    
    // MARK: - To JSON
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            
            Fields.streetAddress: self.streetAddress,
            Fields.houseNumber: self.houseNumber,
            Fields.postCode: self.postCode
        ]
    }
}
