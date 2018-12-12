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

public struct HATFitbitSleepLevelsDataObject: HATObject {
    
    // MARK: - Variables

    /// The sleep level
    public var level: String = ""
    /// The sleep duration in seconds
    public var seconds: Int = 0
    /// The sleep date time started
    public var dateTime: String = ""
}
