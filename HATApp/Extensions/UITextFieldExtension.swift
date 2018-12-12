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

extension UITextField {
    
    // MARK: - Add Padding
    
    /**
     Adds a padding on the left side of the UITextField
     
     - parameter amount: The amount of padding to add
     */
    func setLeftPaddingPoints(_ amount: CGFloat) {
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    /**
     Adds a padding on the right side of the UITextField
     
     - parameter amount: The amount of padding to add
     */
    func setRightPaddingPoints(_ amount: CGFloat) {
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    // MARK: - Change font
    
    /**
     Changes the fond of the textField based on the range and the text it contains
     
     - parameter range: The range of the textField passed on from the textField delegate
     - parameter string: The string on the textField
     */
    func addFontChangingBasedOnText(range: NSRange, string: String) {
        
        if range.location == 0 && range.length == self.text?.count && string == "" {
            
            self.font = UIFont.openSans(ofSize: 14)
        } else {
            
            self.font = UIFont.openSansSemibold(ofSize: 14)
        }
    }
}
