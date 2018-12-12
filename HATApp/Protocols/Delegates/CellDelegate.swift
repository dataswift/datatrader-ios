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

// MARK: Protocol

protocol CellDelegate: class {
    
    // MARK: - Open in safari

    /**
     Tells the parent view controller to launch safari
     
     - parameter url: The url to open safari to
     */
    func openInSafari(url: String)
    
    /**
     Tells the parent view controller to send an email to that address
     
     - parameter address: The address to send email to
     */
    func sendEmail(address: String)
}
