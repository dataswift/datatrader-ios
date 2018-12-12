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

class OffersSummaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var vouchersCountLabel: UILabel!
    @IBOutlet private weak var cashCountLabel: UILabel!
    @IBOutlet private weak var pannelsCountLabel: UILabel!
    
    static func setUpCell(collectionView: UICollectionView, indexPath: IndexPath, totalVouchers: Int, totalCash: Float, totalPannels: Int) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.offerSummaryCell, for: indexPath) as? OffersSummaryCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.offerSummaryCell, for: indexPath)
        }
        
        cell.vouchersCountLabel.text = "\(totalVouchers)"
        cell.cashCountLabel.text = "£\(totalCash)"
        cell.pannelsCountLabel.text = "\(totalPannels)"
        
        return cell
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
