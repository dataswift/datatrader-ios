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

internal class CustomAlertController: BaseViewController {

    // MARK: - Variables

    /// A function to execute on tapping the button on the alert view controller
    var completion: (() -> Void)?
    private let x: CGFloat = CGFloat(10)
    private var y: CGFloat = CGFloat(10)
    private var width: CGFloat = CGFloat(0)
    private var height: CGFloat = CGFloat(0)
    var alertTitle: String = ""
    var alertMessage: String = ""
    var buttonTitle: String = ""
    var cancelButtonTitle: String = ""
    
    var backgroundView: UIView?
    
    // MARK: - IBOutlets

    /// An IBOutlet for holding a reference to the title UILabel of the alert
    @IBOutlet private weak var titleLabel: UILabel!
    /// An IBOutlet for holding a reference to the message UILabel of the alert
    @IBOutlet private weak var messageLabel: UILabel!
    /// An IBOutlet for holding a reference to the button of the alert
    @IBOutlet private weak var button: UIButton!
    /// An IBOutlet for holding a reference to the alert UIView
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - IBActions

    /**
     Dismisses the alert controller
     
     - parameter sender: The object that called this function
     */
    @IBAction func buttonAction(_ sender: Any) {

        self.backgroundView?.removeFromSuperview()
        self.dismiss(animated: true, completion: { [weak self] in
            
            self?.completion?()
        })
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.backgroundView?.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Controller methods

    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.alertView.layer.masksToBounds = true
        self.alertView.layer.cornerRadius = 5
        self.baseView.addShadow(color: .black, shadowRadius: 5, shadowOpacity: 0.7, width: 3, height: 0)
        self.setUpButtonWith(self.buttonTitle)
        self.setTitleLabel(self.alertTitle)
        self.setMessageLabel(self.alertMessage)
        self.setUpCancelButtonWith(self.cancelButtonTitle)
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self.titleLabel.sizeToFit()
        self.messageLabel.sizeToFit()
        let titleHeight = self.titleLabel.frame.height
        let messageHeight = self.messageLabel.frame.height
        
        let height: CGFloat
        if self.cancelButton != nil {

            height = titleHeight + messageHeight + 60 + 175
        } else {

            height = titleHeight + messageHeight + 159
        }
        
        let midY = UIScreen.main.bounds.midY
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.2,
            options: .curveEaseInOut,
            animations: { [weak self] in
            
                guard let weakSelf = self else {
                    
                    return
                }
                weakSelf.view.frame = CGRect(x: 0, y: midY - (height / 2), width: weakSelf.view.frame.width, height: height)
            },
            completion: nil)

        self.alertView.layer.cornerRadius = 5
    }
    
    // MARK: - Show alert

    /**
     Shows a custom alert view contoller
     
     - parameter title: The title of the alert
     - parameter message: The message of the alert
     - parameter actionTitle: The string to show in the button
     - parameter action: An action to execute on tap of the button
     */
    func showAlert(title: String, message: String, actionTitle: String, cancelButtonTitle: String = "", action: (() -> Void)?) {

        self.setTitleLabel(title)
        self.setMessageLabel(message)
        self.setUpButtonWith(actionTitle)
        self.setUpCancelButtonWith(cancelButtonTitle)
        self.completion = action
    }
    
    func setTitleLabel(_ title: String) {
        
        if self.titleLabel != nil {
            
            self.titleLabel.text = title
        }
    }
    
    func setMessageLabel(_ message: String) {
        
        if self.messageLabel != nil {
            
            self.messageLabel.text = message
        }
    }
    
    func setUpButtonWith(_ actionTitle: String) {
        
        if self.button != nil {
            
            self.button.layer.cornerRadius = 5
            self.button.setTitle(actionTitle, for: .normal)
        }
    }
    
    func setUpCancelButtonWith(_ actionTitle: String) {
        
        if self.cancelButton != nil {
            
            self.cancelButton.setTitle(actionTitle, for: .normal)
        }
    }

}
