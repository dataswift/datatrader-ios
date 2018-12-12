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

// MARK: Extension

extension Range where Bound == String.Index {
    
    // MARK: - Variables
    
    /// Get range as NSRange
    var nsRange: NSRange {
        
        return NSRange(location: self.lowerBound.encodedOffset - 7,
                       length: self.upperBound.encodedOffset - self.lowerBound.encodedOffset + 9)
    }
}
