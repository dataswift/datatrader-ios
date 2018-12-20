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

/// The facebook data plug service class
public struct HATFacebookService {
    
    // MARK: - Check facebook plug
    
    /**
     Fetches the facebook profile image of the user with v2 API's
     
     - parameter authToken: The authorisation token to authenticate with the hat
     - parameter userDomain: The user's domain
     - parameter parameters: The parameters to use in the request as Dictionary<String: String>
     - parameter successCallback: An @escaping ([HATFacebookProfileImageObject], String?) -> Void) method executed on a successful response
     - parameter errorCallback: An @escaping (HATTableError) -> Void) method executed on a successful response
     */
    public static func fetchProfileFacebookPhoto(authToken: String, userDomain: String, parameters: Dictionary<String, String>, successCallback: @escaping (_ array: [HATFacebookProfileImageObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        func sendObjectBack(jsonArray: [JSON], token: String?) {
            
            var array: [HATFacebookProfileImageObject] = []
            
            for object: JSON in jsonArray {
                
                array.append(HATFacebookProfileImageObject(from: object.dictionaryValue))
            }
            
            successCallback(array, token)
        }
        
        HATAccountService.getHatTableValues(
            token: authToken,
            userDomain: userDomain,
            namespace: Facebook.sourceName,
            scope: "profile/picture",
            parameters: parameters,
            successCallback: sendObjectBack,
            errorCallback: errorCallback)
    }
    
    // MARK: - Facebook data plug
    
    /**
     Fetched the user's posts from facebook with v2 API's
     
     - parameter authToken: The authorisation token to authenticate with the hat
     - parameter userDomain: The user's domain
     - parameter parameters: The parameters to use in the request
     - parameter successCallback: An @escaping ([JSON]) -> Void) method executed on a successful response
     - parameter errorCallback: An @escaping (HATTableError) -> Void) method executed on a failed response
     */
    public static func getFacebookData(authToken: String, userDomain: String, parameters: Dictionary<String, String>, successCallback: @escaping (_ array: [HATFacebookSocialFeedObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        func sendObjectBack(jsonArray: [JSON], token: String?) {
            
            var array: [HATFacebookSocialFeedObject] = []
            
            for object: JSON in jsonArray {
                
                array.append(HATFacebookSocialFeedObject(from: object.dictionaryValue))
            }
            
            successCallback(array, token)
        }
        
        HATAccountService.getHatTableValues(
            token: authToken,
            userDomain: userDomain,
            namespace: Facebook.sourceName,
            scope: Facebook.tableName,
            parameters: parameters,
            successCallback: sendObjectBack,
            errorCallback: errorCallback)
    }
    
    /**
     Checks if facebook plug is active
     
     - parameter appToken: The authorisation token to authenticate with the hat
     - parameter url: The facebook plug url to connect
     - parameter successful: An @escaping (Void) -> Void method executed on a successful response
     - parameter failed: An @escaping (Void) -> Void) method executed on a failed response
     */
    public static func isFacebookDataPlugActive(appToken: String, url: String, successful: @escaping (Bool) -> Void, failed: @escaping (DataPlugError) -> Void) {
        
        let parameters: Dictionary<String, String> = [:]
        let headers: Dictionary<String, String>  = [RequestHeaders.xAuthToken: appToken]
        
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
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failed(.noInternetConnection)
                } else {
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    failed(.generalError(message, statusCode, error))
                }
            }
        })
    }
    
    // MARK: - Get app token
    
    /**
     Gets application token for facebook
     
     - parameter plug: The HATDataPlugObject object to extract the data from
     - parameter token: The user's token
     - parameter userDomain: The user's domain
     - parameter successful: An @escaping (String) -> Void method executed on a successful response
     - parameter failed: An @escaping (Void) -> Void) method executed on a failed response
     */
    public static func getAppTokenForFacebook(plug: HATDataPlugObject, token: String, userDomain: String, successful: @escaping (String, String?) -> Void, failed: @escaping (JSONParsingError) -> Void) {
        
        HATService.getApplicationTokenLegacyFor(
            serviceName: plug.plug.name,
            userDomain: userDomain,
            userToken: token,
            resource: plug.plug.url,
            succesfulCallBack: successful,
            failCallBack: failed)
    }
    
    // MARK: - Remove duplicates
    
    /**
     Removes duplicates from a json file and returns the corresponding objects
     
     - parameter array: The JSON array
     
     - returns: An array of HATFacebookSocialFeedObject
     */
    public static func removeDuplicatesFrom(array: [JSON]) -> [HATFacebookSocialFeedObject] {
        
        // the array to return
        var arrayToReturn: [HATFacebookSocialFeedObject] = []
        
        // go through each dictionary object in the array
        for dictionary: JSON in array {
            
            // transform it to an FacebookSocialFeedObject
            let object: HATFacebookSocialFeedObject = HATFacebookSocialFeedObject(from: dictionary.dictionaryValue)
            
            // check if the arrayToReturn it contains that value and if not add it
            let result: Bool = arrayToReturn.contains(where: {(post: HATFacebookSocialFeedObject) -> Bool in
                
                if object.data.posts.postID == post.data.posts.postID {
                    
                    return true
                }
                
                return false
            })
            
            if !result {
                
                arrayToReturn.append(object)
            }
        }
        
        return arrayToReturn
    }
    
    /**
     Removes duplicates from an array of FacebookSocialFeedObject and returns the corresponding objects in an array
     
     - parameter array: The FacebookSocialFeedObject array
     
     - returns: An array of HATFacebookSocialFeedObject
     */
    public static func removeDuplicatesFrom(array: [HATFacebookSocialFeedObject]) -> [HATFacebookSocialFeedObject] {
        
        // the array to return
        var arrayToReturn: [HATFacebookSocialFeedObject] = []
        
        // go through each post object in the array
        for facebookPost: HATFacebookSocialFeedObject in array {
            
            // check if the arrayToReturn it contains that value and if not add it
            let result: Bool = arrayToReturn.contains(where: {(post: HATFacebookSocialFeedObject) -> Bool in
                
                if facebookPost.data.posts.postID == post.data.posts.postID {
                    
                    return true
                }
                
                return false
            })
            
            if !result {
                
                arrayToReturn.append(facebookPost)
            }
        }
        
        return arrayToReturn
    }
}
