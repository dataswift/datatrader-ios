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

import UIKit

// MARK: Protocol

protocol TextViewResizeDelegate: class {
    
    // MARK: - Protocol's functions

    /**
     Notifies the class registered as delegate that the textField has been updated
     
     - parameter textView: Tells the delegate that the UITextView has been updated
     */
    func textViewDidChange(textView: UITextView)
}
