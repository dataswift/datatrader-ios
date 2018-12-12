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

/// The data plugs service class
public struct HATDataPlugsService {
    
    // MARK: - Get available data plugs
    
    /**
     Gets the available data plugs for the user to enable
     
     - parameter succesfulCallBack: A function of type ([HATDataPlugObject], String?) -> Void, executed on a successful result
     - parameter failCallBack: A function of type (DataPlugError) -> Void, executed on an unsuccessful result
     */
    public static func getAvailableDataPlugs(succesfulCallBack: @escaping ([HATDataPlugObject], String?) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {
        
        let url: String = "https://dex.hubofallthings.com/api/dataplugs"
        
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: [:], headers: [:], completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
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
                    
                    var returnValue: [HATDataPlugObject] = []
                    
                    for item: JSON in result.arrayValue {
                        
                        if let object: HATDataPlugObject = HATDataPlugObject.decode(from: item.dictionaryValue) {
                            
                            returnValue.append(object)
                        }
                    }
                    
                    succesfulCallBack(returnValue, token)
                } else {
                    
                    let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
    
    // MARK: - Claiming offers
    
    /**
     Check if offer is claimed
     
     - parameter offerID: The offerID as a String
     - parameter appToken: The application token as a String
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func checkIfOfferIsClaimed(offerID: String, appToken: String, succesfulCallBack: @escaping (String) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {
        
        // setup parameters and headers
        let parameters: Dictionary<String, String> = [:]
        let headers: [String: String] = ["X-Auth-Token": appToken]
        
        // contruct the url
        let url: String = "https://dex.hubofallthings.com/api/v2.6/offer/\(offerID)/userClaim"
        
        // make async request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode, _):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failCallBack(.noInternetConnection)
                } else if statusCode != 404 {
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                } else {
                    
                    let message: String = NSLocalizedString("Expected response, 404", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                }
            // in case of success call succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, _):
                
                if isSuccess {
                    
                    if statusCode == 200 {
                        
                        if !result["confirmed"].boolValue {
                            
                            succesfulCallBack(result["dataDebitId"].stringValue)
                        } else {
                            
                            failCallBack(.noValueFound)
                        }
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with different code than 200", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                } else {
                    
                    let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
    
    /**
     Claim offer with this ID
     
     - parameter offerID: The offerID as a String
     - parameter appToken: The application token as a String
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func claimOfferWithOfferID(_ offerID: String, appToken: String, succesfulCallBack: @escaping (String) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {
        
        // setup parameters and headers
        let parameters: Dictionary<String, String> = [:]
        let headers: [String: String] = ["X-Auth-Token": appToken]
        
        // contruct the url
        let url: String = "https://dex.hubofallthings.com/api/v2.6/offer/\(offerID)/claim"
        
        // make async request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
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
            case .isSuccess(let isSuccess, let statusCode, let result, _):
                
                if isSuccess {
                    
                    if statusCode == 200 {
                        
                        succesfulCallBack(result["dataDebitId"].stringValue)
                    } else if statusCode == 400 {
                        
                        failCallBack(.offerClaimed)
                    } else {
                        let message: String = NSLocalizedString("Server responded with different code than 200", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                } else {
                    
                    let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
    
    // MARK: - Data debits
    
    /**
     Approve data debit
     
     - parameter dataDebitID: The data debit ID as a String
     - parameter userToken: The user's token
     - parameter userDomain: The user's domain
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func approveDataDebit(_ dataDebitID: String, userToken: String, userDomain: String, succesfulCallBack: @escaping (String) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {
        
        // setup parameters and headers
        let parameters: Dictionary<String, String> = [:]
        let headers: [String: String] = ["X-Auth-Token": userToken]
        
        // contruct the url
        let url: String = "https://\(userDomain)/api/v2.6/data-debit/\(dataDebitID)/enable"
        
        // make async request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
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
            case .isSuccess(let isSuccess, let statusCode, _, _):
                
                if isSuccess {
                    
                    if statusCode == 400 {
                        
                        failCallBack(.offerClaimed)
                    }
                    succesfulCallBack("enabled")
                } else {
                    
                    let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
    
    /**
     Check if data debit with this ID is enabled or not
     
     - parameter dataDebitID: The data debit ID as a String
     - parameter userToken: The user's token
     - parameter userDomain: The user's domain
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func checkDataDebit(_ dataDebitID: String, userToken: String, userDomain: String, succesfulCallBack: @escaping (Bool) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {
        
        // setup parameters and headers
        let parameters: Dictionary<String, String> = [:]
        let headers: [String: String] = ["X-Auth-Token": userToken]
        
        // contruct the url
        let url: String = "https://\(userDomain)/api/v2.6/data-debit/\(dataDebitID)"
        
        // make async request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error( let error, let statusCode, _):
                
                if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                    
                    failCallBack(.noInternetConnection)
                } else if statusCode != 404 {
                    
                    let message: String = NSLocalizedString("Server responded with error", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                } else {
                    
                    let message: String = NSLocalizedString("Expected response, 404", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                }
            // in case of success call succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, _):
                
                guard isSuccess, let dataDebit: DataDebitObject = DataDebitObject.decode(from: result.dictionaryValue) else {
                    
                    let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                    
                    return
                }
                
                succesfulCallBack(dataDebit.active)
            }
        })
    }
    
    //
    
    /**
     Check social plug expiry date
     
     - parameter facebookUrlStatus: The plug's status url to connect to
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public static func checkSocialPlugExpiry(facebookUrlStatus: String, succesfulCallBack: @escaping (String) -> Void, failCallBack: @escaping (DataPlugError) -> Void) -> (_ appToken: String) -> Void {
        
        return { (appToken: String) in
            
            // setup parameters and headers
            let parameters: Dictionary<String, String> = [:]
            let headers: [String: String] = ["X-Auth-Token": appToken]
            
            // make async request
            HATNetworkHelper.asynchronousRequest(facebookUrlStatus, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.json, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
                
                switch response {
                    
                // in case of error call the failCallBack
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        failCallBack(.noInternetConnection)
                    } else if statusCode == 404 {
                        
                        let message: String = NSLocalizedString("Expected response, 404", comment: "")
                        failCallBack(.generalError(message, statusCode, error))
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        failCallBack(.generalError(message, statusCode, error))
                    }
                // in case of success call succesfulCallBack
                case .isSuccess(let isSuccess, let statusCode, let result, _):
                    
                    if isSuccess {
                        
                        succesfulCallBack(String(result["expires"].stringValue))
                    } else {
                        
                        let message: String = NSLocalizedString("Server response was unexpected", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
            })
        }
    }
    
}
