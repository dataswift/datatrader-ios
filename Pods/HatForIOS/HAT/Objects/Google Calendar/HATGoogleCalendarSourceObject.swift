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

public struct HATGoogleCalendarSourceObject: HATObject {
    
    // MARK: - Variables
    
    /// Title of the source; for example a title of a web page or an email subject.
    public var title: String?
    /// URL of the source pointing to a resource. The URL scheme must be HTTP or HTTPS.
    public var url: String?
    
    /// MARK: - Initialisers

    public init() {
        
    }
}
