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

public struct HATGoogleCalendarConferenceDataEntryPointsObject: HATObject {
    
    // MARK: - Variables

    /// The Access Code to access the conference. The maximum length is 128 characters.
    /// When creating new conference data, populate only the subset of **{meetingCode, accessCode, passcode, password, pin}** fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    ///
    /// Optional.
    public var accessCode: String?
    /// The type of the conference entry point.
    /// Possible values are:
    ///
    /// - "video" - joining a conference over HTTP. A conference can have zero or one video entry point.
    /// - "phone" - joining a conference by dialing a phone number. A conference can have zero or more phone entry points.
    /// - "sip" - joining a conference over SIP. A conference can have zero or one sip entry point.
    /// - "more" - further conference joining instructions, for example additional phone numbers. A conference can have zero or one more entry point. A conference with only a more entry point is not a valid conference.
    public var entryPointType: String?
    /// The label for the URI.Visible to end users. Not localized. The maximum length is 512 characters.
    /// Examples:
    
    /// - for video: meet.google.com/aaa-bbbb-ccc
    /// - for phone: +1 123 268 2601
    /// - for sip: sip:12345678@myprovider.com
    /// - for more: should not be filled
    /// Optional.
    public var label: String?
    // The **Meeting Code** to access the conference. The maximum length is 128 characters.
    /// When creating new conference data, populate only the subset of **{meetingCode, accessCode, passcode, password, pin}** fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    
    /// Optional.
    public var meetingCode: String?
    /// The **Passcode** to access the conference. The maximum length is 128 characters.
    /// When creating new conference data, populate only the subset of **{meetingCode, accessCode, passcode, password, pin}** fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    public var passcode: String?
    /// The **Password** to access the conference. The maximum length is 128 characters.
    /// When creating new conference data, populate only the subset of **{meetingCode, accessCode, passcode, password, pin}** fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    ///
    /// Optional.
    public var password: String?
    /// The **PIN** to access the conference. The maximum length is 128 characters.
    // When creating new conference data, populate only the subset of **{meetingCode, accessCode, passcode, password, pin}** fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
    ///
    /// Optional.
    public var pin: String?
    /// The "URI" of the entry point. The maximum length is 1300 characters.
    /// Format:
    
    /// - for video, http: or https: schema is required.
    /// - for phone, tel: schema is required. The URI should include the entire dial sequence (e.g., tel:+12345678900,,,123456789;1234).
    /// - for sip, sip: schema is required, e.g., sip:12345678@myprovider.com.
    /// - for more, http: or https: schema is required.
    public var uri: String?
    
    // MARK: - Initialisers
    
    public init() {
        
    }
}
