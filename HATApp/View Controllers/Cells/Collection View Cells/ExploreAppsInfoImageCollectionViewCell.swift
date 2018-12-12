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

class ExploreAppsInfoImageCollectionViewCell: UICollectionViewCell, UserCredentialsProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Setup cell
    
    static func setupCell(indexPath: IndexPath, collectionView: UICollectionView, screenshot: HATExternalAppsIllustrationObject) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appInfoImageCell", for: indexPath) as? ExploreAppsInfoImageCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "appInfoImageCell", for: indexPath)
        }
       
        if let url = URL(string: screenshot.normal) {
            
            DispatchQueue.main.async {
                
                let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.addActivityIndicator(onView: cell.imageView)
                cell.imageView.cacheImage(resource: url, placeholder: nil, userDomain: cell.userDomain, progressBlock: nil, completionHandler: { image, error, cacheType, url in
                    
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                })
            }
        }
        
        return cell
    }
}
