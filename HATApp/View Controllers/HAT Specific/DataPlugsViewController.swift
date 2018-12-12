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

internal class DataPlugsViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DataPlugsDelegate {
    
    // MARK: - Data Plug Protocol
    
    func connectPlugInSafari(plug: HATApplicationObject) {
        
        if let appURL = URL(string: plug.application.setup.url!) {
            
            if UIApplication.shared.canOpenURL(appURL) {
                
                let appID = plug.application.id
                let url = "https://\(self.userDomain)/#/hatlogin?name=\(appID)&redirect=\(appURL)&fallback=hatapp://dismisssafari"
                self.openInSafari(url: url, animated: true, completion: nil)
            } else {
                
                let itunesURL = plug.application.kind.url
                self.openInSafari(url: itunesURL, animated: true, completion: nil)
            }
        } else {
            
            self.openInSafari(url: plug.application.kind.url, animated: true, completion: nil)
        }
    }
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the collectionView
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backroundImageView: UIImageView!
    
    // MARK: - Variables
    
    /// An array of HATDataPlugObject to save the received objects from hat
    private var dataPlugs: [HATApplicationObject] = []
    /// A variable to save what plug the user tries to connect
    private var plugTryingToConnect: String?
    private var selectedPlug: HATApplicationObject?
    
    // MARK: - View Controller functions

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.addSwipeRecogniserToShowSideMenu(view: self.collectionView)
        self.addSwipeRecogniserToShowSideMenu(view: self.backroundImageView)
        
        self.setNavigationBarColorToClear()
        
        // add notification observer for the login in
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dismissSafariPopUp(notif:)),
            name: NotificationNamesConstants.dataPlugMessage,
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.getAvailablePlugs()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Dismiss safari
    
    @objc
    private func dismissSafariPopUp(notif: Notification) {
        
        self.dismissSafari(animated: true, completion: { [weak self] in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let weakSelf = self,
                    let plugName: String = weakSelf.plugTryingToConnect else {
                    
                    return
                }
                
                weakSelf.showPopUp(message: "\(plugName) added!", buttonTitle: "", buttonAction: nil, selfDissmising: true)
                weakSelf.collectionView.reloadData()
                weakSelf.plugTryingToConnect = nil
            }
        })
    }
    
    // MARK: - Get Plugs
    
    /**
     Connects to the hat and gets available plugs
     */
    private func getAvailablePlugs() {
        
        self.showPopUp(message: "Fetching Data Plugs Please Wait", buttonTitle: nil, buttonAction: nil, selfDissmising: false)
        HATExternalAppsService.getExternalApps(userToken: self.userToken, userDomain: self.userDomain, completion: availablePlugsReceived, failCallBack: errorRetrievingDataPlugs)
    }
    
    /**
     Saves the plugs received from HAT
     
     - parameter dataPlugs: An array of HATDataPlugObject returned from HAT
     - parameter newUserToken: The new user's token returned from HAT
     */
    private func availablePlugsReceived(dataPlugs: [HATApplicationObject], newUserToken: String?) {
        
        self.dismissPopUp()
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newUserToken)

        self.dataPlugs.removeAll()
        for plug in dataPlugs where plug.application.kind.kind == "DataPlug" {
            
            self.dataPlugs.append(plug)
        }

        self.collectionView.reloadData()
    }
    
    /**
     Logs the error returned from HAT
     
     - parameter error: A DataPlugError representing the error that has occured whilst trying to download the available plugs
     */
    private func errorRetrievingDataPlugs(error: HATTableError) {
        
        switch error {
        case .generalError(_, let statusCode, _):
            
            if statusCode == 401 {
                
                self.tokenExpiredLogOut()
            }
        default:
            
            break
        }
        self.dismissPopUp()
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dataPlug: HATApplicationObject = self.dataPlugs[indexPath.row]
        return DataPlugsCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, userToken: userToken, userDomain: userDomain, dataPlug: dataPlug, delegate: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedPlug = self.dataPlugs[indexPath.row]
        self.performSegue(withIdentifier: CellIdentifiersConstants.dataPlugToAppDetailsSegue, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataPlugs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_   nView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: Int = Int(self.collectionView.frame.width) - 20
        return CGSize(width: width, height: 86)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? ExploreAppsDetailsViewController {
            
            vc.selectedApp = self.selectedPlug
        }
    }

}
