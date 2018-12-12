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

public struct HATFeedTitleObject: Codable {
    
    // MARK: - Variables
    
    /// The text of the feed item
    public var text: String = ""
    /// The subtitle of the feed item
    public var subtitle: String?
    /// The action of the feed item
    public var action: String?
}
