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
import SwiftyJSON

// MARK: Extension

extension HATTwitterService {

    // MARK: - Get Twitter static info
    
    /**
     Gets the static info of twitter plug
     
     - parameter userToken: The user's token
     - parameter userDomain: The user'd domain
     - parameter success: A function returning an array of PlugDetails with the static info
     */
    static func getStaticInfo(userToken: String, userDomain: String, success: @escaping([PlugDetails]) -> Void) {
        
        func gotTweets(tweets: [HATTwitterSocialFeedObject], newToken: String?) {
            
            guard !tweets.isEmpty else {
                
                return
            }
            
            var arrayToAdd: [PlugDetails] = []
            
            for child in Mirror(reflecting: tweets[0].data.tweets.user).children {
                
                guard let value = child.value as? String else {
                    
                    return
                }
                
                var object: PlugDetails = PlugDetails()
                object.name = child.label!.replacingOccurrences(of: "_", with: " ")
                object.value = value
                
                arrayToAdd.append(object)
            }
            
            success(arrayToAdd)
        }
        
        HATTwitterService.fetchTweets(
            authToken: userToken,
            userDomain: userDomain,
            parameters: ["take": "1",
                         "orderBy": "id",
                         "ordering": "descending"],
            successCallback: gotTweets,
            errorCallback: { error in
            
                print(error)
            }
        )
    }
}
