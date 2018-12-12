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

import HatForIOS

// MARK: Extension

extension HATSpotifyService {

    // MARK: - Get Spotify static info
    
    /**
     Gets the static info of spotify plug
     
     - parameter userToken: The user's token
     - parameter userDomain: The user'd domain
     - parameter success: A function returning an array of PlugDetails with the static info
     */
    static func getStaticInfo(userToken: String, userDomain: String, success: @escaping([PlugDetails]) -> Void) {
        
        func gotProfile(profile: [HATSpotifyProfileObject], newToken: String?) {
            
            guard !profile.isEmpty else {
                
                return
            }
            
            var arrayToAdd: [PlugDetails] = []
            
            for child in Mirror(reflecting: profile[0]).children {
                
                guard let value = child.value as? String else {
                    
                    continue
                }
                
                var object: PlugDetails = PlugDetails()
                object.name = child.label!.replacingOccurrences(of: "_", with: " ")
                object.value = value
                
                arrayToAdd.append(object)
            }
            
            success(arrayToAdd)
        }
        
        HATSpotifyService.getSpotifyProfile(
            userToken: userToken,
            userDomain: userDomain,
            successCallback: gotProfile,
            errorCallback: { error in
            
            print(error)
        })
    }
}
