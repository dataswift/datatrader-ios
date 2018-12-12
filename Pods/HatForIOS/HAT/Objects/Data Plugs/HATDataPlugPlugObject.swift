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

public struct HATDataPlugPlugObject: HATObject {
    
    // MARK: - Variables

    /// The uuid of the plug
    public var uuid: String = ""
    /// The provider of the plug
    public var providerId: String = ""
    /// The date the plug was created as unix time stamp
    public var created: Int = 0
    /// The name of the plug
    public var name: String = ""
    /// The description of the plug
    public var description: String = ""
    /// The url of the plug
    public var url: String = ""
    /// The image url of the plug
    public var illustrationUrl: String = ""
    /// The password has value of the plug
    public var passwordHash: String = ""
    /// Is the plug approved for use
    public var approved: Bool = false
    
    /// is the plug connected, if it is show checkmark
    public var showCheckMark: Bool? = false
}
