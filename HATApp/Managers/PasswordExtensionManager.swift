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

import PasswordExtension

// MARK: Struct

struct PasswordExtensionManager {
    
    // MARK: - Check availability

    /**
     Checks if the user has install a password manager
     
     - returns: True if user has installed a password manager app, else false
     */
    static func isExtensionAvailable() -> Bool {
        
        return PasswordExtension.shared.isAvailable()
    }
    
    // MARK: - Add password icon to the textField
    
    /**
     Adds the button to the textField if possible, user has to be on iOS 11 and newer
     
     - parameter textField: The textField to add the button to
     - parameter viewController: The view controller responsible to respond to the button
     - parameter target: The selector to call when the button is tapped
     - parameter offsetXPos: The offsetXPos of the button
     */
    static func addPasswordExtensionButtonToTextFieldIfPossible(textField: UITextField, viewController: UIViewController, target: Selector, offsetXPos: CGFloat = 0) {
        
        if #available(iOS 11.0, *), PasswordExtensionManager.isExtensionAvailable() {
            
            let passwordButton = UIButton(frame: CGRect(x: textField.frame.maxX - 40 + offsetXPos, y: 10, width: 30, height: 30))
            passwordButton.addTarget(viewController, action: target, for: .touchUpInside)
            passwordButton.setImage(UIImage(named: ImageNamesConstants.passwordManager), for: .normal)
            textField.rightView = passwordButton
            textField.rightViewMode = .always
        }
    }
    
    // MARK: - Search for login details
    
    /**
     Searches to the password manager app for the correct login
     
     - parameter viewController: The viewController that has the textField
     - parameter sender: The sender that called the method
     - parameter completion: A function to execute upon completion
     - parameter failed: A function to exevute upon failure
     */
    static func findLoginDetails(viewController: UIViewController, sender: Any? = nil, completion: @escaping (String, String) -> Void, failed: @escaping (Error?) -> Void) {
        
        let username: String = {
            
            if AppStatusManager.isAppBeta() {
                
                return "hubat.net"
            }
            
            return "hubofallthings.net"
        }()
        
        // Using the provided classes
        PasswordExtension.shared.findLoginDetails(for: username, viewController: viewController, sender: sender) { (loginDetails, error) in
            
            if let loginDetails = loginDetails {
                
                completion(loginDetails.username, loginDetails.password ?? "")
            } else if let error = error {
                
                switch error.code {
                    
                case .extensionCancelledByUser:
                    
                    print(error.localizedDescription)
                default:
                    
                    failed(error)
                    print("Error: \(error)")
                }
            }
        }
    }
    
    // MARK: - Save login details
    
    /**
     Adds the credentials to the password manager app
     
     - parameter cluster: The cluster of the user (hubat. hubofallthings etc)
     - parameter username: The username of the user
     - parameter password: The password the user selected
     - parameter viewController: The view controller that has the textField
     - parameter completion: A function to execute upon completion
     - parameter failed: A function to execute upon failure
     */
    static func addLoginToPasswordManager(cluster: String, username: String, password: String, viewController: UIViewController, completion: @escaping (Bool) -> Void, failed: @escaping (Error?) -> Void) {
        
        let login: PELoginDetails = PELoginDetails(urlString: cluster, username: username, password: password)
        let options: PEGeneratedPasswordOptions? = nil
        
        PasswordExtension.shared.storeLogin(
            for: login,
            generatedPasswordOptions: options,
            viewController: viewController,
            sender: nil,
            completion: { (login, error) in
            
                if error == nil {
                    
                    completion(true)
                } else {
                    
                    failed(error)
                }
            }
        )
    }
    
    // MARK: - Generate new password
    
    /**
     Generates new password
     
     - parameter username: The username of the user
     - parameter viewController: The view controller that has the textField
     - parameter sender: The object that called this function
     - parameter completion: A function to execute upon completion
     - parameter failure: A funtion to execute upon failure
     */
    static func generateNewPassword(for username: String, viewController: UIViewController, sender: Any? = nil, completion: @escaping(String?) -> Void, failure: @escaping (Error?) -> Void) {
        
        let url: String = {
            
            if AppStatusManager.isAppBeta() {
                
                return "hubat.net"
            }
            
            return "hubofallthings.net"
        }()
        
        let loginDetails = PELoginDetails(urlString: url, username: username)
        let passwordOptions = PEGeneratedPasswordOptions(minLength: 15, maxLength: 50)
        
        PasswordExtension.shared.changePasswordForLogin(
            for: loginDetails,
            generatedPasswordOptions: passwordOptions,
            viewController: viewController,
            sender: sender,
            completion: { details, error in
                
                if error != nil {
                    
                    failure(error)
                } else {
                    
                    completion(details?.password)
                }
        })
    }
    
}
