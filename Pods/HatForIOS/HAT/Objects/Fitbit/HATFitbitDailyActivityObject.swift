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

public struct HATFitbitDailyActivityObject: HATObject {
    
    // MARK: - Variables
    
    /// The total daily steps
    public var steps: Int = 0
    /// The date created in unix time stamp
    public var dateCreated: Int?
    /// the total daily floors
    public var floors: Int?
    /// The daily distances covered
    public var distances: [HATFitbitDailyActivityDistanceObject] = []
    /// The total daily elevation gain
    public var elevation: Int?
    /// The daily active score
    public var activeScore: Int = 0
    /// The daily BMR caloried
    public var caloriesBMR: Int = 0
    /// The daily burnt calories
    public var caloriesOut: Int = 0
    /// The daily activity calories
    public var activityCalories: Int = 0
    /// The daily marginal calories
    public var marginalCalories: Int = 0
    /// The daily sedentary minutes
    public var sedentaryMinutes: Int = 0
    /// The daily very active minutes
    public var veryActiveMinutes: Int = 0
    /// The daily fairly active minutes
    public var fairlyActiveMinutes: Int = 0
    /// The daily lighly active minutes
    public var lightlyActiveMinutes: Int = 0
}
