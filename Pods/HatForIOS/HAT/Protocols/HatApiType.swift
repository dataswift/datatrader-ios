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

// MARK: Protocol

/// A protocol to make the objects conforming with it cachable
public protocol HatApiType {
    
    /**
     Converts the object to a Dictionary<String, Any> in order to be saved in cache in binary form
     
     - returns: The object as a Dictionary<String, Any>
     */
    func toJSON() -> Dictionary<String, Any>
    
    /**
     Converts a Dictionary<String, Any> to the object we need from the cache
     
     - parameter fromCache: The Dictionary<String, Any> to use in order to init the object
     */
    mutating func initialize(fromCache: Dictionary<String, Any>)
    
    /**
     A normal Initialiser
     */
    init()
}

// MARK: - Extension
//swiftlint:disable extension_access_modifier
extension HatApiType {
    
    /**
     Converts a Dictionary<String, Any> to the object we need from the cache
     
     - parameter fromCache: The Dictionary<String, Any> to use in order to init the object
     */
    public init(fromCache: Dictionary<String, Any>) {
        
        self.init()
        
        self.initialize(fromCache: fromCache)
    }
}
//swiftlint:enable extension_access_modifier
