//
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

import HatForIOS
import SwiftyJSON

// MARK: Extension

extension HATGoogleCalendarService {

    // MARK: - Get google calendar combinator
    
    /**
     Gets the facebook combinator data from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's authentication token
     - parameter successCallback: A function of type ([HATLocationsV2Object], String?) to call on success
     - parameter failCallback: A fuction of type (HATError) to call on fail
     */
    public static func getGoogleCombinator(userDomain: String, userToken: String, successCallback: @escaping ([HATGoogleCalendarObject], String?) -> Void, failCallback: @escaping (HATError) -> Void) {
        
        HATAccountService.getCombinator(
            userDomain: userDomain,
            userToken: userToken,
            combinatorName: "googlelocationsfilter",
            successCallback: { array, newToken in
                
                var arrayToReturn: [HATGoogleCalendarObject] = []
                
                for item: JSON in array {
                    
                    if let object: HATGoogleCalendarObject = HATGoogleCalendarObject.decode(from: item.dictionaryValue) {
                        
                        arrayToReturn.append(object)
                    }
                }
                
                successCallback(arrayToReturn, newToken)
            },
            failCallback: failCallback
        )
    }
}
