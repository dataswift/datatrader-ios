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

// MARK: Class

class DataOffersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    private var delegate: OfferCellDelegate?
    private var offer: DataOfferObject = DataOfferObject()
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var offerImageView: UIImageView!
    @IBOutlet private weak var offerTitleLabel: UILabel!
    @IBOutlet private weak var offerDescriptionLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var progressStatusLabel: UILabel!
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var overalyImageView: UIImageView!
    @IBOutlet private weak var baseImageViewView: UIView!
    
    // MARK: - Setup
    
    static func setUpCell(collectionView: UICollectionView, indexPath: IndexPath, dataOffer: DataOfferObject, cellID: String, dataDebitValue: DataDebitValuesObject?, delegate: OfferCellDelegate?) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? DataOffersCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        }
        
        cell.delegate = delegate
        cell.offer = dataOffer
        cell.setUpUI(title: dataOffer.title, description: dataOffer.shortDescription, imageURL: dataOffer.illustrationURL, offer: dataOffer)
        if cell.progressBar != nil {
            
            DataOfferStatusManager.setUpProgressBar(offer: dataOffer, dataDebitValue: dataDebitValue, progressBar: cell.progressBar, progressStatusLabel: cell.progressStatusLabel)
        }
        return cell
    }
    
    private func setUpUI(title: String, description: String, imageURL: String, offer: DataOfferObject) {
        
        if let url: URL = URL(string: imageURL) {
            
            self.offerImageView.kf.setImage(with: url)
        }
        
        self.baseImageViewView.layer.cornerRadius = 5
        self.offerTitleLabel.text = title
        self.offerDescriptionLabel.text = description
        self.mainView.layer.cornerRadius = 5
        self.addShadow(color: .lightGray, shadowRadius: 1, shadowOpacity: 0.5, width: 0, height: 3)
        
        let status = DataOfferStatusManager.getState(of: offer)
        if status == .completed {
            
            overlayView.isHidden = false
            overalyImageView.isHidden = false
            if offer.reward.rewardType == "voucher" {
                
                overalyImageView.image = UIImage(named: ImageNamesConstants.voucherUsed)
            } else if offer.reward.rewardType == "cash" {
                
                overalyImageView.image = UIImage(named: ImageNamesConstants.cashEarned)
            } else {
                
                overalyImageView.image = UIImage(named: ImageNamesConstants.panelJoined)
            }
        }
    }
    
    private func addGestureRecognizerToProgressLabel() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.progressLabelTapped))
        self.progressStatusLabel.addGestureRecognizer(tapGesture)
        self.progressStatusLabel.isUserInteractionEnabled = true
    }
    
    @objc
    private func progressLabelTapped() {
        
        self.delegate?.progressLabelTapped(dataDebitID: self.offer.claim.dataDebitID)
    }
    
    override func prepareForReuse() {
        
        if self.progressBar != nil {
            
            self.progressStatusLabel.text = "Calculating..."
            self.progressBar.progress = 0
            self.overlayView.isHidden = true
            self.overalyImageView.isHidden = true
            self.delegate = nil
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        super.preferredLayoutAttributesFitting(layoutAttributes)

        self.layoutIfNeeded()
        self.layoutSubviews()
        
        let newDescriptionHeight = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        layoutAttributes.frame.size.height = newDescriptionHeight
        
        return layoutAttributes
    }
}
