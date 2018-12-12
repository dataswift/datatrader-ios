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

import UIKit

// MARK: Extension

extension Date {
    
    // MARK: - Time ago
    
    /**
     Returns a string of time ago
     
     - returns: a formatted string of time-ago
     */
    public func timeAgoSinceDate() -> String {
        
        // get calendar and now date
        let calendar: Calendar = Calendar.current
        let dateNow: Date = self
        
        // calculate the earliest
        let earliestDate: Date = (dateNow as NSDate).earlierDate(self)
        // calculate the latest
        let latestDate: Date = (earliestDate == dateNow) ? self : dateNow
        
        // set up the componenets
        let components: DateComponents = (calendar as NSCalendar).components(
            [NSCalendar.Unit.minute, NSCalendar.Unit.hour, NSCalendar.Unit.day, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.second],
            from: earliestDate,
            to: latestDate,
            options: NSCalendar.Options())
        
        // check the components and return the correct string
        if components.year! >= 2 {
            
            return NSLocalizedString("Last year", comment: "")
        } else if components.month! >= 2 {
            
            return String.localizedStringWithFormat(NSLocalizedString("%d months ago", comment: ""), components.month!)
        } else if components.weekOfYear! >= 1 {
            
            return NSLocalizedString("A week ago", comment: "")
        } else if components.day! >= 2 {
            
            return String.localizedStringWithFormat(NSLocalizedString("%d days ago", comment: ""), components.day!)
        } else if components.day! >= 1 {
            
            return NSLocalizedString("A day ago", comment: "")
        } else if components.hour! >= 2 {
            
            return String.localizedStringWithFormat(NSLocalizedString("%d hours ago", comment: ""), components.hour!)
        } else if components.hour! >= 1 {
            
            return NSLocalizedString("An hour ago", comment: "")
        } else if components.minute! >= 2 {
            
            return String.localizedStringWithFormat(NSLocalizedString("%d minutes ago", comment: ""), components.minute!)
        } else if components.minute! >= 1 {
            
            return NSLocalizedString("A minute ago", comment: "")
        } else if components.second! >= 3 {
            
            return String.localizedStringWithFormat(NSLocalizedString("%d seconds ago", comment: ""), components.second!)
        }
        
        return NSLocalizedString("Just now", comment: "")
    }
    
    // MARK: - Time of day
    
    /**
     Returns the time of the day as String in the format of 18:39
     
     - returns: The time of the day as String in the format of 18:39
     */
    func getTimeOfDay() -> String {
        
        let calendar: Calendar = Calendar.current
        
        let hour: Int = calendar.component(.hour, from: self)
        let minutes: Int = calendar.component(.minute, from: self)
        return "\(hour):\(minutes)"
    }
    
    // MARK: - Start or end of day
    
    /**
     Returns the start of the day for the date passed as parameter, if no date passed then defaults to today
     
     - parameter date: The date to get the start of the day
     
     - returns: The start of the day date
     */
    static func startOfDate(date: Date = Date()) -> Date {
        
        return Calendar.current.startOfDay(for: date)
    }
    
    /**
     Returns the end of the day for the date passed as parameter, if no date passed then defaults to today
     
     - parameter date: The date to get the end of the day
     
     - returns: The end of the day date
     */
    static func endOfDate(date: Date = Date()) -> Date? {
        
        var components: DateComponents = DateComponents()
        components.day = 1
        components.second = -1
        let startOfDay: Date = Date.startOfDate(date: date)
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
    /**
     Returns the start of the day for the date passed as parameter, if no date passed then defaults to today
     
     - parameter date: The date to get the start of the day
     
     - returns: The start of the day date as unix time stamp
     */
    static func startOfDateInUnixTimeStamp(date: Date = Date()) -> Int {
        
        let date: Date = Date.startOfDate(date: date)
        return Int(date.timeIntervalSince1970)
    }
    
    /**
     Returns the end of the day for the date passed as parameter, if no date passed then defaults to today
     
     - parameter date: The date to get the end of the day
     
     - returns: The end of the day date as unix time stamp
     */
    static func endOfDateInUnixTimeStamp(date: Date = Date()) -> Int? {
        
        //For End Date
        if let endOfDate: Date = Date.endOfDate(date: date) {
            
            return Int(endOfDate.timeIntervalSince1970)
        }
        
        return nil
    }
}
