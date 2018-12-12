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

class EnableLocationsViewController: BaseViewController {

    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var doNotAllowButton: UIButton!
    
    @IBAction func allowButtonAction(_ sender: Any) {
        
        KeychainManager.setKeychainValue(key: KeychainConstants.locationScreenShown, value: KeychainConstants.Values.setTrue)
        
        let locationManager = LocationManager.shared

        locationManager.requestAuthorisation()
        locationManager.resumeLocationServices()
        locationManager.startUpdatingLocation()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doNotAllowButtonAction(_ sender: Any) {
        
        KeychainManager.setKeychainValue(key: KeychainConstants.locationScreenShown, value: KeychainConstants.Values.setFalse)
        KeychainManager.setKeychainValue(key: KeychainConstants.trackDeviceKey, value: KeychainConstants.Values.setFalse)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.doNotAllowButton.layer.cornerRadius = 5
        self.allowButton.layer.cornerRadius = 5
        self.doNotAllowButton.addBorder(width: 1, color: .selectionColor)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
