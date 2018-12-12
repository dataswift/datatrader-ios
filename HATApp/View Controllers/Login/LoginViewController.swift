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

internal class LoginViewController: BaseViewController, UserCredentialsProtocol {
    
    // MARK: - IBAction
    
    /**
     Sends user to the next view controller
     
     - parameter sender: The object that called this function
     */
    @IBAction func logInButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: SeguesConstants.logInToUserDomainSegue, sender: self)
    }
    
    /**
     Sends user to the view controller responsible for creating a hat
     
     - parameter sender: The object that called this function
     */
    @IBAction func createAccountButtonAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: SeguesConstants.createHatSegue, sender: self)
    }
    
    // MARK: - View Controller functions

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // hide navigation bar
        self.navigationController?.navigationBar.isHidden = true
        
        // hide back button
        let item = UIBarButtonItem(title: " ", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        self.checkIfAppNeedsUpdating()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Check for location permissions
    
    /**
     Checks if the app has asked for location improvements if no show the location request onboarding screen
     */
    private func checkIfLocationPermissionsShownBefore() {
        
        let screenShown = KeychainManager.getKeychainValue(key: KeychainConstants.locationScreenShown)
        let newUser = KeychainManager.getKeychainValue(key: KeychainConstants.newUser)
        
        if screenShown == KeychainConstants.Values.setTrue || screenShown == KeychainConstants.Values.setFalse || newUser == KeychainConstants.Values.setFalse {
            
            self.checkIfAppNeedsUpdating()
        } else {
            
            guard let vc: EnableLocationsViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerNames.askForLocations) as? EnableLocationsViewController else {
                
                self.checkIfAppNeedsUpdating()
                return
            }
            
            vc.modalPresentationStyle = .fullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - Check if user is logged in
    
    /**
     Checks if the user is logged in
     */
    private func checkIfUserIsLoggedIn() {
        
        func tokenValid(newToken: String?) {
            
            if let firstView = SideMenu.getAvailableOptions().first?.first?.value {
                
                self.navigateToViewControllerWith(name: firstView)
            }
        }
        
        guard let isUserLoggedIn: String = KeychainManager.getKeychainValue(key: KeychainConstants.logedIn) else {
            
            LoggerManager.logCustomError(error: AuthenticationError.valueNotFound, info: ["isUserLoggedIn": ""])
            return
        }
        
        if isUserLoggedIn == KeychainConstants.Values.setTrue {
            
            HATLoginService.checkIfTokenExpired(token: userToken, expiredCallBack: {}, tokenValidCallBack: tokenValid, errorCallBack: nil)
        } else {
            
            LoggerManager.logCustomError(error: AuthenticationError.valueNotFound, info: ["isUserLoggedIn": isUserLoggedIn])
        }
    }
    
    // MARK: - Check if app needs updating
    
    private func checkIfAppNeedsUpdating() {
        
        if NetworkManager().state == .online {
            
            HATExternalAppsService.getAppInfo(
                userToken: self.userToken,
                userDomain: self.userDomain,
                applicationId: Auth.serviceName,
                completion: gotAppInfo,
                failCallBack: { [weak self] _ in
                    
                    self?.checkIfUserIsLoggedIn()
            })
        } else {
            
            self.checkIfUserIsLoggedIn()
        }
    }
    
    private func gotAppInfo(application: HATApplicationObject, newUserToken: String?) {
        
        if application.needsUpdating ?? false {
            
            KeychainManager.setKeychainValue(key: KeychainConstants.logedIn, value: KeychainConstants.Values.setFalse)
        }
        
        self.checkIfUserIsLoggedIn()
    }

}
