//
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

public struct HATApplicationObject: HATObject {
    
    // MARK: - Variables
    
    public var application: HATExternalAppsObject = HATExternalAppsObject()
    public var setup: Bool = false
    public var active: Bool = false
    public var enabled: Bool = false
    public var needsUpdating: Bool?
    public var mostRecentData: String?
}
