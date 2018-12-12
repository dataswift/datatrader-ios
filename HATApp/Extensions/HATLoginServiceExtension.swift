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

import HatForIOS
import JWTDecode
import Kingfisher

// MARK: Extension

extension HATLoginService {
    
    // MARK: - Log Out

    /**
     Clears Keychain from values in order to return app in the logged out state
     
     - parameter userDomain: The user's domain
     - parameter completion: A function to execute if the token has expired
     */
    static func logOut(userDomain: String, completion: @escaping () -> Void) {
        
        KingfisherManager.shared.cache.clearDiskCache(completion: {
            
            KeychainManager.clearKeychainKey(key: KeychainConstants.logedIn)
            KeychainManager.clearKeychainKey(key: KeychainConstants.userToken)
            
            CacheManager<HATFeedObject>.removeAllObjects(fromCache: "cache")
            CacheManager<HATSystemStatusObject>.removeAllObjects(fromCache: "system")
            CacheManager<HATProfileObject>.removeAllObjects(fromCache: "images")
            CacheManager<HATProfileObject>.removeAllObjects(fromCache: "profile")
            
            KingfisherManager.shared.cache.clearMemoryCache()
            KingfisherManager.shared.cache = ImageCache(name: userDomain)
            KingfisherManager.shared.cache.clearDiskCache(completion: {
                
                completion()
            })
        })
    }
    
    // MARK: - Check if token is active
    
    /**
     Checks if token has expired
     
     - parameter token: The token to check if expired
     - parameter expiredCallBack: A function to execute if the token has expired
     - parameter tokenValidCallBack: A function to execute if the token is valid
     - parameter errorCallBack: A function to execute when something has gone wrong
     */
    static func checkIfTokenExpired(token: String, expiredCallBack: () -> Void, tokenValidCallBack: (String?) -> Void, errorCallBack: ((String, String, String, @escaping () -> Void) -> Void)?) {
        
        do {
            
            let jwt: JWT = try decode(jwt: token)

            if jwt.expired {
                
                LoggerManager.logCustomError(error: AuthenticationError.tokenExpired, info: ["tokenExpired": jwt.expired])
                KeychainManager.setKeychainValue(key: KeychainConstants.Values.expired, value: KeychainConstants.logedIn)
                KeychainManager.clearKeychainKey(key: KeychainConstants.userToken)
                expiredCallBack()
            } else {
                
                if let issueDate: Date = jwt.issuedAt {
                    
                    let calendar: Calendar = NSCalendar.current
                    let components: DateComponents = calendar.dateComponents([.day], from: issueDate, to: Date())
                    if components.day! > 2 {
                        
                        LoggerManager.logCustomError(error: AuthenticationError.tokenIATExpired, info: ["tokenIssuedAt": issueDate, "Date": Date()])
                    }
                }
                
                tokenValidCallBack(token)
            }
        } catch {
            
            LoggerManager.logCustomError(error: AuthenticationError.tokenExpired, info: ["failedToCheckToken": token])
            errorCallBack?("Checking token expiry date failed, please log out and log in again", "Error", "OK", {})
        }
    }
}
