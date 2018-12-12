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

public struct DataOfferOwnerObject {
    
    // MARK: - JSON Fields
    
    /// The JSON fields used by the hat
    public struct Fields {
        
        static let issuerID: String = "id"
        static let email: String = "email"
        static let nickName: String = "nick"
        static let firstName: String = "firstName"
        static let lastName: String = "lastName"
    }
    
    // MARK: - Variables

    /// The offer issuer ID
    public var issuerID: String = ""
    /// The email of the issuer
    public var email: String = ""
    /// The nickname of the issuer
    public var nick: String = ""
    /// The first name of the issuer
    public var firstName: String = ""
    /// The last name of the issuer
    public var lastName: String = ""
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        issuerID = ""
        email = ""
        nick = ""
        firstName = ""
        lastName = ""
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dictionary: The JSON file received
     */
    public init(dictionary: Dictionary<String, JSON>) {
        
        if let tempID = dictionary[DataOfferOwnerObject.Fields.issuerID]?.string {
            
            issuerID = tempID
        }
        
        if let tempEmail = dictionary[DataOfferOwnerObject.Fields.email]?.string {
            
            email = tempEmail
        }
        
        if let tempNick = dictionary[DataOfferOwnerObject.Fields.nickName]?.string {
            
            nick = tempNick
        }
        
        if let tempFirstName = dictionary[DataOfferOwnerObject.Fields.firstName]?.string {
            
            firstName = tempFirstName
        }
        
        if let tempLastName = dictionary[DataOfferOwnerObject.Fields.lastName]?.string {
            
            lastName = tempLastName
        }
    }
}
