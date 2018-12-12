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

import UIKit

protocol RefreshControlProtocol: class {
    
    func addRefreshControlTo(_ view: UIScrollView, target: BaseViewController, selector: Selector, refreshControlColor: UIColor)
}

extension RefreshControlProtocol {
    
    func addRefreshControlTo(_ view: UIScrollView, target: BaseViewController, selector: Selector,  refreshControlColor: UIColor = .gray) {
        
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.tintColor = refreshControlColor
        
        refreshControl.addTarget(target, action: selector, for: .valueChanged)
        
        view.alwaysBounceVertical = true
        view.refreshControl = refreshControl
    }
}
