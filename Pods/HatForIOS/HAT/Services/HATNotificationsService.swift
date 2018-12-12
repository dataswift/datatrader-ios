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

public struct HATNotificationsService {

    // MARK: - Get hat notifications
    
    /**
     Gets HAT notifications from HAT
     
     - parameter appToken: The token in String format
     - parameter successCallback: A callback called when successful of type @escaping ([NotificationObject]) -> Void
     - parameter errorCallback: A callback called when failed of type @escaping (Void) -> Void)
     */
    public static func getHATNotifications(appToken: String, successCallback: @escaping ([NotificationObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        // form the url
        let url: String = "https://dex.hubofallthings.com/api/notices"
        
        // create parameters and headers
        let headers: [String: String] = [RequestHeaders.xAuthToken: appToken]
        
        // make the request
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .get,
            encoding: Alamofire.URLEncoding.default,
            contentType: ContentType.json,
            parameters: [:],
            headers: headers,
            completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
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
                            
                            var arrayToReturn: [NotificationObject] = []
                            for notification: JSON in array {
                                
                                arrayToReturn.append(NotificationObject(dictionary: notification.dictionaryValue))
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
    
    // MARK: - Mark notification as read
    
    /**
     Marks a notification as Read
     
     - parameter appToken: The token in String format
     - parameter notificationID: The notification ID to mark as read
     - parameter successCallback: A callback called when successful of type @escaping ([NotificationObject]) -> Void
     - parameter errorCallback: A callback called when failed of type @escaping (Void) -> Void)
     */
    public static func markNotificationAsRead(appToken: String, notificationID: String, successCallback: @escaping (Bool, String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        // form the url
        let url: String = "https://dex.hubofallthings.com/api/notices/\(notificationID)/read"
        
        // create parameters and headers
        let headers: [String: String] = [RequestHeaders.xAuthToken: appToken]
        
        // make the request
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .put,
            encoding: Alamofire.URLEncoding.default,
            contentType: ContentType.json,
            parameters: [:],
            headers: headers,
            completion: { (response: HATNetworkHelper.ResultType) -> Void in
                
                switch response {
                    
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        errorCallback(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        errorCallback(.generalError(message, statusCode, error))
                    }
                case .isSuccess(let isSuccess, let statusCode, _, let token):
                    
                    if isSuccess {
                        
                        successCallback(true, token)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        errorCallback(.generalError(message, statusCode, nil))
                    }
                }
            }
        )
    }
}
