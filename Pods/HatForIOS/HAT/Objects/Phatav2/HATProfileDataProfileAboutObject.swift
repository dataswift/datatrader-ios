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

public struct HATProfileDataProfileAboutObject: HATObject, HatApiType {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    struct Fields {
        
        static let body: String = "body"
        static let title: String = "title"
    }
    
    // MARK: - Variables
    
    /// Body part of about
    public var body: String = ""
    /// Main part of about
    public var title: String = ""
    
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
    
        if let tempBody: String = (dict[Fields.body]?.stringValue) {
            
            body = tempBody
        }
        if let tempTitle: String = (dict[Fields.title]?.stringValue) {
            
            title = tempTitle
        }
    }
    
    // MARK: HatApiType protocol
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            Fields.body: self.body,
            Fields.title: self.title
        ]
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let json: JSON = JSON(fromCache)
        self.initialize(dict: json.dictionaryValue)
    }
}
