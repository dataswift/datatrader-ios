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

public struct HATFitbitProfileObject: HATObject {
    
    // MARK: - Variables

    /// The user's age
    public var age: Int = 0
    /// The avatar image url of the user
    public var avatar: String = ""
    /// The user's gender
    public var gender: String = ""
    /// The user's height
    public var height: Int = 0
    /// The user's locale
    public var locale: String = ""
    /// The user's weight
    public var weight: Float = 0
    /// The user's features
    public var features: HATFitbitProfileFeaturesObject = HATFitbitProfileFeaturesObject()
    /// The user's full name
    public var fullName: String = ""
    /// The user's last name
    public var lastName: String = ""
    /// The user's swim distance unit
    public var swimUnit: String = ""
    /// The user's time zone
    public var timezone: String = ""
    /// The user's avatar url in 150x150
    public var avatar150: String = ""
    /// The user's avatar url in 640x640
    public var avatar640: String = ""
    /// Is profile corporate
    public var corporate: Bool = false
    /// The encoded id
    public var encodedId: String = ""
    /// The user's first name
    public var firstName: String = ""
    /// The date the profile was created
    public var dateCreated: String?
    /// The user's top badges earned
    public var topBadges: [HATFitbitProfileTopBadgesObject] = []
    /// Is the user an ambassador
    public var ambassador: Bool = false
    /// The user's height unit
    public var heightUnit: String = ""
    /// Is mfa enabled
    public var mfaEnabled: Bool = false
    /// The user's weight unit
    public var weightUnit: String = ""
    /// The user's date of birth
    public var dateOfBirth: String = ""
    /// The user's display name
    public var displayName: String = ""
    /// The user's glucose unit
    public var glucoseUnit: String = ""
    /// The date the user joined Fitbit
    public var memberSince: String = ""
    /// The user's distance unit
    public var distanceUnit: String = ""
    /// Is profile corporate admin
    public var corporateAdmin: Bool = false
    /// The start date of the week
    public var startDayOfWeek: String = ""
    /// The user's average daily steps
    public var averageDailySteps: Int = 0
    /// The user's display name
    public var displayNameSetting: String = ""
    /// The user's offset from UTC in ms
    public var offsetFromUTCMillis: Int = 0
    /// The user's stride length while running
    public var strideLengthRunning: Float = 0
    /// The user's stride length while walking
    public var strideLengthWalking: Float = 0
    /// The user's clock time display format
    public var clockTimeDisplayFormat: String = ""
    /// The user's stride length while running type
    public var strideLengthRunningType: String = ""
    /// The user's stride length while walking type
    public var strideLengthWalkingType: String = ""
}
