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

internal class LoadingScreenViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var loadingMessageLabel: UILabel!
    @IBOutlet private weak var loadingButton: UIButton!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var baseView: UIView!
    
    // MARK: - Variable
    
    var completionAction: (() -> Void)?
    
    // MARK: - IBAction
    
    /**
     Executes some function
     
     - parameter sender: The object that called this function
     */
    @IBAction private func loadingButtonAction(_ sender: Any) {
        
        completionAction?()
    }
    
    // MARK: - View Controller funtions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Round Corners
    
    func roundCorners() {
        
        self.mainView.layer.cornerRadius = 5
        
        self.baseView.addShadow(color: .black, shadowRadius: 2, shadowOpacity: 0.7, width: 2, height: 2)
    }
    
    // MARK: - Set Message
    
    /**
     Sets the message in the loading screen
     
     - parameter message: The message to show on the label
     */
    func setMessage(_ message: String) {
        
        self.loadingMessageLabel.text = message
    }
    
    // MARK: - Set button title

    /**
     Sets the button title
     
     - parameter title: An optional String to show to the button
     */
    func setButtonTitle(_ title: String?) {
        
        guard let title: String = title else {
            
            return
        }
        
        self.loadingButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Set button hidden
    
    /**
     Hides or shows the button
     
     - parameter isHidden: A bool value indicating if the button is hidden or not
     */
    func setButtonHidden(_ isHidden: Bool) {
        
        self.loadingButton.isHidden = isHidden
    }
}
