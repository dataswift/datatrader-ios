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

// MARK: Extension

extension UIActivityIndicatorView {
    
    // MARK: - Add Indicator

    /**
     Creates and adds an UIActivityIndicatorView to the view passed as parameter. Returns that instance for future use
     
     - parameter view: The view to add the indicator to
     
     - returns: The initiated and animating UIActivityIndicatorView instance
     */
    static func addActivityIndicator(onView view: UIView) -> UIActivityIndicatorView {
       
        let frame: CGRect = view.bounds
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: frame)
        activityIndicator.color = .lightGray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
}
