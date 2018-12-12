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

import Alamofire
import SwiftyJSON

public struct HATToolsService {

    public static func getAvailableTools(userDomain: String, userToken: String, completion: @escaping (([HATToolsObject], String?) -> Void), failCallBack: @escaping ((HATTableError) -> Void)) {
        
        let url: String = "https://\(userDomain)/api/v2.6/she/function"
        let headers: [String: String] = ["x-auth-token": userToken]
        
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .get,
            encoding: Alamofire.JSONEncoding.default,
            contentType: ContentType.json,
            parameters: [:],
            headers: headers,
            completion: {response in
                
                switch response {
                    
                // in case of error call the failCallBack
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        failCallBack(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        failCallBack(.generalError(message, statusCode, error))
                    }
                // in case of success call succesfulCallBack
                case .isSuccess(let isSuccess, let statusCode, let result, let token):
                    
                    if isSuccess && statusCode != 401 {
                        
                        var arrayToReturn: [HATToolsObject] = []
                        
                        if let array: [JSON] = result.array {
                            
                            for item: JSON in array {
                                
                                if let object: HATToolsObject = HATToolsObject.decode(from: item.dictionaryValue) {
                                    
                                    arrayToReturn.append(object)
                                }
                            }
                            
                            completion(arrayToReturn, token)
                        }
                    } else {
                        
                        let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
        })
    }
    
    public static func getTool(toolName: String, userDomain: String, userToken: String, completion: @escaping ((HATToolsObject, String?) -> Void), failCallBack: @escaping ((HATTableError) -> Void)) {
        
        let url: String = "https://\(userDomain)/api/v2.6/she/function/\(toolName)"
        let headers: [String: String] = ["x-auth-token": userToken]
        
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .get,
            encoding: Alamofire.JSONEncoding.default,
            contentType: ContentType.json,
            parameters: [:],
            headers: headers,
            completion: {response in
                
                switch response {
                    
                // in case of error call the failCallBack
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        failCallBack(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        failCallBack(.generalError(message, statusCode, error))
                    }
                // in case of success call succesfulCallBack
                case .isSuccess(let isSuccess, let statusCode, let result, let token):
                    
                    if isSuccess && statusCode != 401 {
                        
                        let dict: [String: JSON] = result.dictionaryValue
                            
                        if let object: HATToolsObject = HATToolsObject.decode(from: dict) {
                            
                            completion(object, token)
                        } else {
                            
                            let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                            failCallBack(.generalError(message, statusCode, nil))
                        }
                    } else {
                        
                        let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
        })
    }
    
    public static func enableTool(toolName: String, userDomain: String, userToken: String, completion: @escaping ((HATToolsObject, String?) -> Void), failCallBack: @escaping ((HATTableError) -> Void)) {
        
        let url: String = "https://\(userDomain)/api/v2.6/she/function/\(toolName)/enable"
        let headers: [String: String] = ["x-auth-token": userToken]
        
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .get,
            encoding: Alamofire.JSONEncoding.default,
            contentType: ContentType.json,
            parameters: [:],
            headers: headers,
            completion: {response in
                
                switch response {
                    
                // in case of error call the failCallBack
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        failCallBack(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        failCallBack(.generalError(message, statusCode, error))
                    }
                // in case of success call succesfulCallBack
                case .isSuccess(let isSuccess, let statusCode, let result, let token):
                    
                    if isSuccess && statusCode != 401 {
                        
                        let dict: [String: JSON] = result.dictionaryValue
                        
                        if let object: HATToolsObject = HATToolsObject.decode(from: dict) {
                            
                            completion(object, token)
                        } else {
                            
                            let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                            failCallBack(.generalError(message, statusCode, nil))
                        }
                    } else {
                        
                        let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
        })
    }
    
    public static func disableTool(toolName: String, userDomain: String, userToken: String, completion: @escaping ((HATToolsObject, String?) -> Void), failCallBack: @escaping ((HATTableError) -> Void)) {
        
        let url: String = "https://\(userDomain)/api/v2.6/she/function/\(toolName)/disable"
        let headers: [String: String] = ["x-auth-token": userToken]
        
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .get,
            encoding: Alamofire.JSONEncoding.default,
            contentType: ContentType.json,
            parameters: [:],
            headers: headers,
            completion: {response in
                
                switch response {
                    
                // in case of error call the failCallBack
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        failCallBack(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        failCallBack(.generalError(message, statusCode, error))
                    }
                // in case of success call succesfulCallBack
                case .isSuccess(let isSuccess, let statusCode, let result, let token):
                    
                    if isSuccess && statusCode != 401 {
                        
                        let dict: [String: JSON] = result.dictionaryValue
                        
                        if let object: HATToolsObject = HATToolsObject.decode(from: dict) {
                            
                            completion(object, token)
                        } else {
                            
                            let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                            failCallBack(.generalError(message, statusCode, nil))
                        }
                    } else {
                        
                        let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
        })
    }
    
    public static func triggerToolUpdate(toolName: String, userDomain: String, userToken: String, completion: @escaping ((String, String?) -> Void), failCallBack: @escaping ((HATTableError) -> Void)) {
        
        let url: String = "https://\(userDomain)/api/v2.6/she/function/\(toolName)/trigger"
        let headers: [String: String] = ["x-auth-token": userToken]
        
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .get,
            encoding: Alamofire.JSONEncoding.default,
            contentType: ContentType.json,
            parameters: [:],
            headers: headers,
            completion: {response in
                
                switch response {
                    
                // in case of error call the failCallBack
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        failCallBack(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        failCallBack(.generalError(message, statusCode, error))
                    }
                // in case of success call succesfulCallBack
                case .isSuccess(let isSuccess, let statusCode, let result, let token):
                    
                    if isSuccess && statusCode != 400 {
                        
                        let dict: [String: JSON] = result.dictionaryValue
                        if let message: String = dict["message"]?.stringValue {
                            
                            completion(message, token)
                        } else {
                            
                            let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                            failCallBack(.generalError(message, statusCode, nil))
                        }
                    } else {
                        
                        let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
        })
    }
}
