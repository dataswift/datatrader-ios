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

public struct HATGoogleCalendarConferenceDataCreateRequestObject: HATObject {
    
    // MARK: - Variables

    /// The conference solution, such as Hangouts or Hangouts Meet.
    public var conferenceSolutionKey: HATGoogleCalendarConferenceDataConferenceSolutionKeyObject?
    /// The client-generated unique **ID** for this request.
    /// Clients should regenerate this ID for every new request. If an ID provided is the same as for the previous request, the request is ignored.
    public var requestId: String?
    /// The status of the conference create request.
    public var status: HATGoogleCalendarConferenceDataCreateRequestStatusObject?
    
    // MARK: - Initialisers
    
    public init() {
        
    }
}
