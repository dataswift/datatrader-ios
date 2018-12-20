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

/// A class about the methods concerning the HAT
public struct HATService {
    
    // MARK: - Application Token
    
    /**
     Gets the application level token from hat. This is Legacy now. You can use the `getApplicationTokenFor` funtion below
     
     - parameter serviceName: The service name requesting the token
     - parameter userDomain: The user's domain
     - parameter token: The user's token
     - parameter resource: The resource for the token
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func getApplicationTokenLegacyFor(serviceName: String, userDomain: String, userToken: String, resource: String, succesfulCallBack: @escaping (String, String?) -> Void, failCallBack: @escaping (JSONParsingError) -> Void) {
        
        // setup parameters and headers
        let parameters: [String: String] = ["name": serviceName, "resource": resource]
        let headers: [String: String] = [RequestHeaders.xAuthToken: userToken]
        
        // contruct the url
        let url: String = "https://\(userDomain)/users/application_token"
        
        // async request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode, _):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failCallBack(.noInternetConnection)
                } else {
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                }
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, let token):
                
                if isSuccess {
                    
                    succesfulCallBack(result["accessToken"].stringValue, token)
                } else {
                    
                    failCallBack(.generalError(isSuccess.description, statusCode, nil))
                }
            }
        })
    }
    
    /**
     Gets the application level token from hat
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter appName: The resource for the token
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func getApplicationTokenFor(userDomain: String, userToken: String, appName: String, succesfulCallBack: @escaping (String, String?) -> Void, failCallBack: @escaping (JSONParsingError) -> Void) {
        
        // setup parameters and headers
        let headers: [String: String] = [RequestHeaders.xAuthToken: userToken]
        
        // contruct the url
        let url: String = "http://\(userDomain)/api/v2.6/applications/\(appName)/access-token"
        
        // async request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: [:], headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode, _):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failCallBack(.noInternetConnection)
                } else {
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                }
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, let token):
                
                if isSuccess {
                    
                    succesfulCallBack(result["accessToken"].stringValue, token)
                } else {
                    
                    failCallBack(.generalError(isSuccess.description, statusCode, nil))
                }
            }
        })
    }
    
    // MARK: - Get available HAT providers
    
    /**
     Fetches the available HAT providers
     
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func getAvailableHATProviders(succesfulCallBack: @escaping ([HATProviderObject], String?) -> Void, failCallBack: @escaping (JSONParsingError) -> Void) {
        
        let url: String = "https://hatters.hubofallthings.com/api/products/hat"
        
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: [:], headers: [:], completion: {(response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode, _):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failCallBack(.noInternetConnection)
                } else {
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                }
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, let token):
                
                if isSuccess {
                    
                    let resultArray: [JSON] = result.arrayValue
                    var arrayToSendBack: [HATProviderObject] = []
                    for item: JSON in resultArray {
                        
                        arrayToSendBack.append(HATProviderObject(from: item.dictionaryValue))
                    }
                    
                    succesfulCallBack(arrayToSendBack, token)
                } else {
                    
                    let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
    
    // MARK: - Validate Data
    
    /**
     Validates email address with the HAT
     
     - parameter email: The email to validate with the HAT
     - parameter cluster: The cluster to validate the email with
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func validateEmailAddress(email: String, cluster: String, succesfulCallBack: @escaping (String, String?) -> Void, failCallBack: @escaping (JSONParsingError) -> Void) {
        
        let url: String = "https://hatters.hubofallthings.com/api/products/hat/validate-email"
        
        let parameters: [String: String] = ["email": email,
                                            "cluster": cluster]
        
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: [:], completion: {(response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode, let result):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failCallBack(.noInternetConnection)
                } else {
                    
                    if let message: String = result?["cause"].string {
                        
                        failCallBack(.generalError(message, statusCode, nil))
                    } else {
                        
                        let message: String = "Invalid email. HAT with such email already exists"
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, _, let newToken):
                
                if isSuccess && statusCode == 200 {
                    
                    succesfulCallBack("valid email", newToken)
                } else if statusCode == 400 {
                    
                    let message: String = "Invalid Email. HAT with such email already exists"
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
    
    /**
     Validates HAT address with HAT
     
     - parameter address: The address to validate with the HAT
     - parameter cluster: The cluster to validate the email with
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func validateHATAddress(address: String, cluster: String, succesfulCallBack: @escaping (String, String?) -> Void, failCallBack: @escaping (JSONParsingError) -> Void) {
        
        let url: String = "https://hatters.hubofallthings.com/api/products/hat/validate-hat"
        
        let parameters: [String: String] = ["address": address,
                                            "cluster": cluster]
        
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: [:], completion: {(response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode, let result):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failCallBack(.noInternetConnection)
                } else {
                    
                    if let message: String = result?["cause"].string {
                        
                        failCallBack(.generalError(message, statusCode, nil))
                    } else {
                        
                        let message: String = "Please choose your HAT microserver domain name. It can only contain letters, numbers or hyphens (cannot start or end with a hyphen). The entire domain name can only be up to 22 characters in length."
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, let newToken):
                
                if isSuccess && statusCode == 200 {
                    
                    succesfulCallBack("valid address", newToken)
                } else if statusCode == 400 {
                    
                    if let message: String = result["cause"].string {
                        
                        failCallBack(.generalError(message, statusCode, nil))
                    } else {
                        
                        let message: String = "Please choose your HAT microserver domain name. It can only contain letters, numbers or hyphens (cannot start or end with a hyphen). The entire domain name can only be up to 22 characters in length."
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
            }
        })
    }
    
    // MARK: - Purchase
    
    /**
     Confirms the hat purchase
     
     - parameter purchaseModel: The PurchaseObject to send to HAT
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func confirmHATPurchase(purchaseModel: PurchaseObject, succesfulCallBack: @escaping (String, String?) -> Void, failCallBack: @escaping (JSONParsingError) -> Void) {
        
        let url: String = "https://hatters.hubofallthings.com/api/products/hat/purchase"
        
        let body: [String : Any]? = PurchaseObject.encode(from: purchaseModel)
        let test: [String : Any] = JSON(body!).dictionaryObject!
        
        HATNetworkHelper.asynchronousRequest(url, method: .post, encoding: Alamofire.JSONEncoding.default, contentType: ContentType.json, parameters: test, headers: [:], completion: {(response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode, let result):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failCallBack(.noInternetConnection)
                } else {
                    
                    if let message: String = result?["cause"].string {
                        
                        failCallBack(.generalError(message, statusCode, nil))
                    } else {
                        
                        let message: String = "Invalid address. HAT with such address already exists"
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, let newToken):
                
                if isSuccess && statusCode == 200 {
                    
                    succesfulCallBack("purchase ok", newToken)
                } else {
                    
                    let message: String = result["message"].stringValue
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
    
    // MARK: - Get system status
    
    /**
     Fetches all the info related to user's HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func getSystemStatus(userDomain: String, userToken: String, completion: @escaping ([HATSystemStatusObject], String?) -> Void, failCallBack: @escaping (JSONParsingError) -> Void) {
        
        let url: String = "https://\(userDomain)/api/v2.6/system/status"
        let headers: [String: String] = ["X-Auth-Token": userToken]
        
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: [:], headers: headers, completion: {(response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode, _):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failCallBack(.noInternetConnection)
                } else {
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                }
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, let token):
                
                if isSuccess {
                    
                    let resultArray: [JSON] = result.arrayValue
                    var arrayToSendBack: [HATSystemStatusObject] = []
                    for item: JSON in resultArray {
                        
                        arrayToSendBack.append(HATSystemStatusObject(from: item.dictionaryValue))
                    }
                    
                    completion(arrayToSendBack, token)
                } else {
                    
                    let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
}
