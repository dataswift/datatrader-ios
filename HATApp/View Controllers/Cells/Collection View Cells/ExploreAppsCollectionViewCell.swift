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

class ExploreAppsCollectionViewCell: UICollectionViewCell, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    private var app: HATApplicationObject?
    private var indexPath: IndexPath?
    private weak var delegate: ExploreAppsDelegate?
    
    // MARK: - IBAction
    
    @IBAction func connectAppButtonAction(_ sender: Any) {
        
        self.delegate?.requestedSetupOfApp(self.app!)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var appImageView: UIImageView!
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var appDescriptionLabel: UILabel!
    @IBOutlet private weak var addAppButton: UIButton!
    
    // MARK: - Set up cell
    
    static func setUpCell(indexPath: IndexPath, app: HATApplicationObject, collectionView: UICollectionView, delegate: ExploreAppsDelegate) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appsCell", for: indexPath) as? ExploreAppsCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "appsCell", for: indexPath)
        }
        
        cell.appNameLabel.text = app.application.info.name
        cell.appDescriptionLabel.text = app.application.info.headline
        cell.app = app
        cell.indexPath = indexPath
        cell.delegate = delegate
        
        cell.appImageView.layer.masksToBounds = true
        cell.appImageView.layer.cornerRadius = cell.appImageView.frame.width / 2
        
        cell.getAppLogo(app: app, cell: cell)
        ApplicationConnectionState.updateStatusCellButton(cell.addAppButton, basedOn: app)

        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    // MARK: - Get app logo
    
    private func getAppLogo(app: HATApplicationObject, cell: ExploreAppsCollectionViewCell) {
        
        if let url: URL = URL(string: app.application.info.graphics.logo.normal) {
            
            DispatchQueue.main.async {
                
                let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.addActivityIndicator(onView: cell.appImageView)
                cell.appImageView.cacheImage(resource: url, placeholder: nil, userDomain: cell.userDomain, progressBlock: nil, completionHandler: { image, error, cacheType, url in
                    
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                })
            }
        }
    }
}
