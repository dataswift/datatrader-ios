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
import SafariServices

// MARK: Class

internal class EnterUserDomainViewController: HATUIViewController, UITextFieldDelegate, UserSelectedClusterDelegate {
    
    // MARK: - Protocol function
    
    func userSelectedCluster(_ cluster: String) {
        
        if self.hatNameTextField.text!.contains(".") {
            
            let tempArray = self.hatNameTextField.text?.split(separator: ".")
            let hatName: String = String(describing: tempArray![0])
            self.hatNameLabel.text = hatName
            self.hatNameTextField.text = hatName
        }
        self.hatClusterName.text = cluster
        
        self.selectedHATClusterLabel.text = cluster

        self.selectedHATClusterLabel.font = UIFont.openSansSemibold(ofSize: 14)
        self.selectedHATClusterLabel.textColor = .mainColor
    }
    
    // MARK: - IBOutlets

    /// An IBOutlet for holding a reference to the textfield that user enters the hat address
    @IBOutlet private weak var hatNameTextField: UITextField!
    /// An IBOutlet for holding a reference to the scrollView
    @IBOutlet private weak var scrollView: UIScrollView!
    /// An IBOutlet for holding a reference to the hatLogo UIImageView
    @IBOutlet private weak var hatLogoImageView: UIImageView!
    /// An IBOutlet for holding a reference to the hatName Label
    @IBOutlet private weak var hatNameLabel: UILabel!
    /// An IBOutlet for holding a reference to the hatClusterName label
    @IBOutlet private weak var hatClusterName: UILabel!
    /// An IBOutlet for holding a reference to the selectedHATCluster Label
    @IBOutlet private weak var selectedHATClusterLabel: UILabel!
    /// An IBOutlet for holding a reference to the arrowIndicator UIImageView
    @IBOutlet private weak var arrowIndicatorImageView: UIImageView!
    /// An IBOutlet for holding a reference to the hatCluster UIView
    @IBOutlet private weak var hatClusterView: UIView!
    /// An IBOutlet for holding a reference to the hatName UIView
    @IBOutlet private weak var hatNameView: UIView!
    /// An IBOutlet for holding a reference to the next Button
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var errorViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions

    /**
     Logs the user in their hat

     - parameter sender: The object that called this function
     */
    @IBAction func loginButtonAction(_ sender: Any) {

        func failed(error: String) {

            self.createDressyClassicOKAlertWith(
                alertMessage: "Please check your personal hat address again",
                alertTitle: "Wrong domain!",
                okTitle: "OK",
                proceedCompletion: {})
        }
        
        guard self.hatNameTextField.text != "" else { return }

        let overrideDomainCheck = self.hatNameTextField.text!.contains(".")
        let hatAddress: String = "\(self.hatNameLabel.text!)\(self.hatClusterName.text!)"
        if hatAddress != "" {

            func success(publicKey: String) {
                
                let domains = Domains.getAvailableDomains()
                if let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? String {
                    
                    if overrideDomainCheck {
                        
                        self.authoriseUser(hatDomain: self.hatNameTextField.text!)
                    } else {
                        
                        if config == "Beta" && !(hatAddress.hasSuffix(".hubat.net") || hatAddress.hasSuffix(".hat.direct")) {
                            
                            self.createDressyClassicOKAlertWith(
                                alertMessage: "Please use testing HUBAT account",
                                alertTitle: "This is a testing version of the app!",
                                okTitle: "OK",
                                proceedCompletion: {})
                        } else {
                            
                            FeedbackManager.vibrateWithHapticIntensity(type: .light)
                            KeychainManager.setKeychainValue(key: KeychainConstants.logedIn, value: KeychainConstants.Values.setFalse)
                            
                            HATLoginService.formatAndVerifyDomain(
                                userHATDomain: hatAddress,
                                verifiedDomains: domains,
                                successfulVerification: self.authoriseUser,
                                failedVerification: failed)
                        }
                    }
                }
            }
            
            func showError(error: HATError) {
                
                self.errorView.isHidden = false
                self.errorViewHeightConstraint.constant = 44
                self.animateLayoutChanges()
            }
            
            HATLoginService.getPublicKey(
                userDomain: hatAddress,
                completion: success,
                failed: showError)
        } else {

            // show something wrong alert
            self.createDressyClassicOKAlertWith(
                alertMessage: "Please input your HAT domain",
                alertTitle: "HAT domain is empty!",
                okTitle: "OK",
                proceedCompletion: {})
        }
    }
    
    @objc
    private func passwordManagerButton(_ sender: Any) {
        
        PasswordExtensionManager.findLoginDetails(viewController: self, sender: self.hatNameTextField.rightView, completion: credentialsReceived, failed: errorGettingCredentials)
    }
    
    private func credentialsReceived(username: String, userPassword: String) {
        
        let cluster: String = {
            
            if AppStatusManager.isAppBeta() {
                
                return "hubat.net"
            }
        
            return "hubofallthings.net"
        }()
        
        let tempUsername: String
        if !username.contains(".net") {
            
            tempUsername = "\(username).\(cluster)"
        } else {
            
            tempUsername = username
        }
        
        self.hatNameTextField.becomeFirstResponder()
        _ = self.textField(self.hatNameTextField, shouldChangeCharactersIn: NSRange(0...tempUsername.count), replacementString: tempUsername)
    }
    
    private func errorGettingCredentials(error: Error?) {
        
    }

    // MARK: - View Controller functions

    override func viewDidLoad() {

        self.overrideTokenCheck = true

        super.viewDidLoad()
        
        self.hatNameTextField.delegate = self
        
        self.setupView()
        
        // add notification observer for the login in
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.hatLoginAuth),
            name: NotificationNamesConstants.notificationHandlerName,
            object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.updateButtonState()
        
        PasswordExtensionManager.addPasswordExtensionButtonToTextFieldIfPossible(textField: self.hatNameTextField, viewController: self, target: #selector(self.passwordManagerButton(_:)))
    }
    
    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup View
    
    /**
     Sets up view
     */
    private func setupView() {
        
        self.keyboardManager.view = self.view
        self.keyboardManager.hatUIViewScrollView = self.scrollView
        self.keyboardManager.addKeyboardHandling()
        self.keyboardManager.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.isHidden = false

        self.setNavigationBarColorToDarkBlue()
        
        self.createToolBar()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userTappedSelectDomain))
        
        self.hatClusterView.isUserInteractionEnabled = true
        self.hatClusterView.addGestureRecognizer(tapGesture)
        
        self.hatNameView.addBorder(width: 1, color: .hatDisabled)
        self.hatClusterView.addBorder(width: 1, color: .hatDisabled)
        self.errorView.addBorder(width: 1, color: .hatPasswordRed)

        self.errorViewHeightConstraint.constant = 0
        self.errorView.isHidden = true
    }
    
    /**
     Responds to the cluster UIView and goes to the cluster selection UIView
     */
    @objc
    private func userTappedSelectDomain() {
        
        self.performSegue(withIdentifier: "selectDomainSegue", sender: self)
    }

    // MARK: - Create Toolbar
    
    /**
     Creates the toolbar to attach to the keyboard if we have a saved userDomain
     */
    private func createToolBar() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self, weakSelf.userDomain != "" else {
                
                return
            }
            
            // Create a button bar for the number pad
            let toolbar = UIToolbar()
            toolbar.frame = CGRect(x: 0, y: 0, width: weakSelf.view.frame.width, height: 35)
            
            // Setup the buttons to be put in the system.
            let autofillButton = UIBarButtonItem(
                title: weakSelf.userDomain,
                style: .done,
                target: weakSelf,
                action: #selector(weakSelf.autofillPHATA))
            
            autofillButton.setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont.openSansLight(ofSize: 18),
                NSAttributedString.Key.foregroundColor: UIColor.white],
                                                  for: .normal)
            toolbar.barTintColor = .mainColor
            toolbar.setItems([autofillButton], animated: true)
            
            weakSelf.hatNameTextField.inputAccessoryView = toolbar
            weakSelf.hatNameTextField.inputAccessoryView?.backgroundColor = .black
        }
    }
    
    // MARK: - Accesory Input View Method
    
    /**
     Fills the domain text field with the user's domain
     */
    @objc
    private func autofillPHATA() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self, weakSelf.userDomain != "" else {
                
                return
            }
            
            let substrings = weakSelf.userDomain.split(separator: ".")
            
            weakSelf.hatNameTextField.font = UIFont.openSansSemibold(ofSize: 14)
            weakSelf.hatNameTextField.text = String(describing: substrings[0])
            weakSelf.selectedHATClusterLabel.text = ".\(String(describing: substrings[1])).\(String(describing: substrings[2]))"
            weakSelf.selectedHATClusterLabel.textColor = .mainColor
            weakSelf.selectedHATClusterLabel.font = UIFont.openSansSemibold(ofSize: 14)

            weakSelf.hatNameLabel.text = weakSelf.hatNameTextField.text
            weakSelf.hatClusterName.text = weakSelf.selectedHATClusterLabel.text
            
            weakSelf.loginButtonAction(weakSelf)
        }
    }
    
    // MARK: - Authorisation functions

    /**
     Authorise user with the hat

     - parameter hatDomain: The phata address of the user
     */
    private func authoriseUser(hatDomain: String) {

        self.openInSafari(url: Auth.hatLoginURL(userDomain: hatDomain), animated: true, completion: nil)
    }

    /**
     The notification received from the login precedure.

     - parameter NSNotification: notification
     */
    @objc
    private func hatLoginAuth(notification: NSNotification) {

        // get the url form the auth callback
        guard let url: NSURL = notification.object as? NSURL else { return }
        
        // first of all, we close the safari vc
        self.dismissSafari(animated: true, completion: nil)

        func success(userDomain: String?, token: String?) {
            
            self.dismissPopUp()

            KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: token)
            KeychainManager.setKeychainValue(key: KeychainConstants.hatDomainKey, value: userDomain)
            
            if let firstView = SideMenu.getAvailableOptions().first?.first?.value {
                
                self.navigateToViewControllerWith(name: firstView)
            }
        }

        func failed(error: AuthenicationError) {

            self.dismissPopUp()
            
            self.createDressyClassicOKAlertWith(
                alertMessage: error.localizedDescription,
                alertTitle: "Login failed",
                okTitle: "OK",
                proceedCompletion: {})
        }
        
        HATLoginService.loginToHATAuthorization(
            applicationName: Auth.serviceName,
            url: url,
            success: success,
            failed: failed)
    }
    
    // MARK: - Text Field delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.activeField = textField
        self.hatUIViewScrollView = self.scrollView
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.addFontChangingBasedOnText(range: range, string: string)

        if (textField.text!.contains(".") && string != "") || string.contains(".") {
            
            let fullText = "\(textField.text!)\(string)"
            let tempArray = fullText.split(separator: ".")
            
            self.hatNameLabel.text = String(describing: tempArray[0])
            if tempArray.count == 2 {
                
                self.hatClusterName.text = "\(tempArray[1])"

            } else if tempArray.count > 2 {
                
                self.hatClusterName.text = ".\(tempArray[1]).\(tempArray[2])"
            } else {
                
                self.hatClusterName.text = ".yourhatdomain"
            }
            self.selectedHATClusterLabel.text = "Select HAT domain"
            self.selectedHATClusterLabel.textColor = .textFieldPlaceHolder
            
            if textField.text == "" {
                
                textField.text = self.hatNameLabel.text
                self.selectedHATClusterLabel.text = self.hatClusterName.text
                self.selectedHATClusterLabel.textColor = .mainColor
                self.selectedHATClusterLabel.font = UIFont.openSansSemibold(ofSize: 14)
            }
        } else {
            
            if range.length == self.hatNameLabel.text?.count ?? -1 || range.length == (self.hatNameLabel.text?.count ?? -1) + (self.hatClusterName.text?.count ?? -1)  {
                
                self.hatNameLabel.text = "yourhatname"
                self.hatClusterName.text = ".yourhatdomain"
            } else {
                
                self.hatNameLabel.text = "\(textField.text!)\(string)"
                
                if string == "" {
                    
                    if let tempString = textField.text?.dropLast() {
                        
                        self.hatNameLabel.text = String(tempString)
                    }
                }
            }
        }
        
        if self.hatNameLabel.text == "" {
            
            self.hatNameLabel.text = "yourhatname"
        }
        
        self.updateButtonState()
        self.animateLayoutChanges()
        
        return true
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.loginButtonAction(self)
        return true
    }
    
    // MARK: - Update next button state
    
    /**
     Updates the button color and if it's selectable or not, depenting from the password score
     */
    private func updateButtonState() {
        
        if self.hatNameLabel.text != "yourhatname" && self.hatClusterName.text != ".yourhatdomain" {
            
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.backgroundColor = .selectionColor
            self.nextButton.setTitleColor(.mainColor, for: .normal)
        } else {
            
            self.nextButton.isUserInteractionEnabled = false
            self.nextButton.backgroundColor = .hatDisabled
            self.nextButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARKL - Navigate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? SelectHATDomainTableViewController {
            
            vc.delegate = self
            vc.preselectedCluster = self.selectedHATClusterLabel.text
        }
    }
}
