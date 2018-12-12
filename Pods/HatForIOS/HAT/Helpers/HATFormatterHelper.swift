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

import Foundation

// MARK: Class

/// A struct for everything that formats something
public class HATFormatterHelper: NSObject {
    
    // MARK: - Static dateFormatter
    
    /// A static dateFormatter in order to use it accross the file, performance improvements
    static let dateFormatter: DateFormatter = DateFormatter()
    
    // MARK: - String to Date formaters
    
    /**
     Formats a date to ISO 8601 format
     
     - parameter date: The date to format
     
     - returns: The date as string represented in ISO format
     */
    public class func formatDateToISO(date: Date) -> String {
        
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return dateFormatter.string(from: date)
    }
    
    /**
     Formats a string into a Date
     
     - parameter string: The string to format to a Date
     
     - returns: An optional Date format, nil if all formats failed to produce a date
     */
    public class func formatStringToDate(string: String) -> Date? {
        
        // check if the string to format is empty
        guard string != "" else {
            
            return nil
        }
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        var date: Date? = dateFormatter.date(from: string)
        
        if date == nil {
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            date = dateFormatter.date(from: string)
        }
        
        if date == nil {
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: string)
        }
        
        // if date is nil try a different format and reformat
        if date == nil {
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = dateFormatter.date(from: string)
        }
        
        if date == nil {
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            date = dateFormatter.date(from: string)
        }
        
        // if date is nil try a different format, for twitter format and reformat
        if date == nil {
            
            dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
            date = dateFormatter.date(from: string)
        }
        
        // if date is nil try a different format, unix time stamp
        if date == nil {
            
            // timestamp is in milliseconds
            if let timeStamp: Double = Double(string) {
                
                date = Date(timeIntervalSince1970: TimeInterval(timeStamp / 1000))
            }
        }
        
        return date
    }
    
    // MARK: - UnixTimeStamp
    
    /**
     Formats a date to unix time stamp
     
     - parameter date: The date to format
     
     - returns: An optional string representing the unix time stamp, nil if the formatting failed
     */
    public static func formatDateToEpoch(date: Date) -> String? {
        
        // get the unix time stamp
        let elapse: TimeInterval = date.timeIntervalSince1970
        
        let temp: String = String(elapse)
        
        let array: [String] = temp.components(separatedBy: ".")
        
        if !array.isEmpty {
            
            return array[0]
        }
        
        return nil
    }
    
    // MARK: - Convert from base64URL to base64
    
    /**
     String extension to convert from base64Url to base64
     
     parameter stringToConvert: The string to be converted
     
     returns: The stringToConvert represented in Base64 format
     */
    public class func fromBase64URLToBase64(stringToConvert: String) -> String {
        
        var convertedString: String = stringToConvert
        if convertedString.count % 4 == 2 {
            
            convertedString += "=="
        } else if convertedString.count % 4 == 3 {
            
            convertedString += "="
        }
        
        convertedString = convertedString.replacingOccurrences(of: "-", with: "+")
        convertedString = convertedString.replacingOccurrences(of: "_", with: "/")
        
        return convertedString
    }
    
}
