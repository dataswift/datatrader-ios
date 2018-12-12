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

extension HATFacebookService {

    // MARK: - Facebook Info
    
    /**
     Get facebook static data
     
     - parameter userDomain: User's domain
     - parameter userToken: User's token
     - parameter completion: A completion handler to pass the static data on
     - parameter errorCallback: A completion handler to pass on the error, if any
     */
    static func loadFacebookInfo(userDomain: String, userToken: String, completion: @escaping ([PlugDetails]) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        func tableNotFound(error: HATTableError) {
            
            errorCallback(error)
        }
        
        func gotProfile(profile: [JSON], renewedToken: String?) {
            
            guard !profile.isEmpty,
                  let profile: Dictionary<String, JSON> = profile[0].dictionaryValue["data"]?.dictionaryValue else {
                
                return
            }
            
            var arrayToAdd: [PlugDetails] = []

            for (key, value) in profile {
                
                var object: PlugDetails = PlugDetails()
                object.name = key.replacingOccurrences(of: "_", with: " ")
                object.value = value.stringValue
                
                guard key == "updated_time",
                      let date: Date = HATFormatterHelper.formatStringToDate(string: value.stringValue) else {
                    
                    arrayToAdd.append(object)
                    continue
                }
                
                object.value = FormatterManager.formatDateStringToUsersDefinedDate(
                    date: date,
                    dateStyle: .short,
                    timeStyle: .short)
                
                arrayToAdd.append(object)
            }
            
            completion(arrayToAdd)
        }
        
        HATAccountService.getHatTableValues(
            token: userToken,
            userDomain: userDomain,
            namespace: "facebook",
            scope: "profile",
            parameters: ["orderBy": "lastUpdated",
                         "ordering": "descending"],
            successCallback: gotProfile,
            errorCallback: { error in
            
                print(error)
        })
    }
    
    // MARK: - Get facebook combinator
    
    /**
     Gets the facebook combinator data from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's authentication token
     - parameter successCallback: A function of type ([HATLocationsV2Object], String?) to call on success
     - parameter failCallback: A fuction of type (HATError) to call on fail
     */
    public static func getFacebookCombinator(userDomain: String, userToken: String, successCallback: @escaping ([HATFacebookSocialFeedObject], String?) -> Void, failCallback: @escaping (HATError) -> Void) {
        
        HATAccountService.getCombinator(
            userDomain: userDomain,
            userToken: userToken,
            combinatorName: "facebooklocationsfilter",
            successCallback: { array, newToken in
                
                var arrayToReturn: [HATFacebookSocialFeedObject] = []
                
                for item: JSON in array {
                    
                    let object: HATFacebookSocialFeedObject = HATFacebookSocialFeedObject(from: item.dictionaryValue)
                    arrayToReturn.append(object)
                }
                
                successCallback(arrayToReturn, newToken)
            },
            failCallback: failCallback
        )
    }
}
