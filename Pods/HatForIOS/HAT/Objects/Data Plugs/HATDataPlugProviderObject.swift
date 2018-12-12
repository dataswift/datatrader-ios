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

public struct HATDataPlugProviderObject: HATObject {

    // MARK: - Variables
    
    /// The id of the provider
    public var id: String = ""
    /// The email of the provider
    public var email: String = ""
    /// Is he provider email confirmed
    public var emailConfirmed: Bool = false
    /// The password
    public var password: String = ""
    /// The name of the provider
    public var name: String = ""
    /// The date created of the provider
    public var dateCreated: Int = 0
}
