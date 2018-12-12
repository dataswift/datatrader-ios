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

class UploadingViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var proggressBar: UIProgressView!
    @IBOutlet private weak var proggressLabel: UILabel!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var mainView: UIView!
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.roundCorners()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Update progress bar
    
    func updateProggress(progress: Double) {
        
        self.proggressBar.setProgress(Float(progress), animated: true)
        let tempProgress = Int(progress * 100)
        self.proggressLabel.text = "\(tempProgress)%"
    }
    
    // MARK: - Round Corners
    
    func roundCorners() {
        
        self.mainView.layer.cornerRadius = 5
        
        self.baseView.addShadow(color: .black, shadowRadius: 2, shadowOpacity: 0.7, width: 2, height: 2)
    }

}
