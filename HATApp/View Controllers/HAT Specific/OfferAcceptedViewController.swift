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

class OfferAcceptedViewController: UIViewController {

    @IBOutlet private weak var viewOffersButton: UIButton!
    
    @IBAction func viewOffersButtonAction(_ sender: Any) {
        
        self.navigateToViewControllerWith(name: ViewControllerNames.offersViewController)
    }
    
    @IBAction func browseOffersButtonAction(_ sender: Any) {
        
        self.navigateToViewControllerWith(name: ViewControllerNames.recentOffersViewController)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUpUI()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    private func setUpUI() {
        
        self.viewOffersButton.layer.cornerRadius = 5
        
        self.viewOffersButton.addShadow(
            color: .mainColor,
            shadowRadius: 5,
            shadowOpacity: 0.6,
            width: 1,
            height: 10)
    }

}
