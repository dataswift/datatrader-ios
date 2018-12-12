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

public struct HATFeedContentObject: Codable {
    
    // MARK: - Variables
    
    /// The content of the feed item
    public var text: String?
    /// The media of the feed item
    public var media: [HATFeedContentMediaObject]?
    /// The nested structure if ane of the feed item. Used for insights
    public var nestedStructure: [String: [HATFeedContentNestedObject]]?
    
    public init() {
        
    }
}
