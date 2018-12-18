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
import zxcvbn_ios

// MARK: Class

internal class CreatePasswordTableViewController: HATUIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: - Variables
    
    /// The sections of the table view
    private let sections: [[String]] = [[""], ["", ""]]
    /// The headers of the table view
    private let headers: [String] = ["Existing Password", "New Password"]
    /// The password strength score
    private var score: Int = 0
    private let zxcvbnTextFieldTag: Int = 10
    private var expanded: Bool = false
    private var existingPassword: String?
    private var newPassword: String?
    private var passwordState: PasswordChangeState?
    private let footer: String = """
        Your data is precious – keep it safe with a password that is Strong or Very Strong on this scale.
        
        Example: unicorn-coffee-taco
        
        A combination of three random words is one of the strongest passwords, and the kind we recommend. Read on how we determine password strength policy (and why it's so important) on our developers' pages.
        """
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var innerErrorView: UIView!
    @IBOutlet private weak var errorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var errorViewLabel: UILabel!
    
    // MARK: - IBActions
    
    /**
     Sends the profile data to hat
     
     - parameter sender: The object that calls this function
     */
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if self.score > 2 {
            
            let oldPasswordCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ResetPasswordTableViewCell
            let newPasswordCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ResetPasswordTableViewCell
            let reTypedNewPasswordCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? ResetPasswordTableViewCell
            
            let oldPassword = oldPasswordCell?.getTextFromTextField()
            let newPassword1 = newPasswordCell?.getTextFromTextField()
            let newPassword2 = reTypedNewPasswordCell?.getTextFromTextField()
            
            guard oldPassword != nil && oldPassword != "" else {
                
                self.passwordState = PasswordChangeState.existingPasswordWrong
                self.errorViewHeightConstraint.constant = 70
                self.errorView.isHidden = false
                self.errorViewLabel.text = "Existing password field empty"
                self.animateLayoutChanges()
                
                self.tableView.reloadData()
                return
            }
            
            if newPassword1 == newPassword2 {
                
                FeedbackManager.vibrateWithHapticIntensity(type: .light)
                
                HATAccountService.changePassword(
                    userDomain: self.userDomain,
                    userToken: self.userToken,
                    oldPassword: oldPassword!,
                    newPassword: newPassword1!,
                    successCallback: passwordChangedResult,
                    failCallback: passwordErrorResult)
            } else {
                
                self.passwordState = PasswordChangeState.passwordsDoNotMatch
                
                self.errorViewHeightConstraint.constant = 70
                self.errorView.isHidden = false
                self.errorViewLabel.text = "Passwords don't match"
                self.animateLayoutChanges()
                
                self.tableView.reloadData()
            }
        } else {
            
            self.passwordState = PasswordChangeState.existingPasswordWrong
            
            self.errorViewHeightConstraint.constant = 70
            self.errorView.isHidden = false
            self.errorViewLabel.text = "Password too weak"
            self.animateLayoutChanges()
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Update profile callbacks
    
    func passwordChangedResult(message: String, renewedToken: String?) {
        
        self.createDressyClassicOKAlertWith(alertMessage: message, alertTitle: "Password change requested", okTitle: "OK", proceedCompletion: {
            
            if message == "Password changed" {
                
                _ = self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func passwordErrorResult(error: HATError) {
        
        switch error as HATError {
            
        case .generalError(_, let statusCode, _):
            
            if statusCode == 404 {
                
                self.errorViewHeightConstraint.constant = 70
                self.errorView.isHidden = false
                self.errorViewLabel.text = "Existing password is wrong"
                self.passwordState = PasswordChangeState.existingPasswordWrong
                self.animateLayoutChanges()
            } else {
                
                self.errorViewHeightConstraint.constant = 70
                self.errorView.isHidden = false
                self.errorViewLabel.text = "Unknown error"
                self.animateLayoutChanges()
            }
        default:
            
            self.errorViewHeightConstraint.constant = 70
            self.errorView.isHidden = false
            self.errorViewLabel.text = "Unknown error"
            self.animateLayoutChanges()
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.saveButton.layer.cornerRadius = 5
        
        self.innerErrorView.addBorder(width: 1, color: .hatPasswordRed)
        self.errorViewHeightConstraint.constant = 0
        self.errorView.isHidden = true
        
        self.setNavigationBarColorToDarkBlue()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.resetPasswordCell, for: indexPath) as? ResetPasswordTableViewCell else
        { return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.resetPasswordCell, for: indexPath)}
        
        let placeholderText: String
        let textFieldTag: Int
        if indexPath.section == 0 {
            
            textFieldTag = 1
            placeholderText = "Type existing password"
        } else {
            
            if indexPath.row == 0 {
                
                textFieldTag = zxcvbnTextFieldTag
                placeholderText = "Type new password"
            } else {
                
                textFieldTag = 11
                placeholderText = "Re-type new password"
            }
        }
        
        return ResetPasswordTableViewCell.setUpCell(
            cell: cell,
            placeholderText: placeholderText,
            existingPassword: self.existingPassword,
            newPassword: self.newPassword,
            score: self.score,
            tag: textFieldTag,
            delegate: self,
            viewController: self,
            state: self.passwordState)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if expanded && (indexPath.section == 1 && indexPath.row == 0) {
            
            return 100
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.resetPasswordHeaderCell) as? HATHeaderTableViewCell else { return nil }
        
        cell.setHeader(text: self.headers[section])
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        guard section == 1,
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.resetPasswordHeaderCell) as? HATHeaderTableViewCell else { return 0 }
        
        cell.setHeader(text: footer)
        
        var size = cell.bounds.size
        size.width = size.width - 16
        
        return cell.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow).height + 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard section == 1,
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.resetPasswordHeaderCell) as? HATHeaderTableViewCell else { return nil }
        
        cell.setHeader(text: footer)
        
        return cell.contentView
    }
    
    // MARK: - Text field methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text != "" || ( textField.text == "" && string != "") {
            
            textField.font = UIFont.oswaldLight(ofSize: 14)
        } else {
            
            textField.font = UIFont.oswaldLight(ofSize: 14)
        }
        
        if textField.tag == zxcvbnTextFieldTag {
            
            self.score = Int(DBZxcvbn().passwordStrength(textField.text!).score)
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ResetPasswordTableViewCell
            cell?.refreshPasswordIndicators(score: self.score)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == zxcvbnTextFieldTag {
            
            self.expanded = true
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
        self.activeField = textField
    }
    
    // MARK: - Password manager related
    
    @objc
    func getExistingPasswordFromPasswordManager(_ sender: Any) {
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ResetPasswordTableViewCell
        cell?.makeTextFieldFirstResponder()
        
        PasswordExtensionManager.findLoginDetails(
            viewController: self,
            sender: cell?.getTextField().rightView,
            completion: credentialsReceivedFromPasswordManager,
            failed: gettingCredentialsFromPasswordManagerFailed)
    }
    
    @objc
    func getNewPasswordFromPasswordManager(_ sender: Any) {
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ResetPasswordTableViewCell
        cell?.makeTextFieldFirstResponder()
        
        PasswordExtensionManager.generateNewPassword(
            for: self.userDomain,
            viewController: self,
            sender: cell?.getTextField().rightView,
            completion: generatedNewPassword,
            failure: gettingCredentialsFromPasswordManagerFailed)
    }
    
    private func generatedNewPassword(password: String?) {
        
        self.newPassword = password
        self.score = Int(DBZxcvbn().passwordStrength(password).score)
        self.tableView.reloadData()
    }
    
    private func credentialsReceivedFromPasswordManager(username: String, password: String) {
        
        self.existingPassword = password
        self.tableView.reloadData()
    }
    
    private func gettingCredentialsFromPasswordManagerFailed(error: Error?) {
        
    }
    
    // MARK: - Scroll View methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.hatUIViewScrollView = scrollView
    }
    
}
