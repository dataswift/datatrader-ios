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

// MARK: Struct

public struct HATGoogleCalendarService {
    
    // MARK: - Get application token for twitter
    
    /**
     Gets application token for twitter
     
     - parameter plug: The plug object to extract the info we need to get the AppToken
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter successful: An @escaping (String, String?) -> Void method executed on a successful response
     - parameter failed: An @escaping (JSONParsingError) -> Void) method executed on a failed response
     */
    public static func getAppTokenForGoogleCalendar(plug: HATDataPlugObject, userDomain: String, userToken: String, successful: @escaping (String, String?) -> Void, failed: @escaping (JSONParsingError) -> Void) {
        
        HATService.getApplicationTokenFor(
            serviceName: plug.plug.name,
            userDomain: userDomain,
            userToken: userToken,
            resource: plug.plug.url,
            succesfulCallBack: successful,
            failCallBack: failed)
    }
    
    // MARK: - Get calendar data
    
    /**
     Fetched the user's posts from facebook with v2 API's
     
     - parameter userToken: The authorisation token to authenticate with the hat
     - parameter userDomain: The user's domain
     - parameter parameters: The parameters to use in the request
     - parameter successCallback: An @escaping ([HATGoogleCalendarObject], String?) -> Void) method executed on a successful response
     - parameter errorCallback: An @escaping (HATTableError) -> Void) method executed on a failed response
     */
    public static func getCalendarEvents(userToken: String, userDomain: String, parameters: Dictionary<String, String>, successCallback: @escaping (_ array: [HATGoogleCalendarObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        func sendObjectBack(jsonArray: [JSON], token: String?) {
            
            var array: [HATGoogleCalendarObject] = []
            
            for object: JSON in jsonArray {
                
                if let objectToAdd: HATGoogleCalendarObject = HATGoogleCalendarObject.decode(from: object.dictionaryValue) {
                    
                    array.append(objectToAdd)
                }
            }
            
            successCallback(array, token)
        }
        
        HATAccountService.getHatTableValues(
            token: userToken,
            userDomain: userDomain,
            namespace: GoogleCalendar.sourceName,
            scope: GoogleCalendar.tableName,
            parameters: parameters,
            successCallback: sendObjectBack,
            errorCallback: errorCallback)
    }
    
    public static func getStaticData(plugURL: String, calendarToken: String, successCallback: @escaping ([String], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        let statusURL: String = GoogleCalendar.googleCalendarDataPlugStatusURL(googleDataPlugURL: plugURL)
        let headers: [String:String] = ["x-auth-token": calendarToken]
        
        HATNetworkHelper.asynchronousRequest(
            statusURL,
            method: .get,
            encoding: Alamofire.URLEncoding.default,
            contentType: "application/json",
            parameters: [:],
            headers: headers,
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
                            
                            var arrayToReturn: [String] = []
                            
                            for item: JSON in array {
                                
                                let calendarName: String = item["apiEndpoint"]["endpoint"]["name"].stringValue
                                arrayToReturn.append(calendarName)
                            }
                            
                            successCallback(arrayToReturn, token)
                        } else {
                            
                            errorCallback(.noValuesFound)
                        }
                    }
                }
        }
        )
    }
    
}
