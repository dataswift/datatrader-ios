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

import SwiftyJSON

public struct HATSpotifyService {

    // MARK: - Get Spotify token
    
    /**
     Gets spotify token
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter dataPlugURL: The plug's url returned from HAT
     - parameter successCallback: A (String, String?) -> Void function executed on success
     - parameter errorCallback: A (JSONParsingError) -> Void function executed on failure
     */
    public static func getApplicationTokenForSpotify(userDomain: String, userToken: String, dataPlugURL: String, successCallback: @escaping (String, String?) -> Void, errorCallback: @escaping (JSONParsingError) -> Void) {
        
        HATService.getApplicationTokenFor(
            serviceName: Spotify.serviceName,
            userDomain: userDomain,
            userToken: userToken,
            resource: dataPlugURL,
            succesfulCallBack: successCallback,
            failCallBack: errorCallback)
    }
    
    // MARK: - Get Spotify Profile
    
    /**
     Returns the profile table from Spotify
     
     - parameter userToken: The user's token
     - parameter userDomain: The user's domain
     - parameter successCallback: A ([JSON], String?) -> Void function executed on success
     - parameter errorCallback: A (HATTableError) -> Void function executed on failure
     */
    public static func getSpotifyProfile(userToken: String, userDomain: String, successCallback: @escaping ([HATSpotifyProfileObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {
        
        HATAccountService.getHatTableValues(
            token: userToken,
            userDomain: userDomain,
            namespace: "spotify",
            scope: "profile",
            parameters: ["orderBy": "dateCreated",
                         "ordering": "descending",
                         "take": 1],
            successCallback: { jsonArray, newToken in
            
                guard !jsonArray.isEmpty else {
                    
                    successCallback([], nil)
                    return
                }
                
                let profileJSON: [String : JSON] = jsonArray[0]["data"].dictionaryValue
                if let profile: HATSpotifyProfileObject = HATSpotifyProfileObject.decode(from: profileJSON) {
                
                    successCallback([profile], newToken)
                } else {
                    
                    successCallback([], nil)
                }
            },
            errorCallback: errorCallback)
    }
}
