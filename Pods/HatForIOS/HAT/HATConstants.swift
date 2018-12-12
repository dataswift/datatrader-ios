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

/**
 The data needed for communicating with twitter data plug
 
 - tableName: The name of the table that HAT saves data
 - sourceName: The source name of the data
 - serviceName: The service, Plug, name
 */
public struct Twitter {
    
    /**
     Constructs the api/status endpoint for the plug according to the dataplug url returned from the HAT
     
     - parameter twitterDataPlugURL: The plug url returned from HAT
     
     - returns: The twitterDataPlugURL appended with /api/status
     */
    public static func twitterDataPlugStatusURL(twitterDataPlugURL: String) -> String {
        
        return "\(twitterDataPlugURL)/api/status"
    }
    
    public static let tableName: String = "tweets"
    public static let sourceName: String = "twitter"
    public static let serviceName: String = "Twitter"
}

/**
 The strings needed for communicating with fitbit data plug
 
 - sourceName: The source name of the data
 - serviceName: The service, Plug, name
 */
public struct Spotify {
    
    /**
     Constructs the api/status endpoint for the plug according to the dataplug url returned from the HAT
     
     - parameter spotifyDataPlugURL: The plug url returned from HAT
     
     - returns: The spotifyDataPlugURL appended with /api/status
     */
    public static func spotifyDataPlugStatusURL(spotifyDataPlugURL: String) -> String {
        
        return "\(spotifyDataPlugURL)/api/status"
    }
    
    public static let sourceName: String = "spotify"
    public static let serviceName: String = "spotify"
}

/**
 The strings needed for communicating with fitbit data plug
 
 - sourceName: The source name of the data
 - serviceName: The service, Plug, name
 */
public struct Fitbit {
    
    /**
     Constructs the api/status endpoint for the plug according to the dataplug url returned from the HAT
     
     - parameter fitbitDataPlugURL: The plug url returned from HAT
     
     - returns: The fitbitDataPlugURL appended with /api/status
     */
    public static func fitbitDataPlugStatusURL(fitbitDataPlugURL: String) -> String {
        
        return "\(fitbitDataPlugURL)/api/status"
    }
    
    public static let sourceName: String = "fitbit"
    public static let serviceName: String = "Fitbit"
}

/**
 The strings needed for communicating with facebook data plug
 
 - tableName: The name of the table that HAT saves data
 - sourceName: The source name of the data
 - serviceName: The service, Plug, name
 */
public struct Facebook {
    
    /**
     Constructs the api/status endpoint for the plug according to the dataplug url returned from the HAT
     
     - parameter facebookDataPlugURL: The plug url returned from HAT
     
     - returns: The facebookDataPlugURL appended with /api/status
     */
    public static func facebookDataPlugStatusURL(facebookDataPlugURL: String) -> String {
        
        return "\(facebookDataPlugURL)/api/status"
    }
    
    public static let tableName: String = "feed"
    public static let sourceName: String = "facebook"
    public static let serviceName: String = "Facebook"
}

/**
 The strings needed for communicating with facebook data plug
 
 - tableName: The name of the table that HAT saves data
 - sourceName: The source name of the data
 - serviceName: The service, Plug, name
 */
public struct GoogleCalendar {
    
    /**
     Constructs the api/status endpoint for the plug according to the dataplug url returned from the HAT
     
     - parameter facebookDataPlugURL: The plug url returned from HAT
     
     - returns: The facebookDataPlugURL appended with /api/status
     */
    public static func googleCalendarDataPlugStatusURL(googleDataPlugURL: String) -> String {
        
        return "\(googleDataPlugURL)/api/status"
    }
    
    public static let tableName: String = "google/events"
    public static let sourceName: String = "calendar"
    public static let serviceName: String = "calendar"
}

/**
 The strings needed for communicating with notables service
 
 - tableName: The source name of the data
 - sourceName: The service, Plug, name
 */
public enum Notables {
    
    public static let tableName: String = "notablesv1"
    public static let sourceName: String = "rumpel"
}

/**
 The strings needed for generating databuyer token
 
 - name: The name of the service
 - source: The source of the service
 */
public struct DataBuyer {
    
    public static let name: String = "DataBuyer"
    public static var source: String = "https://databuyer.hubat.net/"
}

/**
 The strings needed for generating Dex token
 
 - name: The name of the service
 - source: The source of the service
 */
public struct Dex {
    
    public static let name: String = "Dex"
    public static var source: String = "https://dex.hubofallthings.com/"
}

/**
 The request headers
 
 - xAuthToken: The xAuthToken name in the headers
 - tokenParamName: The token name in the headers
 */
public enum RequestHeaders {
    
    public static let xAuthToken: String = "x-auth-token"
    public static let tokenParamName: String = "token"
}

/**
 The content type
 
 - json: "application/json"
 - text: "text/plain"
 */
public enum ContentType {
    
    public static let json: String = "application/json"
    public static let text: String = "text/plain"
}

/**
 The authentication data used by location service
 
 - dataPlugID: The location plug id
 - locationDataPlugToken: The location plug token, used when enabling the service
 */
public enum HATDataPlugCredentials {
    
    /// market data plug id used for location data plug
    static let dataPlugID: String = "c532e122-db4a-44b8-9eaf-18989f214262"
    /// market access token used for location data plug
    static let locationDataPlugToken: String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxLVZTUDcrb0RleldPejBTOFd6MHhWM0J2eVNOYzViNnRcLzRKXC85TVlIWTQrVDdsSHdUSDRXMVVEWGFSVnVQeTFPZmtNajNSNDBjeTVERFRhQjZBNE44c3FGSTJmMUE1NzZUYjhiYmhhUT0iLCJpc3MiOiJoYXQtbWFya2V0IiwiZXhwIjoxNTI2OTc4OTkyLCJpYXQiOjE0OTYyMjA1OTIsImp0aSI6ImY0NTQ4NzI5MGRlZTA3NDI5YmQxMGViMWZmNzJkZjZmODdiYzhhZDE0ZThjOGE3NmMyZGJlMjVhNDlmODNkOTNiMDJhMzg3NGI4NTI0NDhlODU0Y2ZmZmE0ZWQyZGY1MTYyZTBiYzRhNDk2NGRhYTlhOTc1M2EyMjA1ZjIzMzc5NWY3N2JiODhlYzQwNjQxZjM4MTk4NTgwYWY0YmExZmJkMDg5ZTlhNmU3NjJjN2NhODlkMDdhOTg3MmY1OTczNjdjYWQyYzA0NTdjZDhlODlmM2FlMWQ2MmRmODY3NTcwNTc3NTdiZDJjYzgzNTgyOTU4ZmZlMDVhNjI2NzBmNGMifQ.TvFs6Zp0E24ChFqn3rBP-cpqxZbvkhph91UILGJvM6U"
}
