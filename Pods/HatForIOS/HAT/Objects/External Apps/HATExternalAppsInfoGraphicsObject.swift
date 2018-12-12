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

public struct HATExternalAppsInfoGraphicsObject: HATObject {

    // MARK: - Variables
    
    /// The banner logo
    public var banner: HATExternalAppsIllustrationObject = HATExternalAppsIllustrationObject()
    /// The app logo
    public var logo: HATExternalAppsIllustrationObject = HATExternalAppsIllustrationObject()
    /// The screenshots used in the preview
    public var screenshots: [HATExternalAppsIllustrationObject] = []
}
