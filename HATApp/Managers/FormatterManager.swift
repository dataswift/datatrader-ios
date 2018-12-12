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

// MARK: Struct

/// A struct for everything that formats something
internal struct FormatterManager {
    
    // MARK: - Date to string formaters
    
    /**
     Formats a date to ISO 8601 format
     
     - parameter date: The date to format
     
     - returns: The date as a String in ISO format
     */
    static func formatDateToISO(date: Date) -> String {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZones.gmt)
        dateFormatter.dateFormat = DateFormats.gmt
        
        return dateFormatter.string(from: date as Date)
    }
    
    /**
     Formats ISO 8601 to Dateformat
     
     - parameter unixTimestamp: The ISO 8601 timestamp to format
     
     - returns: The date
     */
    static func formatISOToDateString(unixTimestamp: Int) -> String {
        
        let date: NSDate = NSDate(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date as Date)
    }
    
    /**
     Formats a date to the user's defined date as a string
     
     - parameter date: The date to localize
     - parameter dateStyle: The date style to return
     - parameter timeStyle: The time style to return
     
     - returns: A String representing the formatted date
     */
    static func formatDateStringToUsersDefinedDate(date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, timezone: String? = nil) -> String {
        
        var date = date
        if timezone != nil {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss Z"
            dateFormatter.timeZone = TimeZone(identifier: timezone!)
            let stringDate = dateFormatter.string(from: date)
            date = dateFormatter.date(from: stringDate)!
        }
        let dateString: String = DateFormatter.localizedString(
            from: date,
            dateStyle: dateStyle,
            timeStyle: timeStyle)
        
        return dateString.replacingOccurrences(of: ",", with: " -")
    }
    
    /**
     Returns a string from UTC formatted date in with full date and medium time styles
     
     - parameter datetime: The date to convert to string
     
     - returns: A String representing the date passed as a parameter
     */
    static func getDateString(_ datetime: Date) -> String {
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        formatter.timeStyle = DateFormatter.Style.medium
        formatter.timeZone = TimeZone(abbreviation: TimeZones.utc)
        
        return formatter.string(from: datetime)
    }
    
    /**
     Returns a string from a UTC formatted date with the specified date format
     
     - parameter datetime: The date to convert to string
     - parameter format: The format of the date
     
     - returns: A String representing the date passed as a parameter
     */
    static func getDateString(_ datetime: Date, format: String) -> String {
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: TimeZones.utc)
        
        return formatter.string(from: datetime)
    }
    
    // MARK: - String to Date formaters
    
    /**
     Formats a string into a Date
     
     - parameter string: The string to format to a Date
     
     - returns: The String passed in the function as an optional Date. The Date object is nil if the formatting fails
     */
    static func formatStringToDate(string: String) -> Date? {
        
        // check if the string to format is empty
        if string == "" {
            
            return nil
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: TimeZones.posix)
        dateFormatter.dateFormat = DateFormats.posix
        var date: Date? = dateFormatter.date(from: string)
        
        // if date is nil try a different format and reformat
        if date == nil {
            
            dateFormatter.dateFormat = DateFormats.utc
            date = dateFormatter.date(from: string)
        }
        
        // if date is nil try a different format, for twitter format and reformat
        if date == nil {
            
            dateFormatter.dateFormat = DateFormats.alternative
            date = dateFormatter.date(from: string)
        }
        
        if date == nil {
            
            dateFormatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: string,
                options: 0,
                locale: Locale.current)
            date = dateFormatter.date(from: string)
        }
        
        return date
    }
    
    /**
     Returns a Date string from a string representing a UTC date
     
     - parameter dateString: The string to convert into date
     
     - returns: The date that the string was representing
     */
    static func getDateFromString(_ dateString: String) -> Date! {
        
        let formatter:  DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormats.utc
        formatter.timeZone = TimeZone(abbreviation: TimeZones.utc)
        
        return formatter.date(from: dateString)
    }
    
    // MARK: - Format number to local number
    
    /**
     Formats number to user's local number lingo
     
     - parameter number: An NSNumber number to convert to string
     
     - returns: An optional String. The convertion can fail and return nil
     */
    static func formatNumber(number: NSNumber) -> String? {
        
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: number)
    }
    
    // MARK: - Format Speed
    
    /**
     Formatts the speed based on user's locale
     
     - parameter speed: The speed to format in m/s
     
     - returns: A string representing the speed and the unit based on currect locale
     */
    static func formatGPSSpeedToUsersSpeedUnit(speed: Double) -> String {
        
        let locale = Locale.current

        if locale.usesMetricSystem {
            
            let kmh = speed * 3.6
            let formattedKmh = FormatterManager.roundToDecimal(number: kmh, fractionDigits: 2)

            if formattedKmh <= 0 {
                
                return "unknown"
            }
            
            return "\(String(describing: formattedKmh)) km/h"
        } else {
            
            let kmh = speed * 3.6
            let mh = kmh / 1.609344
            let formattedMh = FormatterManager.roundToDecimal(number: mh, fractionDigits: 2)
            
            if formattedMh <= 0 {
                
                return "unknown"
            }
            return "\(String(describing: formattedMh)) m/h"
        }
    }
    
    // MARK: - Format Distance
    
    /**
     Formatts the altimeter based on user's locale
     
     - parameter alimeter: The altimeter in meters
     
     - returns: The formatted altimeter and the unit according to user's locale
     */
    static func formatGPSAltimeterToUsersDistanceUnit(altimeter: Double) -> String {
        
        let locale = Locale.current
        
        if locale.usesMetricSystem {
            
            let formattedMeters = FormatterManager.roundToDecimal(number: altimeter, fractionDigits: 2)

            return "\(String(describing: formattedMeters)) m"
        } else {
            
            let ft = altimeter * 3.28084
            let formattedFt = FormatterManager.roundToDecimal(number: ft, fractionDigits: 2)
            
            if formattedFt <= 0 {
                
                return "unknown"
            }
            return "\(String(describing: formattedFt)) ft"
        }
    }
    
    // MARK: - Round to desired decimal places
    
    /**
     Formats number to have the specified the fractiong digits
     
     - parameter number: The number to format
     - parameter fractionDigits: The amount of fraction digits allowed
     
     - returns: The formatted number
     */
    static func roundToDecimal(number: Double, fractionDigits: Int) -> Double {
        
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(number * multiplier) / multiplier
    }
    
}

