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

public struct PurchaseObject: HATObject {
    
    // MARK: - Variables
    
    /// First name of the new user
    public var firstName: String = ""
    /// Has new user agreed to terms
    public var termsAgreed: Bool = false
    /// Last name of the new user
    public var lastName: String = ""
    /// Email of the new user
    public var email: String = ""
    /// HAT name of the new user
    public var hatName: String = ""
    /// Password of the new user
    public var password: String = ""
    /// HAT cluster of the new user
    public var hatCluster: String = ""
    /// HAT country of the new user
    public var hatCountry: String = ""
    /// Membership info of the new user
    public var membership: PurchaseMembershipObject = PurchaseMembershipObject()
    /// The application ID that registers this hat
    public var applicationId: String = ""
    /// The optins to mail subscriptions
    public var optins: [String] = []
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
    }
}
