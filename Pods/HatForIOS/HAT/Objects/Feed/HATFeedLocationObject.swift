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

public struct HATFeedLocationObject: HATObject {
    
    // MARK: - Variables

    /// The address of the location
    public var address: HATFeedLocationAddressObject?
    
    /// The geolocation of the location
    public var geo: HATFeedLocationGeoObject?
}
