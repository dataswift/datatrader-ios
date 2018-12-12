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

public struct DataOfferRequiredDataDefinitionBundleKeyV2: Codable {
    
    // MARK: - Variables
    
    /// The endpoints of the definition
    public var endpoints: [DataOfferRequiredDataDefinitionBundleKeyEndpointsV2] = []
    /// The ordering filter of the defition
    public var orderBy: String?
    /// The order, ascending of descending
    public var ordering: String?
    /// The limit of the filter
    public var limit: Int?
}
