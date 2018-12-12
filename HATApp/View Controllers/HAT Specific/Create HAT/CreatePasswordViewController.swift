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

import zxcvbn_ios

// MARK: Class

internal class CreatePasswordViewController: HATCreationUIViewController {
    
    // MARK: - Variables
    
    /// The password's score
    private var score: Int = 0
    
    // MARK: - IBOutlets

    /// An IBOutlet to handle the password textField
    @IBOutlet private weak var passWordTextField: UITextField!
    /// An IBOutlet to handle the next Button
    @IBOutlet private weak var nextButton: UIButton!
    /// An IBOutlet to handle the passwordStrength Label
    @IBOutlet private weak var passwordStrengthLabel: UILabel!
    /// An IBOutlet to handle the passwordStrengthOne View, the first bar in scores
    @IBOutlet private weak var passwordStrengthOneView: UIView!
    /// An IBOutlet to handle the passwordStrengthTwo View, the second bar in scores
    @IBOutlet private weak var passwordStrengthTwoView: UIView!
    /// An IBOutlet to handle the passwordStrengthThree View, the third bar in scores
    @IBOutlet private weak var passwordStrengthThreeView: UIView!
    /// An IBOutlet to handle the passwordStrengthFour View, the fourth bar in scores
    @IBOutlet private weak var passwordStrengthFourView: UIView!
    
    // MARK: - IBActions
    
    /**
     Called when next button is pressed. Check the fields for error and checks with hat the email field. If ok continues to the next screen
     
     - parameter sender: The object that called the function
     */
    @IBAction func nextButtonAction(_ sender: Any) {
        
        self.checkPassword()
    }
    
    // MARK: - View controller delegate functions
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.passWordTextField.delegate = self
        self.passWordTextField.layer.borderWidth = 1
        self.passWordTextField.layer.borderColor = UIColor.hatDisabled.cgColor
        self.passWordTextField.setLeftPaddingPoints(20)
        
        self.nextButton.layer.cornerRadius = 5
        
        self.passwordStrengthLabel.text = ""
        
        self.setNavigationBarColorToDarkBlue()
        
        PasswordExtensionManager.addPasswordExtensionButtonToTextFieldIfPossible(
            textField: self.passWordTextField,
            viewController: self,
            target: #selector(self.generateNewPasswordFromPasswordManager(_:)),
            offsetXPos: -20)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Check Password
    
    /**
     Checks if the password has a score bigger than 2 in order to go to the next screen
     */
    private func checkPassword() {
        
        if self.score > 2 {
            
            self.purchaseModel.password = self.passWordTextField.text!
            self.performSegue(withIdentifier: SeguesConstants.createHATConfirmationSegue, sender: self)
        } else {
            
            self.createDressyClassicOKAlertWith(
                alertMessage: "Please create a password that is Strong or Very Strong on this scale",
                alertTitle: "Password too weak",
                okTitle: "OK",
                proceedCompletion: nil)
        }
    }
    
    // MARK: - Refresh UI
    
    /**
     Updates the score with color coded views and also with a description(Bad, Poor, Good, Very Good)
     */
    private func refreshPasswordIndicators() {
        
        if score >= 0 && score <= 1 {
            
            self.passwordStrengthOneView.backgroundColor = .hatPasswordRed
            self.passwordStrengthTwoView.backgroundColor = .hatPasswordGray
            self.passwordStrengthThreeView.backgroundColor = .hatPasswordGray
            self.passwordStrengthFourView.backgroundColor = .hatPasswordGray
            self.passwordStrengthLabel.text = "Poor"
            self.passwordStrengthLabel.textColor = .hatPasswordRed
        }
        if score >= 2 {
            
            self.passwordStrengthOneView.backgroundColor = .hatPasswordOrange
            self.passwordStrengthTwoView.backgroundColor = .hatPasswordOrange
            self.passwordStrengthThreeView.backgroundColor = .hatPasswordGray
            self.passwordStrengthFourView.backgroundColor = .hatPasswordGray
            self.passwordStrengthLabel.text = "Average"
            self.passwordStrengthLabel.textColor = .hatPasswordOrange
        }
        if score >= 3 {
            
            self.passwordStrengthOneView.backgroundColor = .hatPasswordGreen
            self.passwordStrengthTwoView.backgroundColor = .hatPasswordGreen
            self.passwordStrengthThreeView.backgroundColor = .hatPasswordGreen
            self.passwordStrengthFourView.backgroundColor = .hatPasswordGray
            self.passwordStrengthLabel.text = "Strong"
            self.passwordStrengthLabel.textColor = .hatPasswordGreen
        }
        if score >= 4 {
            
            self.passwordStrengthOneView.backgroundColor = .hatPasswordGreen
            self.passwordStrengthTwoView.backgroundColor = .hatPasswordGreen
            self.passwordStrengthThreeView.backgroundColor = .hatPasswordGreen
            self.passwordStrengthFourView.backgroundColor = .hatPasswordGreen
            self.passwordStrengthLabel.text = "Very Strong"
            self.passwordStrengthLabel.textColor = .hatPasswordGreen
        }
    }
    
    /**
     Updates the button color and if it's selectable or not, depenting from the password score
     */
    private func updateButtonState() {
        
        if self.score >= 3 {
            
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.backgroundColor = .selectionColor
            self.nextButton.setTitleColor(.mainColor, for: .normal)
        } else {
            
            self.nextButton.isUserInteractionEnabled = false
            self.nextButton.backgroundColor = .hatDisabled
            self.nextButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK: - Text Field delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.addFontChangingBasedOnText(range: range, string: string)
        
        self.score = Int(DBZxcvbn().passwordStrength(textField.text!).score)
        self.refreshPasswordIndicators()
        self.updateButtonState()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.nextButtonAction(self)
        
        return true
    }
    
    // MARK: - Password manager
    
    @objc
    private func generateNewPasswordFromPasswordManager(_ sender: Any) {
        
        let userDomain: String = self.purchaseModel.hatName
        
        PasswordExtensionManager.generateNewPassword(
            for: userDomain,
            viewController: self,
            sender: self.passWordTextField.rightView,
            completion: generatedNewPassword,
            failure: failedGettingNewPassword)
    }
    
    private func generatedNewPassword(password: String?) {
        
        self.passWordTextField.text = password
        _ = self.textField(self.passWordTextField, shouldChangeCharactersIn: NSRange(0...password!.count), replacementString: password!)
    }
    
    private func failedGettingNewPassword(error: Error?) {
        
    }

}
