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

class ExploreAppsImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    
    // MARK: - Setup cell
    
    static func setupCell(indexPath: IndexPath, collectionView: UICollectionView, description: NSAttributedString) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.appInfoCell, for: indexPath) as? ExploreAppsImageCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.appInfoCell, for: indexPath)
        }
        
        cell.mainView.layer.cornerRadius = 5

        cell.descriptionLabel.attributedText = description
        // after html convertion font is reseting to default font for some reason
        cell.descriptionLabel.font = UIFont.openSans(ofSize: 13)
        cell.descriptionLabel.textColor = UIColor.sectionTextColor
        
        return cell
    }
    
    // MARK: - Update size of cell
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        let newDescriptionHeight = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        layoutAttributes.frame.size.height = newDescriptionHeight

        return layoutAttributes
    }
}
