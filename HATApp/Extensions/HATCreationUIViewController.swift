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

import HatForIOS

// MARK: Class

/// Used in the HAT Creation view controller. Holds variables and functions used in that view controllers to make everything simpler
internal class HATCreationUIViewController: BaseViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    /// An IBOutlet to handle the scrollView on the UIViewController. Mainly used to scroll the viewController on keyboard events
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Variables
    
    /// The keyboard manager. Handles all the events about the keyboard showing/hiding
    var keyboardManager: KeyboardManager = KeyboardManager()
    /// The purchaseModel object. This is sent to HAT in order to create a hat
    var purchaseModel: PurchaseObject = PurchaseObject()
    /// The cluster name, in order to differentiate between testing, hubat.net, and stable, hat.direct, hats
    let cluster: String = {
        
        if AppStatusManager.isAppBeta() {
            
            return "hubat.net"
        }
        
        return "hat.direct"
    }()
    
    // MARK: - IBAction
    
    /**
     Called when user has tapped "Already have an account? Log in. Redirects user to root view controller(LoginViewController)"
     
     - parameter sender: The object that called the method
     */
    @IBAction func logInButtonAction(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - View Controller Delegate
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.keyboardManager.view = self.view
        keyboardManager.hatUIViewScrollView = self.scrollView

        keyboardManager.addKeyboardHandling()
        keyboardManager.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Text field delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        keyboardManager.activeField = textField
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc: HATCreationUIViewController = segue.destination as? HATCreationUIViewController {
            
            vc.purchaseModel = self.purchaseModel
        }
    }

}
