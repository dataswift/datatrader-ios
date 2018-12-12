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

public struct HATGoogleCalendarConferenceDataConferenceSolutionKeyObject: HATObject {

    // MARK: - Variables
    
    /// The conference solution type.
    /// If a client encounters an unfamiliar or empty type, it should still be able to display the entry points. However, it should disallow modifications.
    ///
    /// The possible values are:
    ///
    /// - "eventHangout" for [Hangouts for consumers](http://hangouts.google.com)
    /// - "eventNamedHangout" for [Classic Hangouts for GSuite users](http://hangouts.google.com)
    /// - "hangoutsMeet" for [Hangouts Meet](http://meet.google.com)
    public var type: String = ""
    
    // MARK: - Initialisers
    
    public init() {
        
    }
}
