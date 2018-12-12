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
 Date formats
 
 - utc: the utc representation format (yyyy-MM-dd'T'HH:mm:ssZ)
 - gmt: the gmt representation format (yyyy-MM-dd'T'HH:mm:ssZZZZZ)
 - posix: the posix representation format (yyyy-MM-dd'T'HH:mm:ss.SSSZ)
 - alternative: an alternative representation used when else fails (E MMM dd HH:mm:ss Z yyyy)
 */
struct DateFormats {
    
    // MARK: - Variables
    
    static let utc: String = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let gmt: String = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static let posix: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let alternative: String = "E MMM dd HH:mm:ss Z yyyy"
}

// MARK: - Struct

/**
 Time zone formats
 
 - utc: the UTC representation format
 - gmt: the GMT representation format
 - posix: the en_US_POSIX representation format
 */
struct TimeZones {
    
    // MARK: - Variables
    
    static let utc: String = "UTC"
    static let gmt: String = "GMT"
    static let posix: String = "en_US_POSIX"
}
