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

class OfferDetailsInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    private var delegate: OfferCellDelegate?
    private var dataDebitID: String = ""
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var offerInfoView: UIView!
    @IBOutlet private weak var offerTitleLabel: UILabel!
    @IBOutlet private weak var offerExpirationDate: UILabel!
    @IBOutlet private weak var offerImageView: UIImageView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var progressLabel: UILabel!
    
    // MARK: - Set up cell
    
    class func setUpCell(collectionView: UICollectionView, indexPath: IndexPath, title: String, expirationText: String, backgroundImageURL: String? = nil, delegate: OfferCellDelegate?, dataDebitID: String) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.offerInfoCell, for: indexPath) as? OfferDetailsInfoCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.offerInfoCell, for: indexPath)
        }
        
        cell.offerTitleLabel.text = title
        cell.offerExpirationDate.text = expirationText
        cell.offerInfoView.layer.cornerRadius = 5
        cell.offerInfoView.addShadow(color: .lightGray, shadowRadius: 3, shadowOpacity: 0.5, width: 0, height: 2)
        cell.addGestureRecognizerToProgressLabel()
        cell.delegate = delegate
        cell.dataDebitID = dataDebitID
        if let url = URL(string: backgroundImageURL ?? "") {
            
            cell.backgroundImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        return cell
    }
    
    class func setUpCell(collectionView: UICollectionView, indexPath: IndexPath, title: String, expirationText: String, backgroundImageURL: String? = nil, dataDebitValues: DataDebitValuesObject?, dataOffer: DataOfferObject, delegate: OfferCellDelegate?, dataDebitID: String) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.acceptedOfferInfoCell, for: indexPath) as? OfferDetailsInfoCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.acceptedOfferInfoCell, for: indexPath)
        }
        
        DataOfferStatusManager.setUpProgressBar(offer: dataOffer, dataDebitValue: dataDebitValues, progressBar: cell.progressBar, progressStatusLabel: cell.progressLabel)
        cell.offerTitleLabel.text = title
        cell.offerExpirationDate.text = expirationText
        cell.offerInfoView.layer.cornerRadius = 5
        cell.offerInfoView.addShadow(color: .lightGray, shadowRadius: 3, shadowOpacity: 0.5, width: 0, height: 2)
        cell.addGestureRecognizerToProgressLabel()
        cell.delegate = delegate
        cell.dataDebitID = dataDebitID
        if let url = URL(string: backgroundImageURL ?? "") {
            
            cell.backgroundImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        return cell
    }
    
    private func addGestureRecognizerToProgressLabel() {
        
        guard progressLabel != nil else { return }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.progressLabelTapped))
        self.progressLabel.addGestureRecognizer(tapGesture)
        self.progressLabel.isUserInteractionEnabled = true
    }
    
    @objc
    private func progressLabelTapped() {
        
        self.delegate?.progressLabelTapped(dataDebitID: dataDebitID)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        let newDescriptionHeight = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        layoutAttributes.frame.size.height = newDescriptionHeight
        
        return layoutAttributes
    }
}
