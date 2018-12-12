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

protocol LoadingPopUpDelegateProtocol: class {
    
    // MARK: - Variables

    /// The loading pop up screen
    var loadingPopUp: LoadingScreenViewController? { get set }
    
    // MARK: - Functions
    
    /**
     Shows the pop up menu with the specified title and button
     
     - parameter message: The short message to display
     - parameter buttonTitle: The button title
     - parameter buttonAction: The action to execute when tapping the button
     - parameter selfDismissing: Defines if the pop up will be dismissed after a certain period of time
     - parameter fromY: Defines if the view should go above a certain Y when it shows
     */
    func showPopUp(message: String, buttonTitle: String?, buttonAction: (() -> Void)?, selfDissmising: Bool, fromY: CGFloat?)
    
    /**
     Dismisses the pop up
     */
    func dismissPopUp(completion: (() -> Void)?)
}
