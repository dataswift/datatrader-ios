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

public struct HATGoogleCalendarRemindersObject: HATObject {

    // MARK: - Variables
    
    /// If the event doesn't use the default reminders, this lists the reminders specific to the event, or, if not set, indicates that no reminders are set for this event. The maximum number of override reminders is 5.
    public var overrides: [HATGoogleCalendarRemindersOverridesObject]?
    /// Whether the default reminders of the calendar apply to the event.
    public var useDefault: Bool = false
    
    // MARK: - Initialisers
    
    public init() {
        
    }
}
