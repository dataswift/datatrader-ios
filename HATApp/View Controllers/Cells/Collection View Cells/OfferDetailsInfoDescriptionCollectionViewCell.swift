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

import UIKit

// MARK: Class

class OfferDetailsInfoDescriptionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: OfferLabelTappedDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!
    
    // MARK: - Set up cell
    
    class func setUpCell(collectionView: UICollectionView, indexPath: IndexPath, title: String, subtitle: NSAttributedString, subtitleAlignment: NSTextAlignment, delegate: OfferLabelTappedDelegate?) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.offerDetailsCell, for: indexPath) as? OfferDetailsInfoDescriptionCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.offerDetailsCell, for: indexPath)
        }
        
        let style = NSMutableParagraphStyle()
        style.alignment = subtitleAlignment
        style.lineBreakMode = .byWordWrapping
        cell.delegate = delegate
        cell.headerLabel.text = title
        let string = NSMutableAttributedString(attributedString: subtitle)
        string.addAttributes([.paragraphStyle: style], range: NSMakeRange(0, subtitle.length))
        cell.dataLabel.attributedText = string
        
        if title == "Actions required" {
            
            let tapGesture = UITapGestureRecognizer(target: cell, action: #selector(subtitleLabelTapped))
            cell.dataLabel.addGestureRecognizer(tapGesture)
            cell.dataLabel.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    @objc
    private func subtitleLabelTapped() {
        
        self.delegate?.showReward()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        let newDescriptionHeight = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        layoutAttributes.frame.size.height = newDescriptionHeight
        
        return layoutAttributes
    }
}
