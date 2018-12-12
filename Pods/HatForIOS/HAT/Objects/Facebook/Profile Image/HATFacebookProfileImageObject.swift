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

public struct HATFacebookProfileImageObject: HatApiType {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    public struct Fields {
        
        static let recordID: String = "recordId"
        static let data: String = "data"
        static let isSilhouette: String = "is_silhouette"
        static let height: String = "height"
        static let width: String = "width"
        static let url: String = "url"
        static let endPoint: String = "endpoint"
        static let lastUpdated: String = "lastUpdated"
        static let imageData: String = "imageData"
    }
    
    // MARK: - Variables
    
    /// Is image Silhouette
    public var isSilhouette: Bool = false
    /// The url of the image
    public var url: String = ""
    /// The height of the image
    public var imageHeight: Int = 0
    /// The width of the image
    public var imageWidth: Int = 0
    /// The date the image was last updated as unix time stamp
    public var lastUpdated: Int = 0
    /// The record id in the HAT
    public var recordID: String?
    /// The endpoint of the image
    public var endPoint: String = "profile_picture"
    /// The downloaded image
    public var image: UIImage?
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        isSilhouette = false
        url = ""
        imageWidth = 0
        imageHeight = 0
        lastUpdated = 0
        recordID = ""
        endPoint = "profile_picture"
        image = UIImage()
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dictionary: The JSON file received
     */
    public init(from dictionary: Dictionary<String, JSON>) {
        
        self.init()
        
        if let tempRecordID: String = dictionary[Fields.recordID]?.stringValue {
            
            recordID = tempRecordID
        }
        
        if let tempEndPoint: String = dictionary[Fields.endPoint]?.stringValue {
            
            endPoint = tempEndPoint
        }
        
        if let data: [String : JSON] = dictionary[Fields.data]?.dictionaryValue {
            
            // In new v2 API last updated will be inside data
            if let tempLastUpdated: String = data[Fields.lastUpdated]?.stringValue {
                
                if let date: Date = HATFormatterHelper.formatStringToDate(string: tempLastUpdated) {
                    
                    lastUpdated = Int(HATFormatterHelper.formatDateToEpoch(date: date)!)!
                }
            }
            if let tempSilhouette: Bool = dictionary[Fields.isSilhouette]?.boolValue {
                
                isSilhouette = tempSilhouette
            }
            if let tempHeight: String = dictionary[Fields.height]?.string {
                
                imageHeight = Int(tempHeight)!
            }
            if let tempWidth: String = dictionary[Fields.width]?.stringValue {
                
                imageWidth = Int(tempWidth)!
            }
            if let tempLink: String = dictionary[Fields.url]?.stringValue {
                
                url = tempLink
            }
        }
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dict: The JSON file received
     */
    public mutating func inititialize(dict: Dictionary<String, JSON>) {
        
        if let tempRecordID: String = dict[Fields.recordID]?.stringValue {
            
            recordID = tempRecordID
        }
        
        if let tempEndPoint: String = dict[Fields.endPoint]?.stringValue {
            
            endPoint = tempEndPoint
        }
        
        if let data: [String : JSON] = dict[Fields.data]?.dictionaryValue {
            
            // In new v2 API last updated will be inside data
            if let tempLastUpdated: String = data[Fields.lastUpdated]?.stringValue {
                
                if let date: Date = HATFormatterHelper.formatStringToDate(string: tempLastUpdated) {
                    
                    lastUpdated = Int(HATFormatterHelper.formatDateToEpoch(date: date)!)!
                }
            }
            if let tempSilhouette: Bool = dict[Fields.isSilhouette]?.boolValue {
                
                isSilhouette = tempSilhouette
            }
            if let tempHeight: String = dict[Fields.height]?.string {
                
                imageHeight = Int(tempHeight)!
            }
            if let tempWidth: String = dict[Fields.width]?.stringValue {
                
                imageWidth = Int(tempWidth)!
            }
            if let tempLink: String = dict[Fields.url]?.stringValue {
                
                url = tempLink
            }
        }
    }
    
    /**
     It initialises everything from the received JSON file from the cache
     
     - fromCache: The Dictionary file received from the cache
     */
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let dictionary: JSON = JSON(fromCache)
        self.inititialize(dict: dictionary.dictionaryValue)
        if let tempImage: Data = fromCache[Fields.imageData] as? Data {
            
            self.image = UIImage(data: tempImage)
        }
    }
    
    // MARK: - JSON Mapper
    
    /**
     Returns the object as Dictionary, JSON
     
     - returns: Dictionary<String, String>
     */
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            
            Fields.recordID: self.recordID ?? "-1",
            Fields.isSilhouette: self.isSilhouette,
            Fields.url: self.url,
            Fields.height: self.imageHeight,
            Fields.width: self.imageWidth,
            Fields.endPoint: self.endPoint,
            Fields.lastUpdated: HATFormatterHelper.formatDateToISO(date: Date()),
            Fields.imageData: (self.image ?? UIImage()).jpegData(compressionQuality: 1.0) ?? UIImage()
        ]
    }
}
