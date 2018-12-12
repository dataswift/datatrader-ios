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

// MARK: Extension

extension String {

    // MARK: - Check for Suffix
    
    /**
     Checks if the strings has the suffixes passed
     
     - parameter suffixes: The suffixes to check
     
     - returns: True if string has suffix false if not
     */
    internal func hasSuffixes(_ suffixes: [String]) -> Bool {
        
        for suffix: String in suffixes where self.hasSuffix(suffix) {
            
            return true
        }
        
        return false
    }
}
