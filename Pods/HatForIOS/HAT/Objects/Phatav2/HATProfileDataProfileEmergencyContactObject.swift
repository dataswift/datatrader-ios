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

public struct HATProfileDataProfileEmergencyContactObject: HATObject, HatApiType {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    public struct Fields {
        
        static let relationship: String = "relationship"
        static let lastName: String = "lastName"
        static let mobile: String = "mobile"
        static let firstName: String = "firstName"
    }
    
    // MARK: - Variables

    /// The type of relationship with the user
    public var relationship: String = ""
    /// The last name of the emergency contact
    public var lastName: String = ""
    /// The mobile number of the emergency contact
    public var mobile: String = ""
    /// The first name of the emergency contact
    public var firstName: String = ""
    
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
        
        if let tempRelationship = (dict[Fields.relationship]?.stringValue) {
            
            relationship = tempRelationship
        }
        if let tempLastName = (dict[Fields.lastName]?.stringValue) {
            
            lastName = tempLastName
        }
        if let tempMobile = (dict[Fields.mobile]?.stringValue) {
            
            mobile = tempMobile
        }
        if let tempFirstName = (dict[Fields.firstName]?.stringValue) {
            
            firstName = tempFirstName
        }
    }
    
    // MARK: - HatApiType protocol
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            Fields.relationship: self.relationship,
            Fields.lastName: self.lastName,
            Fields.mobile: self.mobile,
            Fields.firstName: self.firstName
        ]
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let json = JSON(fromCache)
        self.initialize(dict: json.dictionaryValue)
    }
}
