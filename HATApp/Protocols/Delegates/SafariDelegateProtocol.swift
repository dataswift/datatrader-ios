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

import SafariServices

// MARK: Protocol

protocol SafariDelegateProtocol: class {
    
    // MARK: - Variables

    /// a variable to store and access the SFSafariViewController when needed
    var safariVC: SFSafariViewController? { get set }
    
    // MARK: - Functions
    
    /**
     Open the URL in safari
     
     - parameter hat: The hat url address to load
     - parameter animated: A bool in order to animate safari or not
     - parameter completion: A function to execute after safari launched
     */
    func openInSafari(url: String, animated: Bool, completion: (() -> Void)?)
    
    /**
     Dismiss safari
     
     - parameter animated: A bool in order to animate safari or not
     - parameter completion: A function to execute after safari dismissed
     */
    func dismissSafari(animated: Bool, completion: (() -> Void)?)
}
