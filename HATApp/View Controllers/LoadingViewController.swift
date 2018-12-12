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

class LoadingViewController: UIViewController {
    
    // MARK: - IBOutlet

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var mainView: UIView!
    
    // MARK: - View Controller funtions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.logoImageView.layer.masksToBounds = true
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.width / 2
        self.progressBar.isHidden = true
    }
    
    func setMainTitle(_ text: String?) {
        
        self.titleLabel.text = text
    }

    func setDescription(_ text: String?) {
        
        self.descriptionLabel.text = text
    }
}
