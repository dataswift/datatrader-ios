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
import SwiftyJSON

// MARK: Struct

public struct HATFeedService {
    
    // MARK: - Get feed
    
    /**
     Gets the she feed from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters to pass in the request, default is empty
     - parameter successCallback: A function of type ([HATFeedObject], String?) that executes on success
     - parameter failed: A function of type (HATTableError) that executes on failure
     */
    static public func getFeed(userDomain: String, userToken: String, parameters: Dictionary<String, Any> = [:], hatSuffix: String = "", successCallback: @escaping ([HATFeedObject], String?) -> Void, failed: @escaping (HATTableError) -> Void) {
        
        func success(values: [JSON], newToken: String?) {
            
            var arrayToReturn: [HATFeedObject] = []
            for value: JSON in values {
                
                let dict: [String: JSON] = value.dictionaryValue
                if let object: HATFeedObject = HATFeedObject.decode(from: dict) {
                    
                    arrayToReturn.append(object)
                }
            }
            
            successCallback(arrayToReturn, newToken)
        }
        
        // form the url
        let url: String = "https://\(userDomain)/api/v2.6/she/feed\(hatSuffix)"
        
        // create parameters and headers
        let headers: [String: String] = [RequestHeaders.xAuthToken: userToken]
        
        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            case .error(let error, let statusCode, _):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failed(.noInternetConnection)
                } else {
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    failed(.generalError(message, statusCode, error))
                }
            case .isSuccess(let isSuccess, let statusCode, let result, let token):
                
                if statusCode != nil && statusCode! == 401 {
                    
                    let message: String = NSLocalizedString("Token expired", comment: "")
                    failed(.generalError(message, statusCode, nil))
                }
                if isSuccess {
                    
                    if let array: [JSON] = result.array {
                        
                        success(values: array, newToken: token)
                    } else {
                        
                        failed(.noValuesFound)
                    }
                }
            }
        })
    }
    
    // MARK: - Get she combinator
    
    /**
     Gets the she combinator data from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's authentication token
     - parameter successCallback: A function of type ([HATFeedObject], String?) to call on success
     - parameter failCallback: A fuction of type (HATError) to call on fail
     */
    static public func getFeedCombinator(userDomain: String, userToken: String, successCallback: @escaping ([HATFeedObject], String?) -> Void, failCallback: @escaping (HATError) -> Void) {
        
        HATAccountService.getCombinator(
            userDomain: userDomain,
            userToken: userToken,
            combinatorName: "shefilter",
            successCallback: { array, newToken in
                
                var arrayToReturn: [HATFeedObject] = []
                for item: JSON in array {
                    
                    if let object: HATFeedObject = HATFeedObject.decode(from: item["data"].dictionaryValue) {
                        
                        arrayToReturn.append(object)
                    }
                }
                
                successCallback(arrayToReturn, newToken)
        },
            failCallback: failCallback
        )
    }
}
