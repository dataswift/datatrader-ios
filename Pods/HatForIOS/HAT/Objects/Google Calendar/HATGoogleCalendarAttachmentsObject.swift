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

public struct HATGoogleCalendarAttachmentsObject: HATObject {
    
    // MARK: - Variables
    
    /// ID of the attached file. Read-only.
    /// For Google Drive files, this is the ID of the corresponding [Files](https://developers.google.com/drive/v3/reference/files) resource entry in the Drive API.
    public var fileId: String = ""
    /// URL link to the attachment.
    /// For adding Google Drive file attachments use the same format as in **alternateLink** property of the **Files** resource in the Drive API.
    public var fileUrl: String = ""
    /// URL link to the attachment's icon. Read-only.
    public var iconLink: String = ""
    /// Internet media type (MIME type) of the attachment.
    public var mimeType: String?
    /// Attachment title.
    public var title: String = ""
    
    // MARK: - Initialisers
    
    public init() {
        
    }
}
