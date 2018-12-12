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

/// Simplify static plug info into a name and a value object to show it easily in the table view
internal struct PlugDetails {

    // MARK: - Variables
    
    /// The name of the plug field info value
    var name: String = ""
    /// The value of the plug field info
    var value: String = ""
}
