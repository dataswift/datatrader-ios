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

import SwiftyJSON

// MARK: Struct

public struct DataDebitObject: HATObject {
    
    // MARK: - Variables
    
    /// The data debit key
    public var dataDebitKey: String = ""
    /// The date created of the data debit
    public var dateCreated: String = ""
    /// The permissions of the data debit
    public var permissions: [DataDebitPermissionsObject] = []
    /// The client name of the data debit
    public var requestClientName: String = ""
    /// The client url of the data debit
    public var requestClientUrl: String = ""
    /// The client logo URL of the data debit
    public var requestClientLogoUrl: String = ""
    /// The description of the data debit
    public var requestDescription: String?
    /// The id of the application, if the data debit is an application
    public var requestApplicationId: String?
    /// Is data debit active?
    public var active: Bool = false
    /// The start date of the data debit
    public var start: String?
    /// The end date of the data debit
    public var end: String?
    /// Are permissions still active
    public var permissionsActive: DataDebitPermissionsObject?
    /// The last permission set
    public var permissionsLatest: DataDebitPermissionsObject = DataDebitPermissionsObject()
}
