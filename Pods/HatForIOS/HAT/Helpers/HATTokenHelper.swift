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

import JWTDecode

// MARK: Struct

public struct HATTokenHelper {
    
    // MARK: - Check token scope
    
    /**
     Checks if the token has owner scope and returns it, else returns nil
     
     - parameter token: The token to check for the scope
     
     - returns: Returns the token if the scope of it is owner else nil
     */
    public static func checkTokenScope(token: String?, applicationName: String) -> String? {
        
        if let unwrappedToken: String = token {
            
            do {
                
                let jwt: JWT = try decode(jwt: unwrappedToken)
                let scope: Claim = jwt.claim(name: "accessScope")
                let applications: Claim = jwt.claim(name: "application")
                
                if applications.string == applicationName || scope.string == "owner" {
                    
                    return unwrappedToken
                }
            } catch {
            }
        }
        
        return nil
    }
    
}
