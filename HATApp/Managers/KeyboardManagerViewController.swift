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

class KeyboardManager: NSObject {
    
    // MARK: - Variables

    /// The ScrollView used to lift or lower the view
    var hatUIViewScrollView: UIScrollView?
    /// The currenlty active textField, usefull in order to focus and calculate the amount the view needs to be lifted or lowered
    var activeField: UITextField?
    /// The current view
    var view: UIView = UIView()
    /// A boolean value to store if the keyboard is currently on screen or not
    private var isKeyboardShown: Bool = false
    /// A CGFloat value to store the keyboard size
    private var keyboardSize: CGFloat = 0
    
    // MARK: - Keyboard methods
    
    /**
     Hides keyboard when tap anywhere in the screen except keyboard
     */
    public func hideKeyboardWhenTappedAround() {
        
        // create tap gesture
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard)
        )
        // add gesture to view
        self.view.addGestureRecognizer(gesture)
    }
    
    /**
     Hides keyboard
     */
    @objc
    public func dismissKeyboard() {
        
        if self.hatUIViewScrollView == nil {
            
            self.view.endEditing(true)
        } else {
            
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.hatUIViewScrollView?.contentInset = contentInsets
            self.hatUIViewScrollView?.scrollIndicatorInsets = contentInsets
            self.view.endEditing(true)
            self.hatUIViewScrollView?.isScrollEnabled = false
        }
    }
    
    /**
     Adds keyboard handling to UIViewControllers via the common and standard Notifications
     */
    public func addKeyboardHandling() {
        
        // create 2 notification observers for listening to the keyboard
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(sender:)),
            name:UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(sender:)),
            name:UIResponder.keyboardWillHideNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(sender:)),
            name:UIResponder.keyboardDidHideNotification,
            object: nil)
    }
    
    /**
     Function executed before the keyboard is shown to the user
     
     - parameter sender: The object that called this method
     */
    @objc
    public func keyboardWillShow(sender: NSNotification) {
        
        guard let keyboardSize: CGSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size,
            keyboardSize.height != 0 else {
                
                return
        }
        
        if self.hatUIViewScrollView == nil {
            
            // add the previously stored size, to return the view to the normal position
            self.view.frame.origin.y = 0
            // remove the new keyboard size
            self.view.frame.origin.y -= keyboardSize.height
        } else {
            
            self.hatUIViewScrollView?.isScrollEnabled = true
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            self.hatUIViewScrollView?.contentInset = contentInsets
            self.hatUIViewScrollView?.scrollIndicatorInsets = contentInsets
            
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            if let activeField: UITextField = self.activeField {
                
                if (!aRect.contains(activeField.frame.origin)) {
                    
                    self.hatUIViewScrollView?.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }
        
        self.isKeyboardShown = true
        self.keyboardSize = keyboardSize.height
    }
    
    /**
     Function executed before the keyboard hides from the user
     
     - parameter sender: The object that called this method
     */
    @objc
    func keyboardWillHide(sender: NSNotification) {
        
        guard let keyboardSize: CGSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size,
            self.isKeyboardShown else {
                
                return
        }
        
        if self.hatUIViewScrollView == nil {
            
            self.view.frame.origin.y += keyboardSize.height
        } else {
            
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize.height, right: 0.0)
            self.hatUIViewScrollView?.contentInset = contentInsets
            self.hatUIViewScrollView?.scrollIndicatorInsets = contentInsets
            self.view.endEditing(true)
        }
        
        self.isKeyboardShown = false
        self.keyboardSize = 0
    }
    
    /**
     Hides the keyboard and restores the scrollView to its original place
     
     - parameter scrollView: The UIScrollView object to handle
     */
    func hideKeyboardInScrollView(_ scrollView: UIScrollView) {
        
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

}
