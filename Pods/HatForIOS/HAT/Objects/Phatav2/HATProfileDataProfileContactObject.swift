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

// MARK: - Struct

public struct HATProfileDataProfileContactObject: HATObject, HatApiType {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    struct Fields {
        
        static let mobile: String = "mobile"
        static let landline: String = "landline"
        static let primaryEmail: String = "primaryEmail"
        static let alternativeEmail: String = "alternativeEmail"
    }
    
    // MARK: - Variables

    /// The user's mobile number
    public var mobile: String = ""
    /// The user's landline
    public var landline: String = ""
    /// The user's primary email
    public var primaryEmail: String = ""
    /// The user's alternative email
    public var alternativeEmail: String = ""
    
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
        
        if let tempMobile = (dict[Fields.mobile]?.stringValue) {
            
            mobile = tempMobile
        }
        if let tempLandline = (dict[Fields.landline]?.stringValue) {
            
            landline = tempLandline
        }
        if let tempPrimaryEmail = (dict[Fields.primaryEmail]?.stringValue) {
            
            primaryEmail = tempPrimaryEmail
        }
        if let tempAlternativeEmail = (dict[Fields.alternativeEmail]?.stringValue) {
            
            alternativeEmail = tempAlternativeEmail
        }
    }
    
    // MARK: - HatApiType protocol
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            Fields.mobile: self.mobile,
            Fields.landline: self.landline,
            Fields.primaryEmail: self.primaryEmail,
            Fields.alternativeEmail: self.alternativeEmail
        ]
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let json = JSON(fromCache)
        self.initialize(dict: json.dictionaryValue)
    }
}
