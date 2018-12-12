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

class ExploreAppsDetailsScreenshotCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Variables
    
    private var screenshots: [HATExternalAppsIllustrationObject] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var mainView: UIView!
    
    // MARK: - Collection view functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return ExploreAppsInfoImageCollectionViewCell.setupCell(indexPath: indexPath, collectionView: collectionView, screenshot: screenshots[indexPath.row])
    }
    
    // MARK - Set up cell
    
    static func setupCell(indexPath: IndexPath, collectionView: UICollectionView, screenshots: [HATExternalAppsIllustrationObject]) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.screenshotsCell, for: indexPath) as? ExploreAppsDetailsScreenshotCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.appInfoCell, for: indexPath)
        }
        
        cell.mainView.layer.cornerRadius = 5
        cell.screenshots = screenshots
        
        return cell
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        layoutAttributes.size.height = 430
        
        return layoutAttributes
    }
}
