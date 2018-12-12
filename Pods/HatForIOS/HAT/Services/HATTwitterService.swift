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

/// The twitter data plug service class
public struct HATTwitterService {
    
    // MARK: - Check twitter plug

    /**
     Checks if twitter plug is active
     
     - parameter appToken: The authorisation token to authenticate with the hat
     - parameter url: The plug's status url to connect to
     - parameter successful: An @escaping (Void) -> Void method executed on a successful response
     - parameter failed: An @escaping (Void) -> Void) method executed on a failed response
     */
    public static func isTwitterDataPlugActive(appToken: String, url: String, successful: @escaping (Bool) -> Void, failed: @escaping (DataPlugError) -> Void) {
        
        // construct the url, set parameters and headers for the request
        let parameters: Dictionary<String, String> = [:]
        let headers: [String: String] = [RequestHeaders.xAuthToken: appToken]
        
        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: headers, completion: {(response: HATNetworkHelper.ResultType) -> Void in
            
            // act upon response
            switch response {
                
            case .isSuccess(_, let statusCode, _, _):
                
                if statusCode == 200 {
                    
                    successful(true)
                } else {
                    
                    successful(false)
                }
                
            // inform user that there was an error
            case .error(let error, let statusCode, _):
                
                let message: String = NSLocalizedString("Server responded with error", comment: "")
                failed(.generalError(message, statusCode, error))
            }
        })
    }
    
    // MARK: - Get tweets
    
    /**
     Fetches the facebook profile image of the user with v2 API's
     
     - parameter authToken: The authorisation token of twitter to authenticate with the hat
     - parameter userDomain: The authorisation token of twitter to authenticate with the hat
     - parameter parameters: The parameters to use in the request
     - parameter success: An @escaping (_ array: [JSON], String?) -> Void) method executed on a successful response
     - parameter errorCallback: An @escaping (HATTableError) -> Void) method executed on a failed response
     */
    public static func fetchTweets(authToken: String, userDomain: String, parameters: Dictionary<String, String>, successCallback: @escaping (_ array: [HATTwitterSocialFeedObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        func sendObjectBack(jsonArray: [JSON], token: String?) {
            
            var array: [HATTwitterSocialFeedObject] = []
            
            for object: JSON in jsonArray {
                
                array.append(HATTwitterSocialFeedObject(fromV2: object.dictionaryValue))
            }
            
            successCallback(array, token)
        }
        
        HATAccountService.getHatTableValues(
            token: authToken,
            userDomain: userDomain,
            namespace: Twitter.sourceName,
            scope: Twitter.tableName,
            parameters: parameters,
            successCallback: sendObjectBack,
            errorCallback: errorCallback)
    }
    
    // MARK: - Get application token for twitter
    
    /**
     Gets application token for twitter
     
     - parameter plug: The plug object to extract the info we need to get the AppToken
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter successful: An @escaping (String, String?) -> Void method executed on a successful response
     - parameter failed: An @escaping (JSONParsingError) -> Void) method executed on a failed response
     */
    public static func getAppTokenForTwitter(plug: HATDataPlugObject, userDomain: String, userToken: String, successful: @escaping (String, String?) -> Void, failed: @escaping (JSONParsingError) -> Void) {
        
        HATService.getApplicationTokenFor(
            serviceName: plug.plug.name,
            userDomain: userDomain,
            userToken: userToken,
            resource: plug.plug.url,
            succesfulCallBack: successful,
            failCallBack: failed)
    }
    
    // MARK: - Remove duplicates
    
    /**
     Removes duplicates from an array of HATTwitterSocialFeedObject and returns the corresponding objects in an array
     
     - parameter array: The HATTwitterSocialFeedObject array
     
     - returns: An array of HATTwitterSocialFeedObject
     */
    public static func removeDuplicatesFrom(array: [HATTwitterSocialFeedObject]) -> [HATTwitterSocialFeedObject] {
        
        // the array to return
        var arrayToReturn: [HATTwitterSocialFeedObject] = []
        
        // go through each tweet object in the array
        for tweet: HATTwitterSocialFeedObject in array where array.count > 1 {
            
            // check if the arrayToReturn it contains that value and if not add it
            let result: Bool = arrayToReturn.contains(where: {(tweeter: HATTwitterSocialFeedObject) -> Bool in
                
                if tweet.data.tweets.tweetID == tweeter.data.tweets.tweetID {
                    
                    return true
                }
                
                return false
            })
            
            if !result {
                
                arrayToReturn.append(tweet)
            }
        }
        
        return arrayToReturn
    }
}
