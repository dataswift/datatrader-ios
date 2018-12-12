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

public struct HATNotesDataObject: HATObject, HatApiType {
    
    // MARK: - JSON Fields
    
    /// The possible Fields of the JSON struct
    public struct Fields {
        
        static let authorV1: String = "authorv1"
        static let photoV1: String = "photov1"
        static let locationV1: String = "locationv1"
        static let created_time: String = "created_time"
        static let public_until: String = "public_until"
        static let updated_time: String = "updated_time"
        static let shared: String = "shared"
        static let currently_shared: String = "currently_shared"
        static let shared_on: String = "shared_on"
        static let message: String = "message"
        static let kind: String = "kind"
    }
    
    // MARK: - Variables
    
    /// the author data
    public var authorv1: HATNotesAuthorObject = HATNotesAuthorObject()
    
    /// the photo data
    public var photov1: HATNotesPhotoObject?
    
    /// the location data
    public var locationv1: HATNotesLocationObject?
    
    /// creation date
    public var created_time: String = ""
    /// the date until this note will be public (don't know if it's optional or not)
    public var public_until: String?
    /// the updated time of the note
    public var updated_time: String = ""
    
    /// if true this note is shared to facebook etc.
    public var shared: Bool = false
    /// if true this note is shared to facebook etc.
    public var currently_shared: Bool = false
    
    /// If shared, where is it shared? Coma seperated string (don't know if it's optional or not)
    public var shared_on: [String] = []
    /// the actual message of the note
    public var message: String = ""
    /// the kind of the note. 3 types available note, blog or list
    public var kind: String = ""
    
    // MARK: - Initialiser
    
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
        
        self.inititialize(dict: dict)
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     */
    public mutating func inititialize(dict: Dictionary<String, JSON>) {
        
        let tempDict: Dictionary<String, JSON>
        if let temp = dict["notablesv1"]?.dictionaryValue {
            
            tempDict = temp
        } else {
            
            tempDict = dict
        }
        if let tempAuthorData = tempDict[Fields.authorV1]?.dictionary {
            
            authorv1 = HATNotesAuthorObject.init(dict: tempAuthorData)
        }
        
        if let tempPhotoData = tempDict[Fields.photoV1]?.dictionary {
            
            photov1 = HATNotesPhotoObject.init(dict: tempPhotoData)
        }
        
        if let tempLocationData = tempDict[Fields.locationV1]?.dictionary {
            
            locationv1 = HATNotesLocationObject.init(dict: tempLocationData)
        }
        
        if let tempSharedOn = tempDict[Fields.shared_on]?.arrayValue {
            
            for item in tempSharedOn {
                
                shared_on.append(item.stringValue)
            }
        }
        
        if let tempPublicUntil = tempDict[Fields.public_until]?.string {
            
            public_until = tempPublicUntil
        }
        
        if let tempCreatedTime = tempDict[Fields.created_time]?.string {
            
            created_time = tempCreatedTime
        }
        
        if let tempUpdatedTime = tempDict[Fields.updated_time]?.string {
            
            updated_time = tempUpdatedTime
        }
        
        if let tempShared = tempDict[Fields.shared]?.boolValue {
            
            shared = tempShared
        }
        if let tempCurrentlyShared = tempDict[Fields.currently_shared]?.boolValue {
            
            currently_shared = tempCurrentlyShared
        }
        
        if let tempMessage = tempDict[Fields.message]?.string {
            
            message = tempMessage
        }
        
        if let tempKind = tempDict[Fields.kind]?.string {
            
            kind = tempKind
        }
    }
    
    // MARK: - HatApiType Protocol
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            Fields.authorV1: authorv1.toJSON(),
            Fields.photoV1: photov1?.toJSON() ?? HATNotesPhotoObject().toJSON(),
            Fields.locationV1: locationv1?.toJSON() ?? HATNotesLocationObject().toJSON(),
            Fields.created_time: created_time,
            Fields.public_until: public_until ?? "",
            Fields.updated_time: updated_time,
            Fields.shared: shared,
            Fields.currently_shared: currently_shared,
            Fields.shared_on: shared_on,
            Fields.message: message,
            Fields.kind: kind
        ]
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let dictionary = JSON(fromCache)
        self.inititialize(dict: dictionary.dictionaryValue)
    }
}
