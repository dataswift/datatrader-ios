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
import MessageUI
import SafariServices

// MARK: - Class

/// A subclass of UIViewController encapsulating side menu, pop up and safari methods to easier handle a lot of common scenarios in the other view controllers
internal class HATUIViewController: BaseViewController, SideMenuDelegateProtocol, PresentableSideMenuProtocol, SafariDelegateProtocol, LoadingPopUpDelegateProtocol, UserCredentialsProtocol, GenericLoadingViewDelegate, SFSafariViewControllerDelegate {
    
    // MARK: - Protocol variables
    
    /// An optional SideMenuViewController holding a reference to side menu. Used to show/hide the sideMenuViewController
    var sideMenuViewController: SideMenuViewController? {
        
        didSet (newValue) {
            
            if newValue != nil {
                
                self.navigationController?.navigationBar.barStyle = .black
            } else {
                
                self.navigationController?.navigationBar.barStyle = .default
            }
        }
    }
    /// An optional LoadingScreenViewController to show pop ups
    var loadingPopUp: LoadingScreenViewController?
    /// An optional UploadingViewController pop up to show the progress of an upload
    var uploadingPopUp: UploadingViewController?
    /// An optional LoadingScreenViewController to show the loading screen
    var loadingView: LoadingViewController?
    /// An optional SFSafariViewController object for launching safari in cases such as login.
    var safariVC: SFSafariViewController?
    /// An optional UIScrollView to handle the scroll amonst the HATUIViewControllers
    var hatUIViewScrollView: UIScrollView?
    /// An optional UITextField to point out the currently active field in order for the keyboard scroll to know the best position
    var activeField: UITextField?
    /// A MailManagerViewController in order to be able to send emails
    var mail: MailManagerViewController = MailManagerViewController()
    /// A flag to override the token check on viewDidLoad
    var overrideTokenCheck: Bool = false
    
    // MARK: - Protocol Functions
    
    func showLoadingView(title: String, description: String?) {
        
        guard let popUp: LoadingViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerNames.loadingScreen) as? LoadingViewController,
            self.loadingView == nil else {
                
                return
        }
        
        let width = self.view.bounds.width - 60
        let height = width
        popUp.view.frame = CGRect(x: self.view.bounds.midX - (width / 2), y: self.view.bounds.minY + 50, width: width, height: height)
        self.loadingView = popUp
        self.view.addSubview(self.loadingView!.view)
        self.loadingView?.setMainTitle(title)
        self.loadingView?.setDescription(description)
    }
    
    func dismissLoadingView(completion: (() -> Void)?) {
        
        self.loadingView?.removeViewController()
        self.loadingView = nil
        completion?()
    }
    
    func showPopUp(message: String, buttonTitle: String?, buttonAction: (() -> Void)?, selfDissmising: Bool = false, fromY: CGFloat? = nil) {
        
        guard let popUp: LoadingScreenViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerNames.loadingView) as? LoadingScreenViewController,
            self.loadingPopUp == nil else {
            
            return
        }
        
        var fromY = fromY
        if fromY == nil {
            
            fromY = self.view.bounds.maxY
        }
        
        popUp.view.frame = CGRect(x: 0, y: self.view.bounds.maxY + 48, width: self.view.bounds.width, height: 48)
        self.loadingPopUp = popUp
        self.view.addSubview(self.loadingPopUp!.view)
        self.loadingPopUp?.roundCorners()
        self.loadingPopUp?.setMessage(message)
        self.loadingPopUp?.setButtonTitle(buttonTitle)
        self.loadingPopUp?.completionAction = buttonAction
        
        if buttonTitle == nil {
            
            self.loadingPopUp?.setButtonHidden(true)
        }
        
        // Auto hide if no completionAction was provided and the selfDissmising flag is true
        if self.loadingPopUp?.completionAction == nil && selfDissmising == true {
            
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { [weak self] _ in
                
                self?.dismissPopUp()
            })
        }
        
        // Animate the pop up
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                
                guard let weakSelf = self else {
                    
                    return
                }
                weakSelf.loadingPopUp?.view.frame = CGRect(x: 0, y: fromY! - 68, width: weakSelf.view.bounds.width, height: 48)
            },
            completion: nil)
    }
    
    func showUploadingPopUp() {
        
        guard let popUp: UploadingViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerNames.uploadingView) as? UploadingViewController else {
            
            return
        }
        
        popUp.view.frame = CGRect(x: 0, y: self.view.bounds.maxY + 80, width: self.view.bounds.width, height: 80)
        self.uploadingPopUp = popUp
        self.view.addSubview(self.uploadingPopUp!.view)
        
        // Animate the pop up
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                
                guard let weakSelf = self else {
                    
                    return
                }
                weakSelf.uploadingPopUp?.view.frame = CGRect(x: 0, y: weakSelf.view.bounds.maxY - 80, width: weakSelf.view.bounds.width, height: 80)
            },
            completion: nil)
    }
    
    /**
     Updates the uploadingPopUp with the new progress completion
     
     - parameter progress: The new progress to show
     */
    func updateUploadProgress(progress: Float) {
        
        self.uploadingPopUp?.updateProggress(progress: Double(progress))
        
        if progress >= 1 {
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
                
                self?.dismissUploadingPopUp()
            })
        }
    }
    
    /**
     Dismisses the pop up with animation
     
     - parameter completion: A function to execute after the pop up has been dismissed
     */
    @objc
    func dismissPopUp(completion: (() -> Void)? = nil) {
        
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                
                guard let weakSelf = self else {
                    
                    return
                }
                weakSelf.loadingPopUp?.view.frame = CGRect(x: 0, y: weakSelf.view.bounds.maxY + 68, width: weakSelf.view.bounds.width, height: 48)
            },
            completion: { [weak self] _ in
                
                self?.loadingPopUp?.removeViewController()
                self?.loadingPopUp = nil
                completion?()
            }
        )
    }
    
    /**
     Dismisses the uploading pop up with animation
     */
    @objc
    func dismissUploadingPopUp() {
        
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                
                guard let weakSelf = self else {
                    
                    return
                }
                weakSelf.uploadingPopUp?.view.frame = CGRect(x: 0, y: weakSelf.view.bounds.maxY + 60, width: weakSelf.view.bounds.width, height: 80)
            },
            completion: { [weak self] _ in
                
                self?.uploadingPopUp?.removeViewController()
                self?.uploadingPopUp = nil
            }
        )
    }
    
    open func dismissSideMenu(sender: UIViewController, dismissView: Bool) {
        
        self.navigationController?.navigationBar.barStyle = .black
        self.sideMenuViewController?.view.isHidden = true
        self.sideMenuViewController?.removeViewController()
        self.sideMenuViewController = nil
        
        if dismissView {
            
            self.dismiss(
                animated: true,
                completion: { [unowned self] in
                    
                    self.navigationController?.removeFromParent()
                    self.removeViewController()
                }
            )
        }
    }
    
    // MARK: - Variables
    
    /// The URL to be used from safari variable to connect to the internet
    var safariURL: URL?
    /// A boolean value to store if the keyboard is currently on screen or not
    private var isKeyboardShown: Bool = false
    /// A CGFloat value to store the keyboard size
    private var keyboardSize: CGFloat = 0
    // The keyboard Manager to handle the keyboard showing and hiding
    var keyboardManager = KeyboardManager()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.checkIfTokenExpired()
        
        CacheManager<HATProfileObject>.checkForUnsyncedImages(forKey: "profileImage", userToken: self.userToken, userDomain: self.userDomain, completion: { [weak self] fileID in
            
            // Try to upload it
            guard fileID != nil,
                let weakSelf = self else { return }
            
            if var profile: [HATProfileObject] = CacheManager<HATProfileObject>.retrieveObjects(fromCache: "profile", forKey: "profile") {
                
                let url = FileURL.convertURL(fileID: fileID!, userDomain: weakSelf.userDomain)
                profile[0].data.dateCreated = Int(Date().timeIntervalSince1970)
                profile[0].data.dateCreatedLocal = FormatterManager.formatDateToISO(date: Date())
                profile[0].data.photo.avatar = url
                
                CacheManager<HATProfileObject>.saveObjects(objects: profile, inCache: "profile", key: "profile")
                let hatObject = HATSyncObject<HATProfileDataObject>.init(url: "https://\(weakSelf.userDomain)/api/v2.6/data/rumpel/profile", object: profile[0].data, data: nil, dictionary: nil)
                CacheManager<HATProfileDataObject>.syncObjects(objects: [hatObject], key: "profile")
            }
            
            if var structure: [HATDictionary] = CacheManager<HATDictionary>.retrieveObjects(fromCache: "profile", forKey: "structure") {
                
                let indexPathString = "(0, 0)"
                structure[0].hatDictionary.updateValue("photo.avatar", forKey: indexPathString)
                
                HATProfileService.updateStructure(sharedFields: structure[0].hatDictionary, userDomain: weakSelf.userDomain, userToken: weakSelf.userToken)
            }
            
            CacheManager<HATProfileDataObject>.checkForUnsyncedObjects(forKey: "profile", userToken: weakSelf.userToken)
            CacheManager<HATProfileDataObject>.checkForUnsyncedObjects(forKey: "structure", userToken: weakSelf.userToken)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissDataPlugSafariView), name: NotificationNamesConstants.dataPlugMessage, object: nil)
    }
    
    // MARK: - Check token
    
    /**
     Check if token has expired, if yes go to login
     */
    func checkIfTokenExpired() {
        
        if !self.overrideTokenCheck {
            
            HATLoginService.checkIfTokenExpired(
                token: userToken,
                expiredCallBack: goToLogin,
                tokenValidCallBack: {_ in return},
                errorCallBack: { [weak self] _, _, _, _ in
                    
                    self?.goToLogin()
                }
            )
        }
    }
    
    /**
     Token has expired, log user out and jump to log in screen
     */
    func tokenExpiredLogOut() {
        
        HATLoginService.logOut(userDomain: self.userDomain, completion: { [weak self] in
            
            self?.goToLogin()
        })
    }
    
    // MARK: - Go to login
    
    /**
     Go to log in screen
     */
    private func goToLogin() {
        
        self.navigateToViewControllerWith(name: ViewControllerNames.loginView)
    }
    
    // MARK: - Safari related
    
    /**
     Dismiss safari view after enabling a plug
     */
    @objc
    private func dismissDataPlugSafariView() {
        
        self.safariVC?.dismissSafari(animated: true, completion: nil)
    }
    
    /**
     Dismisses safari when the login has been completed
     
     - parameter animated: Dismiss the view animated or not
     - parameter completion: An Optional function to execute upon completion
     */
    func dismissSafari(animated: Bool, completion: (() -> Void)?) {
        
        self.safariVC?.dismissSafari(animated: animated, completion: completion)
    }
    
    /**
     Opens safari for the specifed hat domain
     
     - parameter hat: The user's hat domain
     - parameter animated: Opens the view animated or not
     - parameter completion: An Optional function to execute upon completion
     */
    func openInSafari(url: String, animated: Bool, completion: (() -> Void)?) {
        
        self.safariVC = SFSafariViewController.openInSafari(url: url, on: self, animated: animated, completion: completion)
        self.safariVC?.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        NotificationCenter.default.post(name: NotificationNamesConstants.refreshAppStatus, object: nil)
    }
    
    // MARK: - Textfield methods
    
    /**
     Function executed when the return key is pressed in order to hide the keyboard
     
     - parameter textField: The textfield that confronts to this function
     
     - returns: Bool
     */
    @objc
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Custom Alerts
    
    /**
     Creates a classic alert with 2 buttons
     
     - parameter alertMessage: The message of the alert
     - parameter alertTitle: The title of the alert
     - parameter cancelTitle: The title of the cancel button
     - parameter proceedTitle: The title of the proceed button
     - parameter proceedCompletion: The method to execute when the proceed button is pressed
     - parameter cancelCompletion: The method to execute when the cancel button is pressed
     */
    func createClassicAlertWith(alertMessage: String, alertTitle: String, cancelTitle: String, proceedTitle: String, proceedCompletion: @escaping () -> Void, cancelCompletion: @escaping () -> Void) {
        
        //change font
        let attrTitleString: NSAttributedString = NSAttributedString(
            string: alertTitle,
            attributes: [NSAttributedString.Key.font: UIFont.oswaldLight(ofSize: 32)])
        let attrMessageString: NSAttributedString = NSAttributedString(
            string: alertMessage,
            attributes: [NSAttributedString.Key.font: UIFont.oswaldLight(ofSize: 32)])
        
        // create the alert
        let alert: UIAlertController = UIAlertController(
            title: attrTitleString.string,
            message: attrMessageString.string,
            preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(
            title: proceedTitle,
            style: .default,
            handler: { (_: UIAlertAction) in
                
                proceedCompletion()
            }
        ))
        alert.addAction(UIAlertAction(
            title: cancelTitle,
            style: .cancel,
            handler: { (_: UIAlertAction) in
                
                cancelCompletion()
            }
        ))
        
        // present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Swipe recogniser methods
    
    /**
     Adds swipe gesture recogniser to the view passed on as a parameter in order to show the sidemenu
     
     - parameter view: The view to add the swipe gesture recogniser to
     */
    func addSwipeRecogniserToShowSideMenu(view: UIView) {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(self.swipedOpenMenu))
        swipeGesture.direction = .right
        swipeGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeGesture)
    }
    
    /**
     Opens the side menu
     */
    @objc
    private func swipedOpenMenu() {
        
        sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)
    }
}
