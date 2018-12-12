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

import HatForIOS

class ToolsViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ToolsDelegate {
    
    // MARK: - Tools Protocol
    
    func connectTool(_ tool: HATToolsObject) {
        
        self.showPopUp(message: "Enabling tool...", buttonTitle: nil, buttonAction: nil, selfDissmising: false)
        
        if tool.status.available && !tool.status.enabled {
            
            HATToolsService.enableTool(
                toolName: tool.id,
                userDomain: self.userDomain,
                userToken: self.userToken,
                completion: toolEnabled,
                failCallBack: errorEnablingTool)
        }
    }
    
    // MARK: - Variables
    
    private var receivedTools: [HATToolsObject] = []
    private var selectedTool: HATToolsObject?
    
    // MARK: - IBOutlets
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func sideMenuButtonAction(_ sender: Any) {
        
        sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let disableAppAction = UIAlertAction(title: "About SHE", style: .default, handler: { [weak self] _ in
            
            guard let weakSelf = self else { return }
            
            weakSelf.startOnboarding()
            }
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addActions(actions: [disableAppAction, cancelAction])
        actionSheet.addiPadSupport(barButtonItem: self.navigationItem.rightBarButtonItem!, sourceView: self.moreButton)
        
        // present the action Sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - View Controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addSwipeRecogniserToShowSideMenu(view: self.collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setNavigationBarColorToClear()
        self.getToolsFromHAT()
        self.checkForOnboarding()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Check for onboarding
    
    private func checkForOnboarding() {
        
        let result = KeychainManager.getKeychainValue(key: KeychainConstants.toolsOnboarding)
        if result != KeychainConstants.Values.setTrue {
            
            self.startOnboarding()
        }
    }
    
    private func startOnboarding() {
        
        // get the next view controller
        let mainStoryboard: UIStoryboard = HATUIViewController.getMainStoryboard()
        if let vc: OnboardingPageViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerNames.launchOnboarding) as? OnboardingPageViewController {
                        
            // present the next view controller
            self.present(vc, animated: true, completion: nil)
            KeychainManager.setKeychainValue(key: KeychainConstants.toolsOnboarding, value: KeychainConstants.Values.setTrue)
        }
    }
    
    // MARK: - CollectionView methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return receivedTools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return ToolsCollectionViewCell.setupCell(indexPath: indexPath, collectionView: self.collectionView, tool: self.receivedTools[indexPath.row], delegate: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedTool = self.receivedTools[indexPath.row]
        self.performSegue(withIdentifier: SeguesConstants.toolsToDetailedTools, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.frame.width - 20
        return CGSize(width: width, height: 86)
    }
    
    // MARK: - Get Apps From HAT
    
    private func gotAppsFromDex(tools: [HATToolsObject], newToken: String?) {
        
        self.dismissPopUp()
        
        self.receivedTools.removeAll()
        
        for tool in tools where tool.status.available {
            
            self.receivedTools.append(tool)
        }
        
        self.collectionView.reloadData()
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newToken)
    }
    
    private func errorGettingApps(error: Error) {
        
        self.dismissPopUp()
    }
    
    private func toolEnabled(tool: HATToolsObject, newToken: String?) {
        
        self.dismissPopUp()
        
        for (index, tempTool) in self.receivedTools.enumerated() where tempTool.info.name == tool.info.name {
            
            self.receivedTools[index] = tool
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            return
        }
    }
    
    private func errorEnablingTool(error: HATTableError) {
        
        self.dismissPopUp(completion: { [weak self] in
        
            self?.showPopUp(message: "Error enabling tool", buttonTitle: nil, buttonAction: nil, selfDissmising: true, fromY: nil)
        })
    }
    
    private func getToolsFromHAT() {
        
        self.showPopUp(message: "Fetching Tools...", buttonTitle: nil, buttonAction: nil)
        
        HATToolsService.getAvailableTools(
            userDomain: self.userDomain,
            userToken: self.userToken,
            completion: gotAppsFromDex,
            failCallBack: errorGettingApps)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? ToolsDetailsViewController {
            
            vc.selectedTool = self.selectedTool
        }
    }
}
