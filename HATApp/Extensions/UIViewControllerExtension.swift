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

// MARK: UIViewController Extension

extension UIViewController {
    
    // MARK: - UIStoryboard
    
    /**
     Get Main storyboard reference
     
     - returns: UIStoryboard
     */
    class func getMainStoryboard() -> UIStoryboard {
        
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    // MARK: - Remove view controller
    
    /**
     Removes the view controller that called this function of the superview and parent view controller
     */
    func removeViewController() {
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    // MARK: - Add view controller
    
    /**
     Adds the view controller passed in the parameter
     
     - parameter viewController: The view controller to add as a child
     */
    func addViewController(_ viewController: UIViewController) {
        
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    // MARK: - Navigate to View Controller
    
    /**
     Navigates to the specified ViewController
     
     - parameter name: The restoration ID of the View controller
     */
    func navigateToViewControllerWith(name: String) {
        
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // get the next view controller
        let mainStoryboard: UIStoryboard = HATUIViewController.getMainStoryboard()
        let rootViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: name)
        rootViewController.modalPresentationStyle = .fullScreen
        
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = rootViewController
        newWindow.backgroundColor = .appBlackColor
        let oldWindow = appDelegate.window
        
        UIWindow.transition(with: appDelegate.window!, duration: 0, options: [.curveEaseIn, .transitionCrossDissolve], animations: {
            
            appDelegate.window = newWindow
            newWindow.makeKeyAndVisible()
        }, completion: { _ in
            
            oldWindow?.rootViewController?.dismiss(animated: false, completion: nil)
        })
    }
    
    /**
     Navigates to the specified ViewController
     
     - parameter name: The restoration ID of the View controller
     */
    func navigateToViewControllerWithoutRemovingSuperView(name: String) {
        
        // get the next view controller
        let mainStoryboard: UIStoryboard = HATUIViewController.getMainStoryboard()
        let vc: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: name)
        vc.modalPresentationCapturesStatusBarAppearance = true
        vc.modalPresentationStyle = .fullScreen

        // present the next view controller
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Change navigation bar color
    
    /**
     Sets tha bavigation bar color to black style
     */
    func setNavigationBarColorToDarkBlue(animated: Bool = true) {
        
        func completion() {
            
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.backgroundColor = .navigationBarColor
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.barTintColor = .navigationBarColor
        }
        
        if animated, let coordinator = self.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { context in
                
                completion()
            }, completion: nil)
        } else {
            
            completion()
        }
    }
    
    /**
     Sets tha bavigation bar color to black style
     */
    func setNavigationBarColorToSelectionBlue(animated: Bool = true) {
        
        func completion() {
            
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.backgroundColor = .selectionColor
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.barTintColor = .selectionColor
        }
        
        if animated, let coordinator = self.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { context in
                
                completion()
            }, completion: nil)
        } else {
            
            completion()
        }
    }
    
    /**
     Sets tha bavigation bar color to black style
     */
    func setNavigationBarColorToClear(animated: Bool = true) {
        
        func completion() {
            
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.navigationController?.navigationBar.barTintColor = .clear
        }
        
        if animated, let coordinator = self.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { context in
                
                completion()
            }, completion: nil)
        } else {
            
            completion()
        }
    }
    
    // MARK: - Format navigation bar
    
    /**
     Adds the app logo to the navigation bar as a title
     */
    func createNavigationBarView() {
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: 162, height: 35)
        // create the UIView
        let view: UIView = UIView(frame: frame)
        
        // get the image
        let image: UIImage? = UIImage(named: ImageNamesConstants.navigationBarLogo)
        let imageView: UIImageView = UIImageView(image: image!)
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        
        // add the image to the UIview
        view.addSubview(imageView)
        
        // add the UIView to the navigation bar
        self.navigationController?.navigationItem.titleView = view
        self.navigationItem.titleView = view
        self.navigationController?.navigationBar.tintColor = .gray
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    /**
     Sets tha desired title in the navigation bar
     
     - parameter title: An Optional String representing the navigation bar Title
     
     */
    func setTitle(title: String?) {
        
        let label: UILabel = UILabel()
        label.text = title
        label.font = .oswaldLight(ofSize: 14)
        label.textColor = .white
        self.navigationItem.titleView = label
    }
    
    // MARK: - Network activity indicator
    
    /**
     Starts network activity indicator
     */
    func startInternetActivityIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    /**
     Stops network activity indicator
     */
    func stopInternetActivityIndicator() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - Create Pop Ups
    
    /**
     Creates a classic OK alert with 1 button
     
     - parameter alertMessage: The message of the alert
     - parameter alertTitle: The title of the alert
     - parameter okTitle: The title of the button
     - parameter proceedCompletion: The method to execute when the ok button is pressed
     */
    func createDressyClassicOKAlertWith(alertMessage: String, alertTitle: String, okTitle: String, proceedCompletion: (() -> Void)?) {
        
        if let customAlert: CustomAlertController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerNames.customAlertViewControllerDressy) as? CustomAlertController {
            
            // add a gray view to darken the background
            let view: UIView = UIView(frame: self.view.frame)
            view.backgroundColor = .gray
            view.alpha = 0.4
            view.tag = 123
            self.navigationController?.view.addSubview(view)
            
            // set up custom alert
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.custom
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            customAlert.alertTitle = alertTitle
            customAlert.alertMessage = alertMessage
            customAlert.buttonTitle = okTitle
            customAlert.completion = {
                
                view.removeFromSuperview()
                proceedCompletion?()
            }
            
            FeedbackManager.vibrateWithHapticEvent(type: .warning)

            self.present(customAlert, animated: true, completion: nil)
        }
    }
    
    /**
     Creates a classic OK alert with 2 buttons
     
     - parameter alertMessage: The message of the alert
     - parameter alertTitle: The title of the alert
     - parameter okTitle: The title of the button
     - parameter cancelTitle: The title of the button
     - parameter proceedCompletion: The method to execute when the ok button is pressed
     */
    func createDressyClassicDialogueAlertWith(alertMessage: String, alertTitle: String, okTitle: String, cancelTitle: String, proceedCompletion: (() -> Void)?) {
        
        if let customAlert: CustomAlertController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerNames.customAlertViewControllerDressy2) as? CustomAlertController {
            
            // add a gray view to darken the background
            let view: UIView = UIView(frame: self.view.frame)
            view.backgroundColor = .gray
            view.alpha = 0.4
            view.tag = 123
            self.navigationController?.view.addSubview(view)
            
            // set up custom alert
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.custom
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.present(customAlert, animated: true, completion: nil)
            
            customAlert.alertTitle = alertTitle
            customAlert.alertMessage = alertMessage
            customAlert.buttonTitle = okTitle
            customAlert.cancelButtonTitle = "Cancel"
            customAlert.completion = proceedCompletion
            customAlert.backgroundView = view
            
            FeedbackManager.vibrateWithHapticEvent(type: .warning)

            customAlert.showAlert(title: alertTitle, message: alertMessage, actionTitle: okTitle, cancelButtonTitle: "Cancel", action: proceedCompletion)
        }
    }
    
    // MARK: - Get App version number
    
    /**
     Returns the app version number from the bundle
     
     - returns: The app version number from the bundle
     */
    func getAppVersion() -> String? {
        
        if let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            
            return version
        }
        
        return nil
    }
    
    // MARK: - Animate layout changes
    
    /**
     Animates any layout changes happened
     */
    func animateLayoutChanges() {
        
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                
                self?.view.layoutIfNeeded()
            }
        )
    }
}
