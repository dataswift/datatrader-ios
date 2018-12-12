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

public struct HATExternalAppsObject: HATObject {
    
    // MARK: - Variables
    
    /// The id of the specified application
    public var id: String = ""
    /// The kind and the urls of the app
    public var kind: HATExternalAppsKindObject = HATExternalAppsKindObject()
    /// Various information about the app, released, version etc.
    public var info: HATExternalAppsInfoObject = HATExternalAppsInfoObject()
    /// Information about the developer
    public var developer: HATExternalAppsInfoDeveloperObject = HATExternalAppsInfoDeveloperObject()
    /// App's permissions to read or write to HAT
    public var permissions: HATExternalAppsPermissionsObject = HATExternalAppsPermissionsObject()
    /// Details about the setup of the app, such as the iosURL needed
    public var setup: HATExternalAppsSetupObject = HATExternalAppsSetupObject()
    /// The status of the app on HAT
    public var status: HATExternalAppsStatusObject = HATExternalAppsStatusObject()
}
