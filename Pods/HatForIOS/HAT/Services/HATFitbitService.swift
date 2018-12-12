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

public struct HATFitbitService {
    
    // MARK: - Get Available fitbit data
    
    /**
     Gets all the endpoints from the hat and searches for the fitbit specific ones
     
     - parameter successCallback: A function returning an array of Strings, The endpoints found, and the new token
     - parameter errorCallback: A function returning the error occured
     */
    public static func getFitbitEndpoints(successCallback: @escaping ([String], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        let url: String = "https://dex.hubofallthings.com/stats/available-data"
        
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .get,
            encoding: Alamofire.URLEncoding.default,
            contentType: ContentType.json,
            parameters: [:],
            headers: [:],
            completion: { response in
                
                switch response {
                    
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        errorCallback(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        errorCallback(.generalError(message, statusCode, error))
                    }
                case .isSuccess(let isSuccess, _, let result, let token):
                    
                    if isSuccess {
                        
                        if let array: [JSON] = result.array {
                            
                            for item: JSON in array where item["namespace"] == "fitbit" {
                                
                                var arraytoReturn: [String] = []
                                
                                let tempArray: [JSON] = item["endpoints"].arrayValue
                                for tempItem: JSON in tempArray {
                                    
                                    arraytoReturn.append(tempItem["endpoint"].stringValue)
                                }
                                
                                successCallback(arraytoReturn, token)
                            }
                        } else {
                            
                            errorCallback(.noValuesFound)
                        }
                    }
                }
        }
        )
    }
    
    // MARK: - Get Data Generic
    
    /**
     The generic function used to get fitbit data
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter namespace: The namespace to read from
     - parameter scope: The scope to write from
     - parameter parameters: The parameters of the request, limit, take etc.
     - parameter successCallback: A ([Object], String?) -> Void function executed on success
     - parameter errorCallback: A (HATTableError) -> Void function executed on failure
     */
    private static func getGeneric<Object: HATObject>(userDomain: String, userToken: String, namespace: String, scope: String, parameters: Dictionary<String, String>, successCallback: @escaping ([Object], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        func gotResponse(json: [JSON], renewedToken: String?) {
            
            // if we have values return them
            if !json.isEmpty {
                
                var arrayToReturn: [Object] = []
                
                for item: JSON in json {
                    
                    if let object: Object = Object.decode(from: item["data"].dictionaryValue) {
                        
                        arrayToReturn.append(object)
                    } else {
                        
                        print("error parsing json")
                    }
                }
                
                successCallback(arrayToReturn, renewedToken)
            } else {
                
                errorCallback(.noValuesFound)
            }
        }
        
        HATAccountService.getHatTableValues(
            token: userToken,
            userDomain: userDomain,
            namespace: namespace,
            scope: scope,
            parameters: parameters,
            successCallback: gotResponse,
            errorCallback: errorCallback)
    }
    
    // MARK: - Get Data
    
    /**
     Gets fitbit sleep from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters of the request, limit, take etc.
     - parameter successCallback: A ([HATFitbitSleepObject], String?) -> Void function executed on success
     - parameter errorCallback: A (HATTableError) -> Void function executed on failure
     */
    public static func getSleep(userDomain: String, userToken: String, parameters: Dictionary<String, String>, successCallback: @escaping ([HATFitbitSleepObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        HATFitbitService.getGeneric(
            userDomain: userDomain,
            userToken: userToken,
            namespace: "fitbit",
            scope: "sleep",
            parameters: parameters,
            successCallback: successCallback,
            errorCallback: errorCallback)
    }
    
    /**
     Gets fitbit weight from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters of the request, limit, take etc.
     - parameter successCallback: A ([HATFitbitWeightObject], String?) -> Void function executed on success
     - parameter errorCallback: A (HATTableError) -> Void function executed on failure
     */
    public static func getWeight(userDomain: String, userToken: String, parameters: Dictionary<String, String>, successCallback: @escaping ([HATFitbitWeightObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        HATFitbitService.getGeneric(
            userDomain: userDomain,
            userToken: userToken,
            namespace: "fitbit",
            scope: "weight",
            parameters: parameters,
            successCallback: successCallback,
            errorCallback: errorCallback)
    }
    
    /**
     Gets fitbit profile from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters of the request, limit, take etc.
     - parameter successCallback: A ([HATFitbitProfileObject], String?) -> Void function executed on success
     - parameter errorCallback: A (HATTableError) -> Void function executed on failure
     */
    public static func getProfile(userDomain: String, userToken: String, parameters: Dictionary<String, String>, successCallback: @escaping ([HATFitbitProfileObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        HATFitbitService.getGeneric(
            userDomain: userDomain,
            userToken: userToken,
            namespace: "fitbit",
            scope: "profile",
            parameters: parameters,
            successCallback: successCallback,
            errorCallback: errorCallback)
    }
    
    /**
     Gets fitbit activity from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters of the request, limit, take etc.
     - parameter successCallback: A ([HATFitbitDailyActivityObject], String?) -> Void function executed on success
     - parameter errorCallback: A (HATTableError) -> Void function executed on failure
     */
    public static func getDailyActivity(userDomain: String, userToken: String, parameters: Dictionary<String, String>, successCallback: @escaping ([HATFitbitDailyActivityObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        HATFitbitService.getGeneric(
            userDomain: userDomain,
            userToken: userToken,
            namespace: "fitbit",
            scope: "activity/day/summary",
            parameters: parameters,
            successCallback: successCallback,
            errorCallback: errorCallback)
    }
    
    /**
     Gets fitbit lifetime stats from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters of the request, limit, take etc.
     - parameter successCallback: A ([HATFitbitStatsObject], String?) -> Void function executed on success
     - parameter errorCallback: A (HATTableError) -> Void function executed on failure
     */
    public static func getLifetimeStats(userDomain: String, userToken: String, parameters: Dictionary<String, String>, successCallback: @escaping ([HATFitbitStatsObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        HATFitbitService.getGeneric(
            userDomain: userDomain,
            userToken: userToken,
            namespace: "fitbit",
            scope: "lifetime/stats",
            parameters: parameters,
            successCallback: successCallback,
            errorCallback: errorCallback)
    }
    
    /**
     Gets fitbit activity from HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters of the request, limit, take etc.
     - parameter successCallback: A ([HATFitbitActivityObject], String?) -> Void function executed on success
     - parameter errorCallback: A (HATTableError) -> Void function executed on failure
     */
    public static func getActivity(userDomain: String, userToken: String, parameters: Dictionary<String, String>, successCallback: @escaping ([HATFitbitActivityObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        HATFitbitService.getGeneric(
            userDomain: userDomain,
            userToken: userToken,
            namespace: "fitbit",
            scope: "activity",
            parameters: parameters,
            successCallback: successCallback,
            errorCallback: errorCallback)
    }
    
    // MARK: - Check if Fitbit is enabled
    
    /**
     Checks if Fitbit plug is enabled
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter plugURL: The plug's url returned from HAT
     - parameter statusURL: The plug's status url
     - parameter successCallback: A (Bool, String?) -> Void function executed on success
     - parameter errorCallback: A (JSONParsingError) -> Void function executed on failure
     */
    public static func checkIfFitbitIsEnabled(userDomain: String, userToken: String, plugURL: String, statusURL: String, successCallback: @escaping (Bool, String?) -> Void, errorCallback: @escaping (JSONParsingError) -> Void) {
        
        func gotToken(fitbitToken: String, newUserToken: String?) {
            
            // construct the url, set parameters and headers for the request
            let parameters: Dictionary<String, String> = [:]
            let headers: [String: String] = [RequestHeaders.xAuthToken: fitbitToken]
            
            // make the request
            HATNetworkHelper.asynchronousRequest(statusURL, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: headers, completion: {(response: HATNetworkHelper.ResultType) -> Void in
                
                // act upon response
                switch response {
                    
                case .isSuccess(_, let statusCode, _, _):
                    
                    if statusCode == 200 {
                        
                        successCallback(true, fitbitToken)
                    } else {
                        
                        successCallback(false, fitbitToken)
                    }
                    
                // inform user that there was an error
                case .error(let error, let statusCode, _):
                    
                    if statusCode == 403 {
                        
                        successCallback(false, fitbitToken)
                    }
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    errorCallback(.generalError(message, statusCode, error))
                }
            })
        }
        
        HATFitbitService.getApplicationTokenForFitbit(
            userDomain: userDomain,
            userToken: userToken,
            dataPlugURL: plugURL,
            successCallback: gotToken,
            errorCallback: errorCallback)
    }
    
    // MARK: - Get Fitbit token
    
    /**
     Gets fitbit token
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter dataPlugURL: The plug's url returned from HAT
     - parameter successCallback: A (String, String?) -> Void function executed on success
     - parameter errorCallback: A (JSONParsingError) -> Void function executed on failure
     */
    public static func getApplicationTokenForFitbit(userDomain: String, userToken: String, dataPlugURL: String, successCallback: @escaping (String, String?) -> Void, errorCallback: @escaping (JSONParsingError) -> Void) {
        
        HATService.getApplicationTokenFor(
            serviceName: Fitbit.serviceName,
            userDomain: userDomain,
            userToken: userToken,
            resource: dataPlugURL,
            succesfulCallBack: successCallback,
            failCallBack: errorCallback)
    }
}
