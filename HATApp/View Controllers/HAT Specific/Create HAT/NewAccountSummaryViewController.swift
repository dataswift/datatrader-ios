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

internal class NewAccountSummaryViewController: HATCreationUIViewController {

    // MARK: - IBOutlets
    
    ///An IBOutlet to handle the hatName Label
    @IBOutlet private weak var hatNameLabel: UILabel!
    ///An IBOutlet to handle the hatCluster Label
    @IBOutlet private weak var hatClusterLabel: UILabel!
    ///An IBOutlet to handle the cover UIView
    @IBOutlet private weak var coverView: UIView!
    ///An IBOutlet to handle the connectDataPlugs Button
    @IBOutlet private weak var connectDataPlugsButton: UIButton!
    ///An IBOutlet to handle the tip Label
    @IBOutlet private weak var tipLabel: UILabel!

    // MARK: - IBActions
    
    /**
     Goes back to the login screen after the hat has been created
     
     - parameter sender: The object that called this method
     */
    @IBAction func connectDataPlugsButtonAction(_ sender: Any) {
        
        self.purchaseModel.termsAgreed = true
        //self.performSegue(withIdentifier: SeguesConstants.newHatDataPlugsSegue, sender: self)
        KeychainManager.setKeychainValue(key: KeychainConstants.hatDomainKey, value: "\(hatNameLabel.text!).\(hatClusterLabel.text!)")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - View Controller functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.connectDataPlugsButton.layer.cornerRadius = 5
        
        self.connectDataPlugsButton.isUserInteractionEnabled = false
        self.connectDataPlugsButton.backgroundColor = .hatDisabled
        self.connectDataPlugsButton.setTitle("Please wait", for: .normal)
        
        self.hatNameLabel.text = self.purchaseModel.hatName
        self.hatClusterLabel.text = self.purchaseModel.hatCluster
        
        HATService.confirmHATPurchase(
            purchaseModel: self.purchaseModel,
            succesfulCallBack: newHATCreated,
            failCallBack: newHatCreationFailed)
        
        self.setNavigationBarColorToDarkBlue()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Create HAT
    
    /**
     This method is called when the hat has been created successfuly
     
     - parameter message: The message passed from HAT, not used
     - parameter newToken: The token passed from HAT, not user it's nil since there is not used
     */
    func newHATCreated(message: String, newToken: String?) {
        
        FeedbackManager.vibrateWithHapticEvent(type: .success)
        
        self.refreshUI(true)
    }
    
    private func refreshUI(_ result: Bool) {
        
        if result {
            
            self.connectDataPlugsButton.setTitle("LOGIN TO YOUR HAT", for: .normal)
            self.connectDataPlugsButton.isUserInteractionEnabled = true
            self.connectDataPlugsButton.backgroundColor = .classicHATSelectionColor
            self.coverView.isHidden = true
        }
    }
    
    /**
     This method is called when the hat creation has failed
     
     - parameter error: The error returned from HAT
     */
    func newHatCreationFailed(error: JSONParsingError) {
        
        self.createDressyClassicOKAlertWith(alertMessage: "There was an error creating the hat. Please try again later", alertTitle: "Error!", okTitle: "Ok", proceedCompletion: nil)
    }

}
