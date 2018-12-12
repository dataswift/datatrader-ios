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

class OfferDetailsViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, OfferLabelTappedDelegate, OfferCellDelegate {
    
    func progressLabelTapped(dataDebitID: String) {
        
        self.openInSafari(url: "https://\(self.userDomain)/#/data-debit/\(dataDebitID)/quick-confirm?redirect=\(Auth.urlScheme)://\(Auth.dataDebitHost)&fallback=\(Auth.urlScheme)/dataDebitFailure", animated: true, completion: nil)
    }
    
    func showReward() {
        
        if offer?.reward.rewardType == "voucher" {
            
            self.createDressyClassicDialogueAlertWith(
                alertMessage: "Your voucher is: \(offer!.reward.codes!.first!)",
                alertTitle: "Reward",
                okTitle: "Copy in clipboard",
                cancelTitle: "Cancel",
                proceedCompletion: { [weak self] in
                    
                    guard let weakSelf = self else { return }
                    UIPasteboard.general.string = weakSelf.offer!.reward.codes!.first!
            })
        } else if offer?.reward.rewardType == "service" {
            
            self.createDressyClassicDialogueAlertWith(
                alertMessage: "You can claim the reward in: \(offer!.reward.vendorURL)",
                alertTitle: "Reward",
                okTitle: "Open in safari",
                cancelTitle: "Cancel",
                proceedCompletion: { [weak self] in
                    
                    guard let weakSelf = self else { return }
                    self?.openInSafari(url: weakSelf.offer?.reward.vendorURL ?? "", animated: true, completion: nil)
            })
        }
    }

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var acceptOfferButton: UIButton!
    @IBOutlet private weak var acceptOfferViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var acceptTermsBaseView: UIView!
    
    var offer: DataOfferObject?
    private var dataDebit: DataDebitObject?
    private var dataDebitsForOffers: [String: DataDebitValuesObject] = [:]

    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptOfferButtonAction(_ sender: Any) {
        
        self.acceptOffer()
    }
    
    private func acceptOffer() {
        
        self.showPopUp(message: "Accepting offer. Please wait....", buttonTitle: nil, buttonAction: nil, selfDissmising: false, fromY: self.acceptTermsBaseView.frame.origin.y)
        self.acceptOfferButton.alpha = 0.5
        self.acceptOfferButton.isUserInteractionEnabled = false
        
        HATDataOffersService.claimOffer(
            userDomain: self.userDomain,
            userToken: self.userToken,
            offerID: self.offer?.dataOfferID ?? "",
            succesfulCallBack: { [weak self] status, newUserToken in
                
                guard let weakSelf = self else { return }
                
                HATDataOffersService.getAvailableDataOffers(
                    userDomain: weakSelf.userDomain,
                    userToken: weakSelf.userToken,
                    merchants: ["datatraderstaging"],
                    succesfulCallBack: { offers, newToken in
                        
                        guard let dataDebitID = offers.filter({ return $0.dataOfferID == weakSelf.offer?.dataOfferID ?? ""}).first?.claim.dataDebitID else { return }
                        weakSelf.openInSafari(url: "https://\(weakSelf.userDomain)/#/data-debit/\(dataDebitID)/quick-confirm?redirect=\(Auth.urlScheme)://\(Auth.dataDebitHost)&fallback=\(Auth.urlScheme)/dataDebitFailure", animated: true, completion: nil)
                },
                    failCallBack: { _ in })
            },
            failCallBack: failedClaimingOffer)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.setUpUI()
        self.getDataDebit()
    }
    
    private func setUpUI() {
        
        self.acceptOfferButton.layer.cornerRadius = 5
        
        if let cvl: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let width = UIScreen.main.bounds.size.width
            cvl.estimatedItemSize = CGSize(width: width, height: 300)
        }
        
        if DataOfferStatusManager.getState(of: self.offer!) != .available {
            
            self.acceptOfferViewHeightConstraint.constant = 0
            self.acceptTermsBaseView.isHidden = true
        }
        
        self.getDataDebit(dataDebitID: self.offer?.claim.dataDebitID ?? "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataDebitAccepted), name: NotificationNamesConstants.dataDebitAccepted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataDebitFailure), name: NotificationNamesConstants.dataDebitFailure, object: nil)
    }
    
    @objc
    private func dataDebitAccepted() {
        
        self.dismissSafari(animated: true, completion: nil)
        self.dismissPopUp(completion: nil)
        self.showAcceptedVC()
    }
    
    @objc
    private func dataDebitFailure() {
        
        self.dismissSafari(animated: true, completion: nil)
        self.dismissPopUp(completion: { [weak self] in
            
            self?.showPopUp(message: "Accepting data debit failed", buttonTitle: nil, buttonAction: nil, selfDissmising: true, fromY: self?.acceptTermsBaseView.frame.origin.y)
        })
    }
    
    private func getDataDebit() {
        
        guard self.offer != nil, self.offer?.claim.dataDebitID != "" else { return }
        
        HATDataDebitsService.getDataDebit(
            dataDebitID: self.offer!.claim.dataDebitID,
            userToken: self.userToken,
            userDomain: self.userDomain,
            succesfulCallBack: dataDebitReceived,
            failCallBack: failedFetchingDataDebit)
    }
    
    private func dataDebitReceived(dataDebit: DataDebitObject, newUserToken: String?) {
        
        self.dataDebit = dataDebit
    }
    
    private func failedFetchingDataDebit(error: DataPlugError) {
        
    }
    
    @objc
    private func openTerms() {
        
        guard let url = self.dataDebit?.permissions.first?.termsUrl else { return }
        
        self.openInSafari(url: url, animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            let title = offer?.title.capitalized ?? ""
            let expiryDate = FormatterManager.formatStringToDate(string: offer?.offerExpires ?? "")
            let expiryDateString = FormatterManager.formatDateStringToUsersDefinedDate(date: expiryDate!, dateStyle: .medium, timeStyle: .none)
            let expires = "Expires \(expiryDateString)"
            let status = DataOfferStatusManager.getState(of: self.offer!)
            
            if status != .available {
                
                if let dataDebitValue = self.dataDebitsForOffers[self.offer?.claim.dataDebitID ?? ""] {
                    
                    return OfferDetailsInfoCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, title: title, expirationText: expires, backgroundImageURL: self.offer?.illustrationURL, dataDebitValues: dataDebitValue, dataOffer: self.offer!, delegate: self, dataDebitID: self.offer?.claim.dataDebitID ?? "")
                } else {
                    
                    return OfferDetailsInfoCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, title: title, expirationText: expires, backgroundImageURL: self.offer?.illustrationURL, dataDebitValues: nil, dataOffer: self.offer!, delegate: self, dataDebitID: self.offer?.claim.dataDebitID ?? "")
                }
            } else {
                
                return OfferDetailsInfoCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, title: title, expirationText: expires, backgroundImageURL: self.offer?.illustrationURL, delegate: self, dataDebitID: self.offer?.claim.dataDebitID ?? "")
            }
        } else if indexPath.row == 1 {
            
            let attributedString = NSAttributedString(string: offer?.longDescription ?? "")
            return OfferDetailsInfoDescriptionCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, title: "Offer details", subtitle: attributedString, subtitleAlignment: .center, delegate: self)
        } else if indexPath.row == 2 {
            
            
            var attributedString: NSAttributedString = NSAttributedString.formatRequiredDataDefinitionText(requiredDataDefinition: [self.offer!.requiredDataDefinition!])
            if attributedString.string == "" {
                
                attributedString = NSAttributedString.formatRequiredDataDefinitionText(requiredDataDefinition: [self.offer!.dataConditions!])
            }
            return OfferDetailsInfoDescriptionCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, title: "Criteria", subtitle: attributedString, subtitleAlignment: .left, delegate: self)
        } else {
            
            let string = """
                        1. Accept offer

                        2. Await offer fulfilment

                        3. Enjoy your benefits
                        """
            let attributedString = NSAttributedString(string: string)
            let newAttributedString = DataOfferStatusManager.appendRewardToAttributedString(attributedString: attributedString, dataOffer: offer!)
            return OfferDetailsInfoDescriptionCollectionViewCell.setUpCell(collectionView: collectionView, indexPath: indexPath, title: "Actions required", subtitle: newAttributedString, subtitleAlignment: .left, delegate: self)
        }
    }
    
    private func failedClaimingOffer(error: DataPlugError) {
        
        self.acceptOfferButton.alpha = 1
        self.acceptOfferButton.isUserInteractionEnabled = true
        
        self.dismissPopUp(completion: { [weak self] in
            
            self?.showPopUp(message: "Claiming failed", buttonTitle: nil, buttonAction: nil, selfDissmising: true, fromY: self?.acceptTermsBaseView.frame.origin.y)
        })
    }
    
    private func offerClaimed(offer: DataOfferObject, newUserToken: String?) {
        
        self.showAcceptedVC()
    }
    
    private func showAcceptedVC() {
        
        self.acceptOfferButton.alpha = 1
        self.acceptOfferButton.isUserInteractionEnabled = true
        self.dismissPopUp(completion: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerNames.acceptedOfferViewController)
        self.present(vc!, animated: true, completion: nil)
    }
    
    private func getDataDebit(dataDebitID: String) {
        
        HATDataDebitsService.getDataDebitValues(
            dataDebitID: dataDebitID,
            userToken: self.userToken,
            userDomain: self.userDomain,
            succesfulCallBack: { [weak self] dataDebitValue, newUserToken in
                
                self?.dataDebitsForOffers[dataDebitID] = DataDebitValuesObject()
                self?.dataDebitsForOffers[dataDebitID] = dataDebitValue
                self?.collectionView.reloadData()
            },
            failCallBack: {_, _ in return })
    }

}
