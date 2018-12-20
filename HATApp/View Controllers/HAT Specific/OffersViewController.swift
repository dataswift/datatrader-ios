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

// MARK: Class

class OffersViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, OfferCellDelegate {
    
    func progressLabelTapped(dataDebitID: String) {
        
        self.openInSafari(url: "https://\(self.userDomain)/#/data-debit/\(dataDebitID)/quick-confirm?redirect=\(Auth.urlScheme)://\(Auth.dataDebitHost)&fallback=\(Auth.urlScheme)/dataDebitFailure", animated: true, completion: nil)
    }
    
    // MARK: - Variables
    
    private var selectedOffersIndex: Int = 0
    private var acceptedOffers: [DataOfferObject] = []
    private var completedOffers: [DataOfferObject] = []
    private var filteredOffers: [DataOfferObject] = []
    private var dataDebitsForOffers: [String: DataDebitValuesObject] = [:]
    private var selectedIndex: Int = 0
    private var vouchersEarned: Int = 0
    private var cashEarned: Float = 0
    private var pannelsJoined: Int = 0
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var selectionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var acceptedOffersButtonView: UIView!
    @IBOutlet private weak var completedOffersButtonVIew: UIView!
    @IBOutlet private weak var selectorView: UIView!
    @IBOutlet private weak var acceptedOffersCountLabel: UILabel!
    @IBOutlet private weak var acceptedOffersLabel: UILabel!
    @IBOutlet private weak var completedOffersCountLabel: UILabel!
    @IBOutlet private weak var completedOffersLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func menuButtonAction(_ sender: Any) {
        
        self.sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)
    }
    
    // MARK: - View Controller delegate
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setNavigationBarColorToDarkBlue()
        self.addSwipeRecogniserToShowSideMenu(view: self.collectionView)
        
        self.acceptedOffersButtonView.isUserInteractionEnabled = true
        self.completedOffersButtonVIew.isUserInteractionEnabled = true
        
        let acceptedOffersTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.acceptedButtonViewTapped))
        let completedOffersTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.completedButtonViewTapped))
        
        self.acceptedOffersButtonView.addGestureRecognizer(acceptedOffersTapGesture)
        self.completedOffersButtonVIew.addGestureRecognizer(completedOffersTapGesture)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setNavigationBarColorToDarkBlue()
        
        self.showPopUp(message: "Fetching offers...", buttonTitle: nil, buttonAction: nil)
        
        HATDataOffersService.getAvailableDataOffers(
            userDomain: self.userDomain,
            userToken: userToken,
            merchants: ["datatrader"],
            succesfulCallBack: receivedOffers,
            failCallBack: databuyerOffersError)
    }
    
    // MARK: - Gesture recognisers
    
    @objc
    private func acceptedButtonViewTapped() {
        
        self.selectedOffersIndex = 0
        self.selectionViewLeadingConstraint.constant = 0
        
        self.acceptedOffersCountLabel.font = UIFont.oswaldBold(ofSize: 12)
        self.acceptedOffersCountLabel.alpha = 1
        self.acceptedOffersLabel.font = UIFont.oswaldBold(ofSize: 12)
        self.acceptedOffersLabel.alpha = 1
        self.completedOffersLabel.font = UIFont.oswaldLight(ofSize: 12)
        self.completedOffersLabel.alpha = 0.5
        self.completedOffersCountLabel.font = UIFont.oswaldLight(ofSize: 12)
        self.completedOffersCountLabel.alpha = 0.5
        
        self.animateLayoutChanges()
        self.filterDataSource()
        self.collectionView.reloadData()
    }
    
    @objc
    private func completedButtonViewTapped() {
        
        self.selectedOffersIndex = 1
        self.selectionViewLeadingConstraint.constant = self.acceptedOffersButtonView.frame.maxX - self.completedOffersButtonVIew.frame.origin.x - self.selectorView.frame.width
        
        self.acceptedOffersCountLabel.font = UIFont.oswaldLight(ofSize: 12)
        self.acceptedOffersCountLabel.alpha = 0.5
        self.acceptedOffersLabel.font = UIFont.oswaldLight(ofSize: 12)
        self.acceptedOffersLabel.alpha = 0.5
        self.completedOffersLabel.font = UIFont.oswaldBold(ofSize: 12)
        self.completedOffersLabel.alpha = 1
        self.completedOffersCountLabel.font = UIFont.oswaldBold(ofSize: 12)
        self.completedOffersCountLabel.alpha = 1
        
        self.animateLayoutChanges()
        self.filterDataSource()
        self.collectionView.reloadData()
    }
    
    // MARK: - Get offers
    
    private func receivedOffers(dataOffers: [DataOfferObject], newUserToken: String?) {
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newUserToken)

        DispatchQueue.main.async { [weak self] in
            
            self?.acceptedOffers.removeAll()
            self?.completedOffers.removeAll()
            self?.filteredOffers.removeAll()
            
            self?.dismissPopUp()
//            for offer in dataOffers {
//                
//                self?.getDataDebit(dataDebitID: offer.claim.dataDebitID)
//            }
            self?.filterOffers(dataOffers: dataOffers)
            self?.countOffers(offers: dataOffers)
            self?.filterDataSource()
            self?.collectionView.reloadData()
        }
    }

    private func databuyerOffersError(error: DataPlugError) {
        
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
    
    private func dataDebitError(error: DataPlugError, dataDebitID: String) {
        
        self.dataDebitsForOffers[dataDebitID] = DataDebitValuesObject()
    }
    
    private func filterOffers(dataOffers: [DataOfferObject]) {
        
        for offer in dataOffers {
            
            let state = DataOfferStatusManager.getState(of: offer)
            
            switch state {
            case .accepted:
                
                self.acceptedOffers.append(offer)
            case .available:
                
                break
            default:
                
                self.completedOffers.append(offer)
            }
        }
    }
    
    private func filterDataSource() {
        
        if self.selectedOffersIndex == 0 {
            
            self.filteredOffers = self.acceptedOffers
        } else {
            
            self.filteredOffers = self.completedOffers
        }
    }
    
    private func countOffers(offers: [DataOfferObject]) {
        
        var vouchers: Int = 0
        var cash: Int = 0
        var pannels: Int = 0
        
        for offer in offers {
            
            let state = DataOfferStatusManager.getState(of: offer)
            
            switch state {
            case .completed:
                
                if offer.reward.rewardType == "service" {
                    
                    pannels = pannels + 1
                } else if offer.reward.rewardType == "voucher" {
                    
                    vouchers = vouchers + 1
                } else if offer.reward.rewardType == "cash" {
                    
                    cash = cash + offer.reward.value
                }
            default:
                
                break
            }
        }
        
        self.vouchersEarned = vouchers
        self.cashEarned = Float(cash) / 100.0
        self.pannelsJoined = pannels
        
        self.completedOffersCountLabel.text = "\(self.completedOffers.count)"
        self.acceptedOffersCountLabel.text = "\(self.acceptedOffers.count)"
    }
    
    private func getDataDebit(dataDebitID: String) {
        
        HATService.getApplicationTokenFor(
            userDomain: self.userDomain,
            userToken: self.userToken,
            appName: "databuyerstaging",
            succesfulCallBack: { [weak self] appToken, newUserToken in
                
                guard let weakSelf = self else { return }
                
                HATDataDebitsService.getDataDebitValues(
                    dataDebitID: dataDebitID,
                    userToken: appToken,
                    userDomain: weakSelf.userDomain,
                    succesfulCallBack: { dataDebitValue, newUserToken in
                        
                        weakSelf.dataDebitsForOffers[dataDebitID] = DataDebitValuesObject()
                        weakSelf.dataDebitsForOffers[dataDebitID] = dataDebitValue
                        weakSelf.collectionView.reloadData()
                    },
                    failCallBack: weakSelf.dataDebitError)
            },
            failCallBack: { _ in return })
    }
    
    // MARK: - UICollectionView delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if selectedOffersIndex == 1 {

            return self.filteredOffers.count + 1 // The + 1 is the summary cell at the top of the screen
        }
        return self.filteredOffers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if selectedOffersIndex == 1 {

            if indexPath.row == 0 {

                return OffersSummaryCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, totalVouchers: self.vouchersEarned, totalCash: self.cashEarned, totalPannels: self.pannelsJoined)
            }
            
            if self.dataDebitsForOffers.count > self.filteredOffers.count {
                
                return DataOffersCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, dataOffer: self.filteredOffers[indexPath.row - 1], cellID: CellIdentifiersConstants.offerCell, dataDebitValue: self.dataDebitsForOffers[self.filteredOffers[indexPath.row - 1].claim.dataDebitID], delegate: self)
            }
            
            return DataOffersCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, dataOffer: self.filteredOffers[indexPath.row - 1], cellID: CellIdentifiersConstants.offerCell, dataDebitValue: nil, delegate: self)
        }
        
        if self.dataDebitsForOffers.count > self.filteredOffers.count {
            
            return DataOffersCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, dataOffer: self.filteredOffers[indexPath.row], cellID: CellIdentifiersConstants.offerCell, dataDebitValue: self.dataDebitsForOffers[self.filteredOffers[indexPath.row].claim.dataDebitID], delegate: self)
        }
        return DataOffersCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, dataOffer: self.filteredOffers[indexPath.row], cellID: CellIdentifiersConstants.offerCell, dataDebitValue: nil, delegate: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.selectedOffersIndex == 0 {
            
            self.selectedIndex = indexPath.row
        } else {
            
            guard indexPath.row != 0 else { return }
            self.selectedIndex = indexPath.row - 1
        }
        
        let mainStoryboard: UIStoryboard = HATUIViewController.getMainStoryboard()
        guard let vc: OfferDetailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "offerDetailsViewController") as? OfferDetailsViewController,
                self.filteredOffers.count > self.selectedIndex else { return }
        
        vc.offer = self.filteredOffers[self.selectedIndex]
        
        // present the next view controller
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width - 30
        if selectedOffersIndex == 1 && indexPath.row == 0 {

            return CGSize(width: width, height: 90)
        }
        
        return CGSize(width: width, height: 333)
    }
}
