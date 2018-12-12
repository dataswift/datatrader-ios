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

// MARK: Protocol

import SwiftyJSON

public protocol HATObject: Codable {
    
    /**
     Decodes a JSON file to a HATObject
     
     - parameter from: A JSON object to decode from
     
     - returns: An optional HATObject decoded from the JSON passed in as a parameter
     */
    static func decode<T: HATObject>(from: Dictionary<String, JSON>) -> T?
    
    /**
     Encodes a HATObject to a JSON file
     
     - parameter from: A HATObject object to encode
     
     - returns: An optional Dictionary<String, Any> encoded from the HATObject passed in as a parameter
     */
    static func encode<T: HATObject>(from: T) -> Dictionary<String, Any?>?
    
    /**
     Encodes a HATObject to a JSON file
     
     - parameter from: A [HATObject] array to encode
     
     - returns: An optional Data object encoded from the [HATObject] array passed in as a parameter
     */
    static func encode<T: HATObject>(from: [T]) -> Data?
    
    /**
     Extracts the dictionary out of a JSON Object
     
     - parameter from: A JSON object to extract the dictionary from
     
     - returns: A dictionary<String, JSON> from the JSON file passed in as parameter
     */
    func extractContent(from: JSON) -> Dictionary<String, JSON>
}

//swiftlint:disable extension_access_modifier
extension HATObject {
    
    public func extractContent(from: JSON) -> Dictionary<String, JSON> {
        
        return from.dictionaryValue
    }
    
    static public func decode<T: HATObject>(from: Dictionary<String, JSON>) -> T? {
        
        let decoder: JSONDecoder = JSONDecoder()
        
        do {
            
            let data: Data = try JSON(from).rawData()
            return try decoder.decode(T.self, from: data)
        } catch {
            
            print("error decoding")
            return nil
        }
    }
    
    static public func encode<T: HATObject>(from: T) -> Dictionary<String, Any?>? {
        
        let encoder: JSONEncoder = JSONEncoder()
        
        do {
            
            let jsonData: Data = try encoder.encode(from)
            
            let swiftyJSON: JSON = try JSON(data: jsonData)
            return swiftyJSON.dictionaryObject
        } catch {
            
            print("error encoding")
            return nil
        }
    }
    
    static public func encode<T: HATObject>(from: [T]) -> Data? {
        
        let encoder: JSONEncoder = JSONEncoder()
        
        do {
            
            return try encoder.encode(from)
        } catch {
            
            print("error encoding")
            return nil
        }
    }
}
//swiftlint:enable extension_access_modifier
