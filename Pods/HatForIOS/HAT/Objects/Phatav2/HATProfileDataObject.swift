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

public struct HATProfileDataObject: HATObject, HatApiType {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    public struct Fields {
        
        static let about: String = "about"
        static let photo: String = "photo"
        static let online: String = "online"
        static let address: String = "address"
        static let contact: String = "contact"
        static let personal: String = "personal"
        static let emergencyContact: String = "emergencyContact"
        static let dateCreated: String = "dateCreated"
        static let dateCreatedLocal: String = "dateCreatedLocal"
        static let shared: String = "shared"
    }
    
    // MARK: - Variables
    
    /// The website object of user's profile
    public var about: HATProfileDataProfileAboutObject = HATProfileDataProfileAboutObject()
    /// The nickname object of user's profile
    public var photo: HATProfileDataProfilePhotoObject = HATProfileDataProfilePhotoObject()
    /// The primary email address object of user's profile
    public var online: HATProfileDataProfileOnlineObject = HATProfileDataProfileOnlineObject()
    /// The youtube object of user's profile
    public var address: HATProfileDataProfileAddressObject = HATProfileDataProfileAddressObject()
    /// The global addres object of user's profile
    public var contact: HATProfileDataProfileContactObject = HATProfileDataProfileContactObject()
    /// The youtube object of user's profile
    public var personal: HATProfileDataProfilePersonalObject = HATProfileDataProfilePersonalObject()
    /// The global addres object of user's profile
    public var emergencyContact: HATProfileDataProfileEmergencyContactObject = HATProfileDataProfileEmergencyContactObject()
    
    /// The date the profile was created in unix time stamp
    public var dateCreated: Int?
    /// The date the profile was created in ISO format
    public var dateCreatedLocal: String?
    /// Is profile shared
    public var shared: Bool = false
    
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
        
        if let tempAbout = (dict[Fields.about]?.dictionaryValue) {
            
            about = HATProfileDataProfileAboutObject(dict: tempAbout)
        }
        if let tempPhoto = (dict[Fields.photo]?.dictionaryValue) {
            
            photo = HATProfileDataProfilePhotoObject(dict: tempPhoto)
        }
        if let tempOnline = (dict[Fields.online]?.dictionaryValue) {
            
            online = HATProfileDataProfileOnlineObject(dict: tempOnline)
        }
        if let tempAddress = (dict[Fields.address]?.dictionaryValue) {
            
            address = HATProfileDataProfileAddressObject(dict: tempAddress)
        }
        if let tempContact = (dict[Fields.contact]?.dictionaryValue) {
            
            contact = HATProfileDataProfileContactObject(dict: tempContact)
        }
        if let tempPersonal = (dict[Fields.personal]?.dictionaryValue) {
            
            personal = HATProfileDataProfilePersonalObject(dict: tempPersonal)
        }
        if let tempEmergencyContact = (dict[Fields.emergencyContact]?.dictionaryValue) {
            
            emergencyContact = HATProfileDataProfileEmergencyContactObject(dict: tempEmergencyContact)
        }
        if let tempDateCreated = (dict[Fields.dateCreated]?.intValue) {
            
            dateCreated = tempDateCreated
        }
        if let tempDateCreatedLocal = (dict[Fields.dateCreatedLocal]?.stringValue) {
            
            dateCreatedLocal = tempDateCreatedLocal
        }
        if let tempShared = (dict[Fields.shared]?.boolValue) {
            
            shared = tempShared
        }
    }
    
    // MARK: - HatApiType protocol
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            Fields.about: self.about.toJSON(),
            Fields.photo: self.photo.toJSON(),
            Fields.online: self.online.toJSON(),
            Fields.address: self.address.toJSON(),
            Fields.contact: self.contact.toJSON(),
            Fields.personal: self.personal.toJSON(),
            Fields.emergencyContact: self.emergencyContact.toJSON(),
            Fields.dateCreated: self.dateCreated ?? Date().timeIntervalSince1970,
            Fields.dateCreatedLocal: self.dateCreatedLocal ?? HATFormatterHelper.formatDateToISO(date: Date()),
            Fields.shared: self.shared
        ]
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let json = JSON(fromCache)
        self.initialize(dict: json.dictionaryValue)
    }
}
