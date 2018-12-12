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

public struct HATGoogleCalendarOrganizerObject: HATObject {
    
    // MARK: - Variables

    /// The organizer's Profile ID, if available. It corresponds to the *id* field in the [People collection of the Google+ API](https://developers.google.com/+/web/api/rest/latest/people)
    public var `id`: String?
    /// The organizer's email address, if available.
    public var email: String?
    /// The organizer's name, if available.
    public var displayName: String?
    /// Whether the organizer corresponds to the calendar on which this copy of the event appears. Read-only. The default is False.
    public var `self`: Bool?
    
    // MARK: - Initialisers
    
    public init() {
        
    }
}
