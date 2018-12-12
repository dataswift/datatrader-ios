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

class FirstOnboardingViewController: OnboardingViewController, UserCredentialsProtocol {
    
    var pageNumber: Int?
    var titleToShow: String?
    var descriptionToShow: String?
    var imageURL: String?
    var isFinalPage: Bool?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    
    @IBAction func skipButtonAction(_ sender: Any) {
        
        delegate?.dismissPageViewController()
    }
    
    @IBAction func nextScreenButtonAction(_ sender: Any) {
        
        if isFinalPage ?? false {
            
            delegate?.dismissPageViewController()
        } else {
            
            delegate?.nextViewController()
            delegate?.updatePageControlIndex(1)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if titleToShow != nil {
            
            self.titleLabel.text = titleToShow
        }
        
        if descriptionToShow != nil {
            
            self.descriptionLabel.text = descriptionToShow
        }
        
        if imageURL != nil {
            
            if let url = URL(string: imageURL!) {
                
                self.imageView.cacheImage(resource: url, placeholder: nil, userDomain: self.userDomain, progressBlock: nil, completionHandler: nil)
            }
        }
        
        if isFinalPage ?? false {
            
            self.skipButton.isHidden = true
            self.doneButton.setImage(nil, for: .normal)
            self.doneButton.setTitle("Done", for: .normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
