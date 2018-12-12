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

class DataPreviewMessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    // MARK: - Setup cell
    
    static func setupCell(indexPath: IndexPath, collectionView: UICollectionView, message: String) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyPreviewCell", for: indexPath) as? DataPreviewMessageCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "emptyPreviewCell", for: indexPath)
        }
        
        cell.messageLabel.text = message
        
        return cell
    }
}
