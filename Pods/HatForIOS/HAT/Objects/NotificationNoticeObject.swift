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

public struct NotificationNoticeObject {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    private struct Fields {
        
        static let noticeID: String = "id"
        static let dateCreated: String = "dateCreated"
        static let message: String = "message"
    }
    
    // MARK: - Variables
    
    /// The notification ID
    public var noticeID: Int = -1
    /// The message of the notification
    public var message: String = ""
    /// The date the notification was created
    public var dateCreated: Date = Date()
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        noticeID = -1
        message = ""
        dateCreated = Date()
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dictionary: The JSON file received from the HAT
     */
    public init(dictionary: Dictionary<String, JSON>) {
        
        if let tempNoticeID = dictionary[Fields.noticeID]?.int {
            
            noticeID = tempNoticeID
        }
        
        if let tempMessage = dictionary[Fields.message]?.string {
            
            message = tempMessage
        }
        
        if let tempDateCreated = dictionary[Fields.dateCreated]?.intValue {
            
            dateCreated = Date(timeIntervalSince1970: TimeInterval(tempDateCreated / 1000))
        }
    }
}
