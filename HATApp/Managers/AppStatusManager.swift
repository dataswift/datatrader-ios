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

import Foundation

// MARK: Struct

struct AppStatusManager {
    
    // MARK: - Check if app is beta

    /**
     Checks if the app is running in beta scheme
     
     - returns: True if the app is in beta scheme else false
     */
    static func isAppBeta() -> Bool {
        
        if let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? String {
            
            if config == "Beta" {
                
                return true
            }
        }
        
        return false
    }
}
