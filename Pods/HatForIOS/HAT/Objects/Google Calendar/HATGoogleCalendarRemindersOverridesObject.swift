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

public struct HATGoogleCalendarRemindersOverridesObject: HATObject {

    // MARK: - Variables
    
    /// The method used by this reminder. Possible values are:
    /// - **"email"** - Reminders are sent via email.
    /// - **"sms"** - Reminders are sent via SMS. These are only available for G Suite customers. Requests to set SMS reminders for other account types are ignored.
    /// - **"popup"** - Reminders are sent via a UI popup.
    public var method: String = ""
    /// Number of minutes before the start of the event when the reminder should trigger. Valid values are between 0 and 40320 (4 weeks in minutes).
    public var minutes: Int = 0
    
    // MARK: - Initialisers
    
    public init() {
        
    }
}
