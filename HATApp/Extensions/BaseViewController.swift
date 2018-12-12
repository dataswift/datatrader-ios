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

// MARK: Class

internal class BaseViewController: UIViewController {
    
    // MARK: - Variables
    
    /// A variable used to save the color of the previous navigation bar
    var previousNavigationBarColor: UIColor?
    
    // MARK: - Functions
    
    override func willMove(toParent parent: UIViewController?) {
        
        super.willMove(toParent: parent)
        
//        guard parent != nil, self.previousNavigationBarColor != nil else { return }
//        
//        navigationController?.navigationBar.barTintColor = self.previousNavigationBarColor //previous color
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let barColor: UIColor = self.navigationController?.navigationBar.barTintColor else {
            
            return
        }
        
        if let vc: BaseViewController = segue.destination as? BaseViewController {
            
            // save the current navigation bar color before
            vc.previousNavigationBarColor = barColor
        }
        
        if let vc: HATCreationUIViewController = segue.destination as? HATCreationUIViewController {
            
            // save the current navigation bar color before
            vc.previousNavigationBarColor = barColor
        }
    }
}
