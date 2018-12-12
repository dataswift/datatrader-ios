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

class ConnectDataPlugsViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DataPlugsDelegate {
    
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
    
    var plugs: [HATApplicationObject] = []
    var cells: [DataPlugsCollectionViewCell] = []
    var plugsConnected: Int = 0
    var plugTryingToConnect: String?
    
    @IBOutlet weak var totalPlugsConnectedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func continueButtonAction(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        
        self.overrideTokenCheck = true

        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        self.plugsConnected = 0
        
//        for plug in plugs {
//            
//            HATDataPlugsService.checkStatusOfPlug(dataPlug: plug, userDomain: userDomain, userToken: userToken, completion: plugStatus)
//        }
        
        self.totalPlugsConnectedLabel.text = "\(self.plugsConnected) DATA PLUGS CONNECTED"
    }
    
    private func plugStatus(result: Bool, newToken: String?) {
    
        if result {
            
            self.plugsConnected += 1
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    private func getPlugs() {
        
        HATExternalAppsService.getExternalApps(userToken: self.userToken, userDomain: self.userDomain, completion: availablePlugs, failCallBack: failure)
    }
    
    private func availablePlugs(plugs: [HATApplicationObject], newToken: String?) {
        
        self.plugs.removeAll()
        for plug in plugs where plug.application.kind.kind == "DataPlug" {
            
            self.plugs.append(plug)
        }

        DispatchQueue.main.async { [weak self] in
            
            self?.collectionView.reloadData()
        }
    }
    
    private func failure(error: HATTableError) {
        
    }

    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dataPlug: HATApplicationObject = self.plugs[indexPath.row]
        return DataPlugsCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, userToken: userToken, userDomain: userDomain, dataPlug: dataPlug, delegate: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.plugs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: Int = Int(self.collectionView.frame.width) - 30
        return CGSize(width: width, height: 60)
    }
}
