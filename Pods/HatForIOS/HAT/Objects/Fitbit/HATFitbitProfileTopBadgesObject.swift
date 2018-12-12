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

public struct HATFitbitProfileTopBadgesObject: HATObject {

    // MARK: - Variables
    
    /// The badge's name
    public var name: String = ""
    /// The badge's value
    public var value: Int = 0
    /// The badge's cheers
    public var cheers: [String] = []
    /// The badge's category
    public var category: String = ""
    /// The badge's date time earned
    public var dateTime: String = ""
    /// The badge's type
    public var badgeType: String = ""
    /// The badge's encoded ID
    public var encodedId: String = ""
    /// The badge's image URL in 50x50
    public var image50px: String = ""
    /// The badge's image URL in 75X75
    public var image75px: String = ""
    /// The badge's share text
    public var shareText: String = ""
    /// The badge's short name
    public var shortName: String = ""
    /// The badge's image URL in 100x100
    public var image100px: String = ""
    /// The badge's image URL in 125x125
    public var image125px: String = ""
    /// The badge's image URL in 300x300
    public var image300px: String = ""
    /// The badge's description
    public var description: String = ""
    /// The badge's message when earned
    public var earnedMessage: String = ""
    /// The total times this badge has been earned
    public var timesAchieved: Int = 0
    /// The badge's share image URL in 640x640
    public var shareImage640px: String = ""
    /// The badge's short description
    public var shortDescription: String = ""
    /// The badge's mobile description
    public var mobileDescription: String = ""
    /// The badge's marketing description
    public var marketingDescription: String = ""
    /// The badge's gradient end color
    public var badgeGradientEndColor: String = ""
    /// The badge's gradient start color
    public var badgeGradientStartColor: String = ""
}
