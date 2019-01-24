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

class GoToHatAppDataPreviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    private var selectedDataPlugID: String = ""
    private var userDomain: String = ""
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var goToHATAppButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func goToHatApp(_ sender: Any) {
        
        if let appURL = URL(string: "hatapp://datapreview--\(self.userDomain)--\(selectedDataPlugID)"), UIApplication.shared.canOpenURL(appURL) {
            
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Setup cell
    
    static func setupCell(indexPath: IndexPath, collectionView: UICollectionView, dataplugID: String, userDomain: String) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.goToHATAppDataPreviewCell, for: indexPath) as? GoToHatAppDataPreviewCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.goToHATAppDataPreviewCell, for: indexPath)
        }
        
        cell.goToHATAppButton.layer.cornerRadius = 5
        cell.selectedDataPlugID = dataplugID
        cell.userDomain = userDomain
        
        return cell
    }
}
