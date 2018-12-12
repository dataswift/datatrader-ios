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

public struct DataOfferClaimObject {
    
    // MARK: - Fields
    
    /// The JSON fields used by the hat
    public struct Fields {
        
        static let claimStatus: String = "status"
        static let claimConfirmed: String = "confirmed"
        static let claimDateStamp: String = "dateCreated"
        static let dataDebitID: String = "dataDebitId"
    }
    
    // MARK: - Variables
    
    /// The data offer claim status
    public var claimStatus: String = ""
    /// The data offer claim confirmed state
    public var claimConfirmed: Bool = false
    /// The data offer claim unix time stamp
    public var claimDateStamp: Int = -1
    public var dataDebitID: String = ""
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        claimStatus = ""
        claimConfirmed = false
        claimDateStamp = -1
        dataDebitID = ""
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dictionary: The JSON file received
     */
    public init(dictionary: Dictionary<String, JSON>) {
        
        if let tempStatus: String = dictionary[DataOfferClaimObject.Fields.claimStatus]?.string {
            
            claimStatus = tempStatus
        }
        
        if let tempConfirmed: Bool = dictionary[DataOfferClaimObject.Fields.claimConfirmed]?.bool {
            
            claimConfirmed = tempConfirmed
        }
        
        if let tempDataDebitID: String = dictionary[DataOfferClaimObject.Fields.dataDebitID]?.string {
            
            dataDebitID = tempDataDebitID
        }
        
        if let tempDateStamp: Int = dictionary[DataOfferClaimObject.Fields.claimDateStamp]?.int {
            
            claimDateStamp = tempDateStamp
        }
    }
}
