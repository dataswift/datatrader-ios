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

/// The location data plug service class
public struct HATLocationService {
    
    // MARK: - Create location plug URL
    
    /**
     Register with HAT url
     
     - parameter userHATDomain: The user's hat domain
     - returns: HATRegistrationURLAlias, can return empty string
     */
    public static func locationDataPlugURL(_ userHATDomain: String, dataPlugID: String) -> String {
        
        if let escapedUserHATDomain: String = userHATDomain.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            
            return "https://dex.hubofallthings.com/api/dataplugs/\(dataPlugID)/connect?hat=\(escapedUserHATDomain)"
        }
        
        return ""
    }
    
    // MARK: - Enable locations
    
    /**
     Enables the location data plug
     
     - parameter userDomain: The user's domain
     - parameter HATDomainFromToken: The HAT domain from token
     - parameter successCallback: A (Bool) -> Void function executed on success
     - parameter errorCallback: A (JSONParsingError) -> Void function executed on failure
     */
    public static func enableLocationDataPlug(_ userDomain: String, _ HATDomainFromToken: String, success: @escaping (Bool) -> Void, failed: @escaping (JSONParsingError) -> Void) {
        
        // parameters..
        let parameters: Dictionary<String, String> = [:]
        
        // auth header
        let headers: [String : String] = ["Accept": ContentType.json,
                                          "Content-Type": ContentType.json,
                                          RequestHeaders.xAuthToken: HATDataPlugCredentials.locationDataPlugToken]
        // construct url
        let url: String = HATLocationService.locationDataPlugURL(userDomain, dataPlugID: HATDataPlugCredentials.dataPlugID)
        
        // make asynchronous call
        HATNetworkHelper.asynchronousRequest(url, method: HTTPMethod.get, encoding: Alamofire.URLEncoding.default, contentType: "application/json", parameters: parameters, headers: headers) { (response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
            case .isSuccess(let isSuccess, let statusCode, let result, _):
                
                if isSuccess {
                    
                    // belt and braces.. check we have a message in the returned JSON
                    if result["message"].exists() {
                        
                        // save the hatdomain from the token to the device Keychain
                        success(true)
                        // No message field in JSON file
                    } else {
                        
                        failed(.expectedFieldNotFound)
                    }
                    // general error
                } else {
                    
                    failed(.generalError(isSuccess.description, statusCode, nil))
                }
                
            case .error(let error, let statusCode, _):
                
                //show error
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failed(.noInternetConnection)
                } else {
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    failed(.generalError(message, statusCode, error))
                }
            }
        }
    }
    
    // MARK: - Get Locations
    
    /**
     Gets locations from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter fromDate: The date to request locations from
     - parameter toDate: The date to request locations to
     - parameter successCallback: A ([HATLocationsV2Object], String?) -> Void function executed on success
     - parameter errorCallback: A (JSONParsingError) -> Void function executed on failure
     */
    public static func getLocations(userDomain: String, userToken: String, fromDate: Date, toDate: Date, successCallback: @escaping ([HATLocationsObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void ) {
        
        func receivedLocations(json: [JSON], newUserToken: String?) {
            
            // if we have values return them
            if !json.isEmpty {
                
                var arrayToReturn: [HATLocationsObject] = []
                
                for item: JSON in json {
                    
                    if let object: HATLocationsObject = HATLocationsObject.decode(from: item.dictionaryValue) {
                        
                        arrayToReturn.append(object)
                    } else {
                        
                        print("error parsing json")
                    }
                }
                
                successCallback(arrayToReturn, newUserToken)
            } else {
                
                errorCallback(.noValuesFound)
            }
        }
        
        func locationsReceived(error: HATTableError) {
            
            errorCallback(error)
        }
        
        HATAccountService.getHatTableValues(
            token: userToken,
            userDomain: userDomain,
            namespace: "rumpel",
            scope: "locations/ios",
            parameters: [:],
            successCallback: receivedLocations,
            errorCallback: locationsReceived)
    }
    
    // MARK: - Upload locations
    
    /**
     Uploads locations to HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter locations: The locations to sync to the hat
     - parameter completion: A ([HATLocationsV2Object], String?) -> Void function executed on success
     */
    public static func syncLocationsToHAT(userDomain: String, userToken: String, locations: [HATLocationsDataObject], completion: ((Bool, String?) -> Void)? = nil) {
        
        var tempLocations: [HATLocationsDataObject] = locations
        if locations.count > 100 {
            
            tempLocations = Array(locations.prefix(100))
        }
        
        let encoded: Data? = HATLocationsDataObject.encode(from: tempLocations)
        
        var urlRequest: URLRequest = URLRequest.init(url: URL(string: "https://\(userDomain)/api/v2.6/data/rumpel/locations/ios?skipErrors=true")!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue(userToken, forHTTPHeaderField: "x-auth-token")
        urlRequest.networkServiceType = .background
        urlRequest.httpBody = encoded
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager: SessionManager = Alamofire.SessionManager(configuration: configuration)
        
        manager.request(urlRequest).responseJSON(completionHandler: { response in
            
            let header: [AnyHashable: Any]? = response.response?.allHeaderFields
            let token: String? = header?["x-auth-token"] as? String
            
            var tempLocations: [HATLocationsDataObject] = locations
            if locations.count > 100 {
                
                tempLocations = Array(locations.prefix(100))
            }
            
            if response.response?.statusCode == 400 && tempLocations.count > 10 {
                
                // if failed syncing, duplicate files found, try failback method
                HATLocationService.failbackDuplicateSyncing(dbLocations: tempLocations, userDomain: userDomain, userToken: userToken, completion: completion)
            } else if response.response?.statusCode == 201 {
                
                completion?(true, token)
            }
        }).session.finishTasksAndInvalidate()
    }
    
    /**
     Uploads locations to HAT failback
     
     - parameter dbLocations: The locations to sync to the hat
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter completion: A ([HATLocationsV2Object], String?) -> Void function executed on success
     */
    static func failbackDuplicateSyncing(dbLocations: [HATLocationsDataObject], userDomain: String, userToken: String, completion: ((Bool, String?) -> Void)?) {
        
        guard dbLocations.count > 2 else {
            
            completion?(true, userToken)
            return
        }
        
        let midPoint: Int = (dbLocations.count - 1) / 2
        let midPointNext: Int = midPoint + 1
        let splitArray1: [HATLocationsDataObject] = Array(dbLocations[...midPoint])
        let splitArray2: [HATLocationsDataObject] = Array(dbLocations[midPointNext...])
        
        var urlRequest: URLRequest = URLRequest.init(url: URL(string: "https://\(userDomain)/api/v2.6/data/rumpel/locations/ios?skipErrors=true")!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue(userToken, forHTTPHeaderField: "x-auth-token")
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        func reccuring(array: [HATLocationsDataObject], urlRequest: URLRequest, userDomain: String, userToken: String ) {
            
            var urlRequest: URLRequest = urlRequest
            let encoded: Data? = HATLocationsDataObject.encode(from: array)
            urlRequest.httpBody = encoded
            
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let manager: SessionManager = Alamofire.SessionManager(configuration: configuration)
            
            manager.request(urlRequest).responseJSON(completionHandler: { response in
                
                let header: [AnyHashable: Any]? = response.response?.allHeaderFields
                let token: String? = header?["x-auth-token"] as? String
                
                if response.response?.statusCode == 400 && array.count > 1 {
                    
                    HATLocationService.failbackDuplicateSyncing(dbLocations: array, userDomain: userDomain, userToken: userToken, completion: completion)
                } else {
                    
                    completion?(true, token)
                }
            }).session.finishTasksAndInvalidate()
        }
        
        if !splitArray1.isEmpty {
            
            reccuring(array: splitArray1, urlRequest: urlRequest, userDomain: userDomain, userToken: userToken)
        }
        
        if !splitArray2.isEmpty {
            
            reccuring(array: splitArray2, urlRequest: urlRequest, userDomain: userDomain, userToken: userToken)
        }
    }
    
    // MARK: - Get location combinator
    
    /**
     Gets the location combinator data from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's authentication token
     - parameter successCallback: A function of type ([HATLocationsV2Object], String?) to call on success
     - parameter failCallback: A fuction of type (HATError) to call on fail
     */
    public static func getLocationCombinator(userDomain: String, userToken: String, successCallback: @escaping ([HATLocationsObject], String?) -> Void, failCallback: @escaping (HATError) -> Void) {
        
        HATAccountService.getCombinator(
            userDomain: userDomain,
            userToken: userToken,
            combinatorName: "locationsfilter",
            successCallback: { array, newToken in
                
                var arrayToReturn: [HATLocationsObject] = []
                for item: JSON in array {
                    
                    if let object: HATLocationsObject = HATLocationsObject.decode(from: item.dictionaryValue) {
                        
                        arrayToReturn.append(object)
                    }
                }
                
                successCallback(arrayToReturn, newToken)
            },
            failCallback: failCallback
        )
    }
}
