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

public struct HATToolsInfoObject: HATObject {

    public var version: String = ""
    public var versionReleaseDate: String = ""
    public var name: String = ""
    public var headline: String = ""
    public var description: HATExternalAppsInfoDescriptionObject = HATExternalAppsInfoDescriptionObject()
    public var termsUrl: String = ""
    public var supportContact: String = ""
    public var dataPreview: [HATFeedObject]?
    public var graphics: HATToolsGraphicsObject = HATToolsGraphicsObject()
    public var dataPreviewEndpoint: String = ""
}
