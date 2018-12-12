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
import KeychainSwift

// MARK: Struct

/// A struct for working with the keychain
internal struct KeychainManager {
    
    // MARK: - Keychain methods
    
    /**
     Set a value in the keychain in the form of a Dictionary<String, String>
     
     - parameter key: An optional String representing the key
     - parameter value: An optional String representing the value
     
     - returns: True if found in the keychain, false if not
     */
    @discardableResult
    static func setKeychainValue(key: String?, value: String?) -> Bool {
        
        var value = value
        if key == KeychainConstants.userToken {
            
            if !(HATTokenHelper.checkTokenScope(token: value, applicationName: Auth.serviceName) != nil) {
                
                value = nil
            }
        }
        
        if value != nil && key != nil && value != "" {
            
            return KeychainSwift().set(value!, forKey: key!, withAccess: .accessibleAfterFirstUnlockThisDeviceOnly)
        }
        
        return false
    }
    
    /**
     Gets a value from keychain for the specified key
     
     - parameter key: The key to search in the Keychain
     
     - returns: An optional String with the value from the keychain. Nil if not foun
     */
    static func getKeychainValue(key: String) -> String? {
        
        let keychain = KeychainSwift()
        let value = keychain.get(key)
        if value == nil {
            
            return keychain.get(key)
        }
        
        return value
    }
    
    /**
     Clears the value for the specified key from keychain
     
     - parameter key: The key to search in the Keychain
     
     - returns: True if deleted, false if not
     */
    @discardableResult
    static func clearKeychainKey(key: String) -> Bool {
        
        return KeychainSwift().delete(key)
    }
}
