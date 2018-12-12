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

public struct HATFitbitWeightObject: HATObject {
    
    // MARK: - Variables

    /// User's BMI
    public var bmi: Float = 0
    /// User's fat
    public var fat: Float = 0
    /// User's weight date recorded
    public var date: String = ""
    /// User's weight time recorder
    public var time: String = ""
    /// Weight log ID
    public var logId: Int = 0
    /// User's weight sourse
    public var source: String = ""
    /// User's weight
    public var weight: Float = 0
}
