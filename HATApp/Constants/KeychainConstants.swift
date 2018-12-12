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

// MARK: Struct

/**
 Keychain struct
 
 - Values: A struct holding the possible keychain values
 - hatDomainKey: The key used: user_hat_domain
 - trackDeviceKey: The key used: trackDevice
 - userToken: The key used: UserToken
 - logedIn: The key used: logedIn
 */
internal struct KeychainConstants {
    
    // MARK: - Variables
    
    static let hatDomainKey: String = "user_hat_domain"
    static let trackDeviceKey: String = "trackDevice"
    static let userToken: String = "UserToken"
    static let logedIn: String = "logedIn"
    static let newUser: String = "newUser"
    static let toolsOnboarding: String = "toolsOnboarding"
    static let locationScreenShown: String = "locationScreenShown"
    
    // MARK: - Values Struct
    
    /**
     Keychain struct
     
     - setTrue: The key used: true
     - setFalse: The key used: false
     - expired: The key used: expired
     */
    struct Values {
        
        // MARK: - Variables
        
        static let setTrue: String = "true"
        static let setFalse: String = "false"
        static let expired: String = "expired"
    }
}
