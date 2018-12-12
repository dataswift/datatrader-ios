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

public struct HATFitbitActivityObject: HATObject {
    
    // MARK: - Variables
    
    /// The log id of the activity
    public var logId: Int = 0
    /// Total steps in the activity
    public var steps: Int?
    /// The type of the log
    public var logType: String = ""
    /// The tcxlink
    public var tcxLink: String?
    /// Total calories burnt during the activity
    public var calories: Int = 0
    // The duration of the activity in ms
    public var duration: Int64 = 0
    /// The start time of the activity
    public var startTime: String = ""
    /// The name of the activity
    public var activityName: String = ""
    /// The date the activity was last modified
    public var lastModified: String = ""
    /// The activity level
    public var activityLevel: [HATFitbitActivityLevelObject] = []
    /// The elavation gain during the activity
    public var elevationGain: Float?
    /// The heart rate link
    public var heartRateLink: String?
    /// The duration active during the activity
    public var activeDuration: Int = 0
    /// The activity type ID
    public var activityTypeId: Int = 0
    /// The heart rate zones
    public var heartRateZones: [HATFitbitActivityHeartRateZoneObject]?
    /// The average heart rate during the activity
    public var averageHeartRate: Int?
    /// The original duration of the activity
    public var originalDuration: Int = 0
    /// The original start time
    public var originalStartTime: String = ""
    /// The manual specified values
    public var manualValuesSpecified: HATFitbitActivityManualValuesObject = HATFitbitActivityManualValuesObject()
}
