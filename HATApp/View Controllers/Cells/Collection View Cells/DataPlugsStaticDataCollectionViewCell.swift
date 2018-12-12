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

// MARK: Struct

internal class DataPlugsStaticDataCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    
    // MARK: - Set up
    
    func setUpCell(title: String, subtitle: String) -> DataPlugsStaticDataCollectionViewCell {
        
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.mainView.layer.cornerRadius = 5
        
        return self
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let size = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        layoutAttributes.frame.size.height = size.height
        
        return layoutAttributes
    }
}
