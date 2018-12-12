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

internal class CreateAccountViewController: HATCreationUIViewController {
    
    // MARK: - IBOutlet

    /// An IBOutlet to controll the first name textField
    @IBOutlet private weak var firstNameTextField: UITextField!
    /// An IBOutlet to controll the last name textField
    @IBOutlet private weak var lastNameTextField: UITextField!
    /// An IBOutlet to controll the email textField
    @IBOutlet private weak var emailTextField: UITextField!
    /// An IBOutlet to controll the next button
    @IBOutlet private weak var nextButton: UIButton!
    
    // MARK: - IBActions
    
    /**
     Called when next button is pressed. Check the fields for error and checks with hat the email field. If ok continues to the next screen
     
     - parameter sender: The object that called the function
     */
    @IBAction func nextButtonAction(_ sender: Any) {
        
        self.checkFields()
    }
    
    // MARK: - View controller delegate functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // UI changes to the firstNameTextField
        self.firstNameTextField.setLeftPaddingPoints(20)
        self.firstNameTextField.layer.borderWidth = 1
        self.firstNameTextField.layer.borderColor = UIColor.hatDisabled.cgColor
        
        // UI changes to the lastNameTextField
        self.lastNameTextField.setLeftPaddingPoints(20)
        
        // UI changes to the emailTextField
        self.emailTextField.setLeftPaddingPoints(20)
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.borderColor = UIColor.hatDisabled.cgColor
        
        // UI changes to the nextButton
        self.nextButton.layer.cornerRadius = 5
        
        // set solid color navigation bar
        self.setNavigationBarColorToDarkBlue()
        
        // set textField delegate to self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        
        // add a target if user is editing the text field
        self.emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.setNavigationBarColorToDarkBlue()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Check email

    /**
     Checks if the email passed as parameter is a valid email address
     
     - parameter email: The email to check if it's a valid email address
     
     - returns: A bool value indicating if this is a valid email or not
     */
    private func isValidEmail(_ email: String?) -> Bool {
        
        guard let email: String = email?.trimString() else { return false }
        
        let emailRegEx: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
        
        let emailTest: NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // MARK: - Check fields
    
    /**
     Checks the fields if ok, before sending a request to the hat. If something wrong it shows messages
     */
    private func checkFields() {
        
        if self.firstNameTextField.text != "" && self.lastNameTextField.text != "" {
            
            let email: String = self.emailTextField.text!.trimString()

            if self.isValidEmail(email) {
                
                self.checkEmail()
            } else {
                
                self.createDressyClassicOKAlertWith(alertMessage: "Please check the email field again", alertTitle: "The email is not valid!", okTitle: "Ok", proceedCompletion: nil)
            }
        } else {
            
            self.createDressyClassicOKAlertWith(alertMessage: "First or Last Name field is empty", alertTitle: "Error!", okTitle: "Ok", proceedCompletion: nil)
        }
    }
    
    // MARK: - Update state of button
    
    /**
     Updates the button color and if it's selectable or not, depenting in the values of the textFields
     */
    private func updateButtonState() {
        
        if self.firstNameTextField.text != "" && self.lastNameTextField.text != "" && isValidEmail(self.emailTextField.text) {
            
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.backgroundColor = .selectionColor
            self.nextButton.setTitleColor(.mainColor, for: .normal)
        } else {
            
            self.nextButton.isUserInteractionEnabled = false
            self.nextButton.backgroundColor = .hatDisabled
            self.nextButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK: - Check email with HAT
    
    /**
     Checks the email address with HAT
     */
    private func checkEmail() {
        
        let email: String = self.emailTextField.text!.trimString()
        self.emailTextField.text = email
        
        HATService.validateEmailAddress(email: email, cluster: cluster, succesfulCallBack: emailValid, failCallBack: emailInvalid)
    }
    
    /**
     Email is valid according to HAT and can be used for HAT creation
     
     - parameter message: The message returned
     - parameter newToken: The new token returned from hat, it will be nil since there is no token used until now
     */
    private func emailValid(message: String, newToken: String?) {
        
        let email: String = self.emailTextField.text!.trimString()
        
        purchaseModel.email = email
        purchaseModel.firstName = self.firstNameTextField.text!.trimString()
        purchaseModel.lastName = self.lastNameTextField.text!.trimString()
        purchaseModel.hatCluster = cluster
        purchaseModel.hatCountry = "United Kingdom"
        purchaseModel.membership.membershipType = "trial"
        purchaseModel.membership.plan = "sandbox"
        purchaseModel.applicationId = Auth.serviceName
        
        self.performSegue(withIdentifier: SeguesConstants.createPhataSegue, sender: self)
    }
    
    /**
     Something went wrong while checking the email address with HAT. Show error message
     
     - parameter error: An error occured while checking the email address with HAT
     */
    private func emailInvalid(error: JSONParsingError) {
        
        switch error {
        case .generalError(let message, _, _):
            
            self.createDressyClassicOKAlertWith(alertMessage: message, alertTitle: "Error!", okTitle: "Ok", proceedCompletion: nil)
        default:
            
            break
        }
    }
    
    // MARK: - Text field Delegate methods
    
    /**
     <#Function Details#>
     */
    @objc
    func textFieldDidChange() {
        
        self.updateButtonState()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.addFontChangingBasedOnText(range: range, string: string)
        
        self.updateButtonState()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            
            self.lastNameTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            
            self.emailTextField.becomeFirstResponder()
        } else {
            
            self.nextButtonAction(self)
        }
        
        return true
    }
}
