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

public struct HATFeedLocationAddressObject: HATObject {

    /// Tha name of the address, in case it's just a string like google calendar
    public var name: String?
    /// Tha name of the city, in case it's just a string like google calendar
    public var city: String?
    /// Tha name of the country, in case it's just a string like google calendar
    public var country: String?
}
