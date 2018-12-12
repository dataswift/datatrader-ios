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

class ExploreAppsDataImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var imageView: UIImageView!
    
    func setUpCell(cell: ExploreAppsDataImageCollectionViewCell, imageURL: String) {
        
        if imageURL == "facebook" {
            
            cell.imageView.image = UIImage(named: ImageNamesConstants.facebook)
        } else if imageURL == "google" {
            
            cell.imageView.image = UIImage(named: ImageNamesConstants.googleFeed)
        } else if imageURL == "twitter" {
            
            cell.imageView.image = UIImage(named: ImageNamesConstants.twitter)
        } else {
            
            cell.imageView.image = UIImage(named: ImageNamesConstants.hatters)
        }
    }
}
