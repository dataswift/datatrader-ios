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

/// A delegate protocol to provide action related functions, dismiss, tapped etc., for the side menu.
protocol SideMenuDelegateProtocol: class {
    
    // MARK: - Functions
    
    /**
     Executed after the dismissing animation has been completed to notify the delegate view controller of that fact.
     
     - parameter sender: The UIViewController called this function, the SideMenuViewController in that case
     - parameter dismissView: If the user tapped to switch to the same UIViewController that they are in then we don't want to dismiss the UIViewController, only the SideMenuViewController
     */
    func dismissSideMenu(sender: UIViewController, dismissView: Bool)
}
