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

public struct DataDebitPermissionsObject: HATObject {

    // MARK: - Variables
    
    /// The created date of the permission
    public var dateCreated: String = ""
    /// The purpose of the permission
    public var purpose: String?
    /// The start date of the permission
    public var start: String?
    /// The end date of the permission
    public var end: String?
    /// A flag indicating if the permissions will auto cancel when the debit will end
    public var cancelAtPeriodEnd: Bool = false
    /// The terms and conditions URL for the permissions
    public var termsUrl: String?
    /// The period duration
    public var period: Int = 0
    /// Is the permission active
    public var active: Bool = false
    /// Is the permission accepted
    public var accepted: Bool = false
    /// It is possible for a permission to have an inner bundle object
    public var bundle: DataOfferRequiredDataDefinitionObjectV2 = DataOfferRequiredDataDefinitionObjectV2()
    public var conditions: DataOfferRequiredDataDefinitionObjectV2?
}
