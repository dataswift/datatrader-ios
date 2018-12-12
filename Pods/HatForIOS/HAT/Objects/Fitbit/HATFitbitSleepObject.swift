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

public struct HATFitbitSleepObject: HATObject {
    
    // MARK: - Variables

    /// The type of sleep
    public var type: String = ""
    /// The log ID of sleep
    public var logId: Int = 0
    /// The levels of sleep
    public var levels: HATFitbitSleepLevelsObject = HATFitbitSleepLevelsObject()
    /// The end time of sleep
    public var endTime: String = ""
    /// The duration of sleep
    public var duration: Int = 0
    /// The info code of sleep
    public var infoCode: Int = 0
    /// The start time of sleep
    public var startTime: String = ""
    /// The time in bed
    public var timeInBed: Int = 0
    /// The efficiency of sleep
    public var efficiency: Int = 0
    /// The date of sleep
    public var dateOfSleep: String = ""
    /// The minutes awake during sleep
    public var minutesAwake: Int = 0
    /// The minutes asleep during sleep
    public var minutesAsleep: Int = 0
    /// The minutes passed after wake up
    public var minutesAfterWakeup: Int = 0
    /// The minutes passed to fall asleep
    public var minutesToFallAsleep: Int = 0
}
