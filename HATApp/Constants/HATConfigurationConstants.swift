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

// MARK: Auth Struct

/// Struct used to store values needed for the authorisation
internal struct Auth {
    
    // MARK: - Variables
    
    /// app's url scheme
    static let urlScheme: String = "datatrader" // hatapp://hatapphost?token=blabla
    /// The hat service name
    static let serviceName: String = {
        
        if AppStatusManager.isAppBeta() {
            
            return "datatraderstaging"
        }
        
        return "datatrader"
    } ()
    /// The host used in the redirect url after the log in has finished succesfully
    static let localAuthHost: String = "datatraderhost"
    /// A notification send from the AppDelegate after successfully loged user in
    static let notificationHandlerName: String = "datatradernotificationhandler"
    /// A host used to identify if that url is comming from a plug. Used to dismiss safari
    static let dataplugsapphost: String = "datatraderdataplugsapphost"
    static let dataDebitHost: String = "datatraderdatadebithost"

    
    // MARK: - Constuct hat login URL
    
    /**
     Constructs a url in order to log in to the hat specified in the parameters
     
     - parameter userDomain: User's domain
     
     - returns: A string with the login url to connect to
     */
    static func hatLoginURL(userDomain: String) -> String {
        
        return "https://\(userDomain)/#/hatlogin?name=\(Auth.serviceName)&redirect=\(Auth.urlScheme)://\(Auth.localAuthHost)&fallback=\(Auth.urlScheme)://loginfailed"
    }
}

// MARK: - AppName Struct

/// A struct used to hold app specific variables
internal struct AppName {
    
    // MARK: - Variables
    
    /// The name of the app in the url schema
    static let name: String = "datatrader"
}

// MARK: - Domains Struct

/// A struct used to hold the HAT domains specific variables and functions
internal struct Domains {
    
    // MARK: - Get available log in domains
    
    /**
     Returns all the available clusters for the app to connect to
     
     - returns: The available clusters allowed to connect to
     */
    static func getAvailableDomains() -> [String] {
        
        if AppStatusManager.isAppBeta() {
            
            return [".hubofallthings.net", ".hubat.net", ".hat.direct", ".tamouk.hubat.net"]
        }
        
        return [".hubofallthings.net",  ".hat.direct", ".tamouk.hubat.net"]
    }
}

// MARK: - SideMenu Struct

/// A struct used to help with setting up the menu in the side menu
internal struct SideMenu {
    
    // MARK: - Get options for side menu
    
    /**
     Returns a dictionary combining the menu names with the view controller names in storyboard
     
     - returns: A dictionary with the menu name as a key and the view controller name as a value
     */
    static func getAvailableOptions() -> [Dictionary<String, String>] {
        
        return [["Recent offers": "recentOffersViewController"],
                ["My offers": "offersViewController"],
//                ["My public profile": "phata"],
//                ["My preferences": "myPreferences"],
                ["Settings": "settings"]]
    }
}

// MARK: - TermsURL Struct

/// A struct holding the terms URL
internal struct TermsURL {
    
    // MARK: - Variables
    
    static let termsAndConditions: String = "https://s3-eu-west-1.amazonaws.com/developers.hubofallthings.com/legals/HATDeX-Terms-and-Conditions.md"
    static let privacyPolicy: String = "https://s3-eu-west-1.amazonaws.com/developers.hubofallthings.com/legals/HATDeX-Privacy-Policy.md"
}

// MARK: - FileURL Struct

/// A struct used to construct the uploading url
internal struct FileURL {
    
    // MARK: - Construct file upload URL
    
    /**
     Returns the url to use after the uploading has been completed, the original url for the upload expires after a while. This doesn't
     
     - parameter fileID: The fileID of the file to upload
     - parameter userDomain: User's domain
     
     - returns: The url to use in the url field instead of the original url used to upload the file
     */
    static func convertURL(fileID: String, userDomain: String) -> String {
        
        return "https://\(userDomain)/api/v2.6/files/content/\(fileID)"
    }
}
