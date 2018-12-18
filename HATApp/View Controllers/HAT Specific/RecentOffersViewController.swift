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
import SwiftyJSON

class RecentOffersViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var offers: [DataOfferObject] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func menuButtonAction(_ sender: Any) {
        
        self.sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addSwipeRecogniserToShowSideMenu(view: self.collectionView)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.setNavigationBarColorToDarkBlue()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.getOffers()
        self.checkForOnboarding()
    }

    private func checkForOnboarding() {
        
        let result = KeychainManager.getKeychainValue(key: KeychainConstants.newUser)
        if result != KeychainConstants.Values.setFalse {
            
            KeychainManager.setKeychainValue(key: KeychainConstants.newUser, value: KeychainConstants.Values.setFalse)
            self.navigateToViewControllerWithoutRemovingSuperView(name: ViewControllerNames.launchOnboarding)
        }
    }
    
    func getOffers() {
        
        self.showPopUp(message: "Fetching recent offers...", buttonTitle: nil, buttonAction: nil)
        HATDataOffersService.getAvailableDataOffers(
            userDomain: self.userDomain,
            userToken: userToken,
            merchants: ["shapeprivate"],
            succesfulCallBack: receivedOffers,
            failCallBack: databuyerOffersError)
    }
    
    private func receivedOffers(dataOffers: [DataOfferObject], newUserToken: String?) {
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newUserToken)
        
        DispatchQueue.main.async { [weak self] in
            
            self?.offers.removeAll()
            self?.dismissPopUp()
            self?.filterOffers(dataOffers: dataOffers)
            self?.collectionView.reloadData()
        }
    }
    
    private func databuyerOffersError(error: DataPlugError) {
        
        switch error {
        case .generalError(_, let statusCode, _):
            
            if statusCode == 400 {
                
                HATExternalAppsService.setUpApp(
                    userToken: self.userToken,
                    userDomain: self.userDomain,
                    applicationID: "databuyerstaging",
                    completion: { [weak self] _, _ in
                        
                        self?.getOffers()
                    },
                    failCallBack: { _ in return })
            } else if statusCode == 401 {
                    
                self.tokenExpiredLogOut()
            }
        default:
            
            break
        }
        self.dismissPopUp()
    }
    
    private func filterOffers(dataOffers: [DataOfferObject]) {
        
        for offer in dataOffers {
            
            let state = DataOfferStatusManager.getState(of: offer)
            
            switch state {
            case .available:
                
                self.offers.append(offer)
            default:
                
                break
            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return DataOffersCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, dataOffer: self.offers[indexPath.row], cellID: CellIdentifiersConstants.recentOfferCell, dataDebitValue: nil, delegate: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryboard: UIStoryboard = HATUIViewController.getMainStoryboard()
        guard let vc: OfferDetailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "offerDetailsViewController") as? OfferDetailsViewController else { return }
        vc.offer = self.offers[indexPath.row]
        
        // present the next view controller
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width - 30
        return CGSize(width: width, height: 333)
    }
    
}
