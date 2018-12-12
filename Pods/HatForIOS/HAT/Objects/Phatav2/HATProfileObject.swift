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

public struct HATProfileObject: HATObject, HatApiType {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    public struct Fields {
        
        static let recordID: String = "id"
        static let endpoint: String = "endpoint"
        static let data: String = "data"
    }
    
    // MARK: - Variables
    
    /// The endpoint the data are coming from
    public var endpoint: String? = ""
    /// The record ID of the data
    public var recordId: String? = ""
    /// The data of the profile
    public var data: HATProfileDataObject = HATProfileDataObject()
    
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
    public init(from dict: Dictionary<String, JSON>) {
        
        self.init()
        
        self.initialize(dict: dict)
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dict: The JSON file received from the HAT
     */
    public mutating func initialize(dict: Dictionary<String, JSON>) {
        
        if let tempRecordId = (dict[Fields.recordID]?.stringValue) {
            
            recordId = tempRecordId
        }
        if let tempEndPoint = (dict[Fields.endpoint]?.stringValue) {
            
            endpoint = tempEndPoint
        }
        if let tempData = (dict[Fields.data]?.dictionaryValue) {
            
            data = HATProfileDataObject(dict: tempData)
        }
    }
    
    // MARK: - HatApiType Protocol
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let json = JSON(fromCache)
        self.initialize(dict: json.dictionaryValue)
    }
    
    // MARK: - JSON Mapper
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            Fields.endpoint: self.endpoint ?? "",
            Fields.recordID: self.recordId ?? "",
            Fields.data: self.data.toJSON()
        ]
    }
}
