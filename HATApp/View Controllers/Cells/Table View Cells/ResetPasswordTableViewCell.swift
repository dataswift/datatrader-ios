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

class ResetPasswordTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var firstScoreView: UIView!
    @IBOutlet private weak var secondScoreView: UIView!
    @IBOutlet private weak var thirdScoreView: UIView!
    @IBOutlet private weak var fourthScoreView: UIView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setDelegate(delegate: UITextFieldDelegate?) {
        
        self.textField.delegate = delegate
    }
    
    func setTagInTextField(_ tag: Int) {
        
        self.textField.tag = tag
    }
    
    func makeTextFieldFirstResponder() {
        
        self.textField.becomeFirstResponder()
    }
    
    func getTextFromTextField() -> String {
        
        return self.textField.text ?? ""
    }
    
    func getTextField() -> UITextField! {
        
        return self.textField
    }
    
    class func setUpCell(cell: ResetPasswordTableViewCell, placeholderText: String, existingPassword: String? = nil, newPassword: String? = nil, score: Int, tag: Int = 0, delegate: UITextFieldDelegate?, viewController: CreatePasswordTableViewController, state: PasswordChangeState? = nil) -> ResetPasswordTableViewCell {
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.mainView.layer.borderWidth = 0
        cell.mainView.layer.borderColor = UIColor.clear.cgColor
        cell.textField.placeholder = placeholderText
        cell.setTagInTextField(tag)
        cell.setDelegate(delegate: delegate)
        
        if tag == 1 {
            
            if existingPassword != nil {
                
                cell.textField.text = existingPassword
            }
            PasswordExtensionManager.addPasswordExtensionButtonToTextFieldIfPossible(
                textField: cell.textField,
                viewController: viewController,
                target: #selector(viewController.getExistingPasswordFromPasswordManager(_:)))
        } else if tag == 10 {
            
            if newPassword != nil {
                
                cell.textField.text = newPassword
            }
            cell.refreshPasswordIndicators(score: score)
            
            PasswordExtensionManager.addPasswordExtensionButtonToTextFieldIfPossible(
                textField: cell.textField,
                viewController: viewController,
                target: #selector(viewController.getNewPasswordFromPasswordManager(_:)))
        } else if tag == 11 {
            
            if newPassword != nil {
                
                cell.textField.text = newPassword
            }
        }
        
        guard let state = state else { return cell }
        
        switch state {
        case .existingPasswordWrong:
            
            if tag == 1 {
                
                cell.mainView.layer.borderWidth = 1
                cell.mainView.layer.borderColor = UIColor.hatPasswordRed.cgColor
            }
        case .passwordsDoNotMatch:
            
            if tag == 10 || tag == 11 {
                
                cell.mainView.layer.borderWidth = 1
                cell.mainView.layer.borderColor = UIColor.hatPasswordRed.cgColor
            }
        }
        
        return cell
    }
    
    func refreshPasswordIndicators(score: Int) {
        
        if score >= 0 && score <= 1 {
            
            self.firstScoreView.backgroundColor = .hatPasswordRed
            self.secondScoreView.backgroundColor = .hatPasswordGray
            self.thirdScoreView.backgroundColor = .hatPasswordGray
            self.fourthScoreView.backgroundColor = .hatPasswordGray
            self.scoreLabel.text = "Poor"
            self.scoreLabel.textColor = .hatPasswordRed
        }
        if score >= 2 {
            
            self.firstScoreView.backgroundColor = .hatPasswordOrange
            self.secondScoreView.backgroundColor = .hatPasswordOrange
            self.thirdScoreView.backgroundColor = .hatPasswordGray
            self.fourthScoreView.backgroundColor = .hatPasswordGray
            self.scoreLabel.text = "Average"
            self.scoreLabel.textColor = .hatPasswordOrange
        }
        if score >= 3 {
            
            self.firstScoreView.backgroundColor = .hatPasswordGreen
            self.secondScoreView.backgroundColor = .hatPasswordGreen
            self.thirdScoreView.backgroundColor = .hatPasswordGreen
            self.fourthScoreView.backgroundColor = .hatPasswordGray
            self.scoreLabel.text = "Strong"
            self.scoreLabel.textColor = .hatPasswordGreen
        }
        if score >= 4 {
            
            self.firstScoreView.backgroundColor = .hatPasswordGreen
            self.secondScoreView.backgroundColor = .hatPasswordGreen
            self.thirdScoreView.backgroundColor = .hatPasswordGreen
            self.fourthScoreView.backgroundColor = .hatPasswordGreen
            self.scoreLabel.text = "Very Strong"
            self.scoreLabel.textColor = .hatPasswordGreen
        }
    }
}
