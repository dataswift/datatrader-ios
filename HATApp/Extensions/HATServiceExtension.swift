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

import Alamofire
import HatForIOS

// MARK: Extension

extension HATService {

    // MARK: - System Status
    
    /**
     Gets the HAT system status along with database storage info etc. It formats the storage in a format like 1 % of 1GB storage used
     
     - parameter userToken: The user's token
     - parameter userDomain: The user's domain
     - parameter systemStatusString: A function to execute on completion, returning the text with format, 1 % of 1GB storage used
     - parameter usedPercentage: A function to execute on completion returing, the user's used database percentage
     - parameter newUserToken: A completion handler to pass the new user's token, can be nil
     */
    static func updateSystemStats(userToken: String, userDomain: String, systemStatusString: @escaping (String) -> Void, usedPercentage: @escaping (Float) -> Void, newUserToken: ((String?) -> Void)?, errorCallback: @escaping (JSONParsingError) -> Void) {
        
        func gettingSystemStatusFailed(error: JSONParsingError) {
            
            errorCallback(error)
            usedPercentage(0)
            systemStatusString("Couldn't connect to HAT")
        }
        
        func gotSystemStatus(systemStatusArray: [HATSystemStatusObject], newUserToken: String?) {
            
            var usedShare: String = ""
            var totalSize: String = ""
            var usedFloat: Float = 0
            
            for status: HATSystemStatusObject in systemStatusArray where status.title == "Database Storage" || status.title == "Database Storage Used Share" {
                
                guard let units: String = status.kind.units else {
                    
                    return
                }
                
                if status.title == "Database Storage" {
                    
                    totalSize = "\(status.kind.metric) \(units)"
                }
                
                if status.title == "Database Storage Used Share" {
                    
                    let intUsedShare: Float = Float(status.kind.metric)!
                    usedFloat = intUsedShare / 100
                    usedShare = "\(status.kind.metric) \(units)"
                }
            }
            
            usedPercentage(usedFloat)
            systemStatusString("\(usedShare) of \(totalSize) storage used")
        }
        
        HATService.getSystemStatus(
            userDomain: userDomain,
            userToken: userToken,
            completion: gotSystemStatus,
            failCallBack: gettingSystemStatusFailed)
    }
    
    // MARK: - Trigger HAT
    
    /**
     Triggers hat to perform an update on the she feed
     
     - parameter userDomain: User's domain. Indicates the hat to be updated
     - parameter headers: The headers to include to the request including the user's x-auth-token
     */
    static func triggerHAT(userDomain: String, headers: [String: String]) {
        
        HATNetworkHelper.asynchronousRequest("https://\(userDomain)/api/v2.6/she/function/data-feed-direct-mapper/trigger", method: .get, encoding: Alamofire.URLEncoding.default, contentType: "application/json", parameters: [:], headers: headers, completion: { _ in return})
    }
}
