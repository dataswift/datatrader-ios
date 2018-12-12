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

internal class AccountSocialButtonsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    private var url: String?
    private var name: String?
    private var image: UIImage?
    weak var safariDelegate: SafariDelegateProtocol?
    
    // MARK: - IBOutlet
    
    @IBOutlet private var socialButton: UIButton!
    
    // MARK: - IBAction
    
    @IBAction func socialButtonAction(_ sender: Any) {
        
        guard let url: URL = URL(string: self.url!) else {
           
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            
            safariDelegate?.openInSafari(url: self.url!, animated: true, completion: nil)
        }
    }
    
    // MARK: - Set up cell
    
    func setUpCell(button: SocialButton, delegate: SafariDelegateProtocol?) -> UICollectionViewCell {
        
        self.name = button.name
        self.url = button.url
        self.safariDelegate = delegate
        
        if self.socialButton == nil {
            
            self.socialButton = UIButton(frame: self.frame)
        }
        self.image = button.button?.imageView?.image
        self.socialButton?.setImage(self.image, for: .normal)
        
        return self
    }
    
}
