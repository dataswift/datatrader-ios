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

public struct HATProfileDataProfileOnlineObject: HATObject, HatApiType {

    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    struct Fields {
        
        static let blog: String = "blog"
        static let google: String = "google"
        static let twitter: String = "twitter"
        static let website: String = "website"
        static let youtube: String = "youtube"
        static let facebook: String = "facebook"
        static let linkedin: String = "linkedin"
    }
    
    // MARK: - Variables
    
    /// The user's blog address
    public var blog: String = ""
    /// The user's google address
    public var google: String = ""
    /// The user's twitter address
    public var twitter: String = ""
    /// The user's website address
    public var website: String = ""
    /// The user's youtube address
    public var youtube: String = ""
    /// The user's facebook address
    public var facebook: String = ""
    /// The user's linkedin address
    public var linkedin: String = ""
    
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
        
        if let tempBlog = (dict[Fields.blog]?.stringValue) {
            
            blog = tempBlog
        }
        if let tempGoogle = (dict[Fields.google]?.stringValue) {
            
            google = tempGoogle
        }
        if let tempTwitter = (dict[Fields.twitter]?.stringValue) {
            
            twitter = tempTwitter
        }
        if let tempWebsite = (dict[Fields.website]?.stringValue) {
            
            website = tempWebsite
        }
        if let tempYoutube = (dict[Fields.youtube]?.stringValue) {
            
            youtube = tempYoutube
        }
        if let tempFacebook = (dict[Fields.facebook]?.stringValue) {
            
            facebook = tempFacebook
        }
        if let tempLinkedin = (dict[Fields.linkedin]?.stringValue) {
            
            linkedin = tempLinkedin
        }
    }
    
    // MARK: - HatApiType protocol
    
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            Fields.blog: self.blog,
            Fields.google: self.google,
            Fields.twitter: self.twitter,
            Fields.website: self.website,
            Fields.youtube: self.youtube,
            Fields.facebook: self.facebook,
            Fields.linkedin: self.linkedin
        ]
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let json = JSON(fromCache)
        self.initialize(dict: json.dictionaryValue)
    }
}
