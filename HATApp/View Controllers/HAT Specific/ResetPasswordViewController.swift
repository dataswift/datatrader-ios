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

internal class ResetPasswordViewController: HATUIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var userDomainLabel: UILabel!
    @IBOutlet private weak var userClusterLabel: UILabel!
    @IBOutlet private weak var textViewBackgroundView: UIView!
    @IBOutlet private weak var hatLogoImageView: UIImageView!
    @IBOutlet private weak var hatEmailTextField: UITextField!
    
    // MARK: - IBActions
    
    /**
     Sends the profile data to hat
     
     - parameter sender: The object that calls this function
     */
    @IBAction func saveButtonAction(_ sender: Any) {
        
        guard let email = hatEmailTextField.text,
            email != "" else { return }
        
        HATAccountService.resetPassword(
            userDomain: userDomain,
            userToken: userToken,
            email: email,
            successCallback: passwordResetSuccess,
            failCallback: passwordResetFailed)
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.saveButton.layer.cornerRadius = 5
        self.textViewBackgroundView.addBorder(width: 1, color: UIColor.hatDisabled)
        self.hatLogoImageView.layer.masksToBounds = true
        self.hatLogoImageView.layer.cornerRadius = self.hatLogoImageView.frame.width / 2
        self.splitUserDomain()
        
        self.setNavigationBarColorToDarkBlue()
    }
    
    // MARK: - Scroll View methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.hatUIViewScrollView = scrollView
    }
    
    // MARK: - Split user domain
    
    private func splitUserDomain() {
        
        let array = self.userDomain.split(separator: ".")
        
        guard array.count > 2 else { return }
        
        self.userDomainLabel.text = String(array.first ?? "")
        self.userClusterLabel.text = ".\(String(array[1])).\((array[2]))"
    }
    
    // MARK: - Password reset callbacks
    
    private func passwordResetSuccess(message: String, newUserToken: String?) {
        
        self.createDressyClassicOKAlertWith(
            alertMessage: "Check your email for your password reset request. You now have been logged out",
            alertTitle: "Password reset requested",
            okTitle: "OK",
            proceedCompletion: { [weak self] in
                
                FeedbackManager.vibrateWithHapticEvent(type: .success)
                HATLoginService.logOut(userDomain: self?.userDomain ?? "", completion: {
                    
                    self?.navigateToViewControllerWith(name: ViewControllerNames.loginView)
                })
        })
    }
    
    private func passwordResetFailed(error: HATError) {
        
    }
    
}
