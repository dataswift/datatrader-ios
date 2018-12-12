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

// MARK: Struct

public struct HATGoogleCalendarExtendedPropertiesObject: HATObject {
    
    // MARK: - Variables
    
    /// Properties that are shared between copies of the event on other attendees' calendars.
    public var shared: [String: String]?
    /// Properties that are private to the copy of the event that appears on this calendar.
    public var `private`: [String: String]?
    
    // MARK: - Initializers
    
    public init() {
        
    }
}
