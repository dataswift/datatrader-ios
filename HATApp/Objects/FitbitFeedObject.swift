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

// MARK: - Struct

internal struct FitbitFeedObject: Comparable, HATSocialFeedObject {
    
    var protocolLastUpdate: Date?
    
    static func < (lhs: FitbitFeedObject, rhs: FitbitFeedObject) -> Bool {
        
        return lhs.date < lhs.date
    }
    
    static func == (lhs: FitbitFeedObject, rhs: FitbitFeedObject) -> Bool {
        
        return lhs.name == rhs.name && lhs.value == rhs.value && lhs.date == rhs.date && lhs.category == rhs.category
    }
    
    var name: String = ""
    var value: String = ""
    var category: String = ""
    var addedCategoryID: String = ""
    var date: Date = Date()
}
