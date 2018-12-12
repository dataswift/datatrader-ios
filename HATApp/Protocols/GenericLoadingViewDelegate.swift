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

protocol GenericLoadingViewDelegate: class {

    // MARK: - Variables
    
    /// The loading pop up screen
    var loadingView: LoadingViewController? { get set }
    
    // MARK: - Functions
    
    /**
     Shows the pop up menu with the specified title and button
     
     - parameter title: The main text message to display
     - parameter description: The description text
     */
    func showLoadingView(title: String, description: String?)
    
    /**
     Dismisses the pop up
     */
    func dismissLoadingView(completion: (() -> Void)?)
}
