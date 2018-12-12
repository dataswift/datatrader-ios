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

public struct DataOfferRequiredDataDefinitionBundleKeyEndpointsV2: Codable {
    
    // MARK: - Variables
    
    /// The endpoint of the definition object
    public var endpoint: String = ""
    /// The mapping of the definition object
    public var mapping: Dictionary<String, String>?
    /// The filters of the definition object
    public var filters: [DataOfferRequiredDataDefinitionBundleFiltersV2]?
    /// The links of the definition object
    public var links: [DataOfferRequiredDataDefinitionBundleKeyEndpointsV2]?
}
