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

// MARK: Struct

internal class ConfirmationViewController: HATCreationUIViewController {
    
    // MARK: - Variables
    
    private var termsURL: String?
    
    // MARK: - IBOutlets

    ///An IBOutlet to handle the confirm Button
    @IBOutlet private weak var confirmButton: UIButton!
    ///An IBOutlet to handle the terms Label
    @IBOutlet private weak var termsLabel: UILabel!
    
    // MARK: - IBActions
    
    /**
     User tapped the confirm button. It goes to the hat creation page to create the HAT
     
     - parameter sender: The object that called this method
     */
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        self.purchaseModel.termsAgreed = true
        self.performSegue(withIdentifier: SeguesConstants.confirmToCreateHATSegue, sender: self)
    }
    
    // MARK: - View Controller functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.confirmButton.layer.cornerRadius = 5
        
        let newsString: NSMutableAttributedString = NSMutableAttributedString(string: "By selecting ‘Confirm’ I agree that I have read and accept the HAT Terms and Conditions and Privacy Policy")
        newsString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange.init(location: 67, length: 20))
        newsString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange.init(location: 92, length: 14))
        self.termsLabel.attributedText = newsString
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapGestureRecogniser(tapGestureRecogniser:)))
        tapGesture.numberOfTapsRequired = 1
        termsLabel.isUserInteractionEnabled = true
        termsLabel.addGestureRecognizer(tapGesture)
        
        self.setNavigationBarColorToDarkBlue()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Tap Gesture recogniser
    
    /**
     Detects if the user tapped the label in the range we want
     
     - parameter tapGestureRecogniser: The UITapGestureRecognizer that called this method
     */
    @objc
    private func termsLabelTapGestureRecogniser(tapGestureRecogniser: UITapGestureRecognizer) {
        
        guard let text = self.termsLabel.text else { return }
        
        // get range of the words
        let hatTermsRange = text.range(of: "Terms and Conditions")?.nsRange
        let hatdexTermsRange = text.range(of: "Privacy Policy")?.nsRange
        
        if (tapGestureRecogniser.didTapAttributedTextInLabel(self.termsLabel, inRange: hatTermsRange!)) {
            
            self.termsURL = TermsURL.termsAndConditions
            self.performSegue(withIdentifier: SeguesConstants.showNewUserTermsSegue, sender: self)
        } else if (tapGestureRecogniser.didTapAttributedTextInLabel(self.termsLabel, inRange: hatdexTermsRange!)) {
            
            self.termsURL = TermsURL.privacyPolicy
            self.performSegue(withIdentifier: SeguesConstants.showNewUserTermsSegue, sender: self)
        }
    }
    
    // MARK: - Navigate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? MarkdownViewController,
            let termsURL = self.termsURL {
            
            vc.url = termsURL
        }
    }

}
