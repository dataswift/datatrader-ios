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

// MARK: - Protocol

/// A protocol to enforce view controllers that want a side menu to have a strong reference to it, in order to dismiss it later
protocol PresentableSideMenuProtocol: class {

    // MARK: - Variables
    
    /// A variable to store the SideMenuViewController in order to know it's state, if not nil it's visible, and also we need this in order to dismiss it later
    var sideMenuViewController: SideMenuViewController? { get set }
}
