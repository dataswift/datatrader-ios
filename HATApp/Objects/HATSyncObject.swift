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

import HatForIOS

// MARK: Struct

struct HATSyncObject<T: HATObject>: HATObject {
    
    // MARK: - Variables
    
    /// The url of the item to sync
    var url: String = ""
    /// The item itself
    var object: T?
    /// The data of the item
    var data: Data?
    /// The dictionary of the item
    var dictionary: [String: T]?
}
