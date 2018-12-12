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

// MARK: Protocol

protocol FieldUpdatedDelegate: class {
    
    // MARK: - Protocol's functions

    /**
     Updates the field cell with values from the profile
     
     - parameter textField: The textField of the cell
     - parameter indexPath: The IndexPath of the cell to update
     - parameter profile: The profile model to use while updating the cell
     - parameter isTextURL: A check for the url only fields
     */
    func fieldUpdated(textField: UITextField, indexPath: IndexPath, profile: HATProfileObject, isTextURL: Bool?)
    
    /**
     Updates the field cell with values from the profile
     
     - parameter dictionary: The dictionary created in order to add it the shared fields dictionary in AccountSettingsViewController
     */
    func buttonStateChanged(dictionary: Dictionary<String, String>)
}
