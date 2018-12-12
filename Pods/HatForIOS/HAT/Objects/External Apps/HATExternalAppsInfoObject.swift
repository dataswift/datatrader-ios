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

public struct HATExternalAppsInfoObject: HATObject {
    
    // MARK: - Variables
    
    /// The current version of the app
    public var version: String = ""
    
    /// A bool indicating if the app has been published or not
    public var published: Bool = false
    
    /// The name of the app
    public var name: String = ""
    
    /// The terms url
    public var termsUrl: String = ""
    
    /// The support email address
    public var supportContact: String = ""
    
    /// The headline text to describe the app
    public var headline: String = ""
    
    /// The rating of the app
    public var rating: HATExternalAppsInfoRatingObject?
    
    /// The description text of the app
    public var description: HATExternalAppsInfoDescriptionObject = HATExternalAppsInfoDescriptionObject()
    
    /// The data preview of the app
    public var dataPreview: [HATFeedObject] = []
    
    /// The graphics, images, needed for this app (logo, banner and screenshots)
    public var graphics: HATExternalAppsInfoGraphicsObject = HATExternalAppsInfoGraphicsObject()
}
