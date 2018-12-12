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

internal class SideMenuViewController: HATUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    
    /// The table view of the view controller
    @IBOutlet private weak var tableView: UITableView!
    
    /// A UIView behind the side menu view controller to hide the main view controller
    @IBOutlet private weak var backgroundView: UIView!
    /// A UIView representing the side menu view
    @IBOutlet private weak var sideView: UIView!
    @IBOutlet private weak var aboutView: UIView!
    @IBOutlet private weak var closeMenuView: UIView!
    
    // MARK: - Variables
    
    /// The selected index of the view controller, set to 0 since the first view controller loads be default
    private var selectedIndex: Int = 0
    
    /// A delegate protocol to intercept the side menu calls
    weak var delegate: SideMenuDelegateProtocol?
    
    // MARK: - IBAction
    
    /**
     Closes the side menu view controller
     
     - parameter sender: The object that called this function
     */
    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.dismissAnimation()
    }
    
    @IBAction func showOnboardingScreens(_ sender: Any) {
        
        self.beginOnboarding()
    }
    
    @objc
    private func swipedCloseMenu() {
        
        self.dismissAnimation()
    }
    
    // MARK: - View Controller functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // create a tap gesture recogniser to dismiss the side menu
        self.createGestureRecognizers()
        
        // set table view delegate and datasource to self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func createGestureRecognizers() {
        
        let backgroundViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(tapGesture:)))
        backgroundViewTapGesture.numberOfTapsRequired = 1
        self.backgroundView.addGestureRecognizer(backgroundViewTapGesture)
        
        let closeViewGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(tapGesture:)))
        closeViewGesture.numberOfTapsRequired = 1
        self.closeMenuView.addGestureRecognizer(closeViewGesture)
        
        let aboutViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.beginOnboarding))
        aboutViewGesture.numberOfTapsRequired = 1
        self.aboutView.addGestureRecognizer(aboutViewGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(self.swipedCloseMenu))
        swipeGesture.direction = .left
        swipeGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(swipeGesture)
    }
    
    private func setNewToken(newToken: String?) {
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newToken)
    }
    
    @objc
    private func showSpaceAlertPopUp() {
        
        self.createDressyClassicOKAlertWith(
            alertMessage: "Your HAT storage is reaching the maximum allowance.",
            alertTitle: "Remaining storage low",
            okTitle: "OK",
            proceedCompletion: nil)
    }
    
    @objc
    private func beginOnboarding() {
        
        // get view controller
        let storyboard = HATUIViewController.getMainStoryboard()
        let viewControllerToPresent = storyboard.instantiateViewController(withIdentifier: "launchOnboarding")
        viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        
        self.dismissAnimation(dismissView: true, completion: { [weak self] in
            
            // present view controller
            self?.present(viewControllerToPresent, animated: true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SideMenu.getAvailableOptions().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: SideMenuCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.sideMenuButtonsCell, for: indexPath) as? SideMenuCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.sideMenuButtonsCell, for: indexPath)
        }
        
        // get key: value from constants
        let availableOptions: [Dictionary<String, String>] = SideMenu.getAvailableOptions()
        let menuName: Dictionary<String, String> = availableOptions[indexPath.row]
        
        // set up cell
        return cell.setUpCell(cell: cell, name: menuName.first?.key, viewControllerName: menuName.first?.value)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.selectedIndex == indexPath.row {
            
            cell.setSelected(true, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewControllerID = SideMenu.getAvailableOptions()[indexPath.row].first?.value,
            self.selectedIndex != indexPath.row else {
            
            self.dismissAnimation()
            return
        }
        
        self.tableView.deselectRow(at: IndexPath(row: self.selectedIndex, section: 0), animated: true)
        
        // get view controller
        let storyboard = HATUIViewController.getMainStoryboard()
        let viewControllerToPresent = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.dismissAnimation(dismissView: true, completion: { [weak self] in
            
            appDelegate.window?.rootViewController = viewControllerToPresent
            
            // present view controller
            self?.present(viewControllerToPresent, animated: true, completion: nil)
        })
    }
    
    // MARK: - Present side menu
    
    /**
     Presents the view cntroller requested by user
     
     - parameter delegate: The delegate of the side menu
     - parameter restorationID: The restoration ID of the view controller to load

     - returns: The side menu view controller
     */
    class func present(delegate: SideMenuDelegateProtocol, restorationID: String?) -> SideMenuViewController? {
        
        // sets animation of opacity
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.beginTime = 0
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.both
        animation.keyTimes = [0, 0.2]
        animation.values = [0, 0.6]
        animation.duration = 0.2
        
        // sets transition of the new view controller
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype(rawValue: kCATransition)
        
        // get the view controller requested
        let window = UIApplication.shared.keyWindow
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "sideMenu") as? SideMenuViewController
        viewController?.delegate = delegate
        viewController?.modalPresentationStyle = .fullScreen
        viewController?.modalPresentationCapturesStatusBarAppearance = true
        viewController?.view.addBorder(width: 3, color: .clear)
        
        viewController?.view.addShadow(color: .black, shadowRadius: 1, shadowOpacity: 0.7, width: 4, height: 0)
        
        // find index of the view controller from the constants
        viewController?.getIndexOfViewController(restorationID: restorationID)

        // add it to view
        window?.addSubview(viewController!.view)
        
        // add the transition animation to view
        viewController?.view.window?.layer.add(transition, forKey: kCATransition)
        
        // add the opacity animation to view
        viewController?.backgroundView.layer.add(animation, forKey: "animateOpacity")
        
        // return view controller
        return viewController
    }
    
    // MARK: - Dismiss side menu
    
    /**
     Dismisses the side menu view controller
     
     - parameter tapGesture: The tap gesture that called this method
     */
    @objc
    private func dismissView(tapGesture: UITapGestureRecognizer) {
        
        self.dismissAnimation()
    }
    
    func dismissAnimation(dismissView: Bool = false, completion: (() -> Void)? = nil) {
        
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                
                guard let weakSelf = self else {
                    
                    return
                }
                
                weakSelf.view.frame = CGRect(
                    x: 0 - weakSelf.view.frame.width,
                    y: weakSelf.view.frame.origin.y,
                    width: weakSelf.view.frame.width,
                    height: weakSelf.view.frame.height)
                weakSelf.backgroundView.alpha = 0
            },
            completion: { [weak self] result in
                
                guard let weakSelf = self else {
                    
                    return
                }
                
                completion?()
                weakSelf.delegate?.dismissSideMenu(sender: weakSelf, dismissView: dismissView)
                self?.removeViewController()
            }
        )
    }
    
    // MARK: - Get index of selected view controller
    
    /**
     Gets the index of the restoration ID for the specific view controller from constants
     
     - parameter restorationID: The restoration ID of the view controller
     */
    private func getIndexOfViewController(restorationID: String?) {
        
        let options = SideMenu.getAvailableOptions()
        for (index, option) in options.enumerated() where option.first != nil && restorationID != nil {
            
            if option.first!.value == restorationID {
                
                self.selectedIndex = index
            }
        }
    }

}
