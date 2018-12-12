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

extension HATDataPlugsService {
    
    // MARK: - Filter plugs

    /**
     Filters the available plugs down to: Facebook, Twitter, Fitbit
     
     - parameter availablePlugs: The array of available plugs to filter
     
     - returns: The filtered array of the available plugs
     */
    static func filterPlugs(availablePlugs: [HATDataPlugObject]) -> [HATDataPlugObject] {
        
        guard !availablePlugs.isEmpty else {
            
            return []
        }
        
        var arrayToReturn: [HATDataPlugObject] = []
        
        for plug: HATDataPlugObject in availablePlugs where (plug.plug.name == DataPlugConstants.DataPlugNames.facebook || plug.plug.name == DataPlugConstants.DataPlugNames.twitter || plug.plug.name == DataPlugConstants.DataPlugNames.fitbit || plug.plug.name == DataPlugConstants.DataPlugNames.calendar || plug.plug.name == DataPlugConstants.DataPlugNames.spotify) {
            
            arrayToReturn.append(plug)
        }
        
        return arrayToReturn
    }
    
    // MARK: - Check status of the plugs
    
    /**
     Checks the status of the plug
     
     - parameter dataPlug: The data plug to check status
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter completion: A function, accepting (Bool, String?), to execute on completion
     */
    static func checkStatusOfPlug(dataPlug: HATDataPlugObject, userDomain: String, userToken: String, completion: @escaping (Bool, String?) -> Void) {
        
        func gotFacebookApplicationToken(appToken: String, newUserToken: String?) {
            
            let systemStatus: String = Facebook.facebookDataPlugStatusURL(facebookDataPlugURL: dataPlug.plug.url)
            
            HATFacebookService.isFacebookDataPlugActive(
                appToken: appToken,
                url: systemStatus,
                successful: { result in
                    
                    completion(result, appToken)
                },
                failed: { error in
                    
                    completion(false, appToken)
            })
        }
        
        func gotTwitterApplicationToken(appToken: String, newUserToken: String?) {
            
            let systemStatus: String = Twitter.twitterDataPlugStatusURL(twitterDataPlugURL: dataPlug.plug.url)

            HATTwitterService.isTwitterDataPlugActive(
                appToken: appToken,
                url: systemStatus,
                successful: { result in
                    
                    completion(result, appToken)
                },
                failed: { error in
                    
                    completion(false, appToken)
            })
        }
        
        func gotGoogleCalendarApplicationToken(appToken: String, newUserToken: String?) {
            
            let systemStatus: String = Twitter.twitterDataPlugStatusURL(twitterDataPlugURL: dataPlug.plug.url)
            
            HATTwitterService.isTwitterDataPlugActive(
                appToken: appToken,
                url: systemStatus,
                successful: { result in
                    
                    completion(result, appToken)
                },
                failed: { error in
                    
                    completion(false, appToken)
            })
        }
        
        if dataPlug.plug.name == DataPlugConstants.DataPlugNames.facebook {
            
            HATFacebookService.getAppTokenForFacebook(
                plug: dataPlug,
                token: userToken,
                userDomain: userDomain,
                successful: gotFacebookApplicationToken,
                failed: { error in
                    
                    completion(false, nil)
            })
        } else if dataPlug.plug.name == DataPlugConstants.DataPlugNames.twitter {
            
            HATTwitterService.getAppTokenForTwitter(
                plug: dataPlug,
                userDomain: userDomain,
                userToken: userToken,
                successful: gotTwitterApplicationToken,
                failed: { error in
                    
                    completion(false, nil)
            })
        } else if dataPlug.plug.name == DataPlugConstants.DataPlugNames.fitbit {
            
            let statusURL = Fitbit.fitbitDataPlugStatusURL(fitbitDataPlugURL: dataPlug.plug.url)
            HATFitbitService.checkIfFitbitIsEnabled(
                userDomain: userDomain,
                userToken: userToken,
                plugURL: dataPlug.plug.url,
                statusURL: statusURL,
                successCallback: completion,
                errorCallback: { error in
                    
                    completion(false, nil)
            })
        } else if dataPlug.plug.name == DataPlugConstants.DataPlugNames.calendar {
            
            HATGoogleCalendarService.getAppTokenForGoogleCalendar(
                plug: dataPlug,
                userDomain: userDomain,
                userToken: userToken,
                successful: gotGoogleCalendarApplicationToken,
                failed: { error in
                    
                    completion(false, nil)
            })
        } else if dataPlug.plug.name == DataPlugConstants.DataPlugNames.spotify {
            
            HATSpotifyService.getApplicationTokenForSpotify(
                userDomain: userDomain,
                userToken: userToken,
                dataPlugURL: dataPlug.plug.url,
                successCallback: gotGoogleCalendarApplicationToken,
                errorCallback: { error in
                
                completion(false, nil)
            })
        }
    }
}
