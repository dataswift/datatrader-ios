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

class ToolInformationCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    private var tool: HATToolsObject?
    var delegate: CellDelegate?
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var baseVIew: UIView!
    
    // MARK: - Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            return AppInformationSimpleTableViewCell.setUp(tableView: tableView, indexPath: indexPath, title: "App provider", subtitle: "HAT Data Exchange Ltd")
        } else if indexPath.row == 1 {
            
            return AppInformationImageTableViewCell.setUp(tableView: tableView, indexPath: indexPath, title: "Website")//, subtitle: "www.hatdex.org")
        } else if indexPath.row == 2 {
            
            return AppInformationSimpleTableViewCell.setUp(tableView: tableView, indexPath: indexPath, title: "Country", subtitle: "United Kingdom")
        } else if indexPath.row == 3 {
            
            return AppInformationSimpleTableViewCell.setUp(tableView: tableView, indexPath: indexPath, title: "Version number", subtitle: "1.0.0")
        } else if indexPath.row == 4 {
            
            return AppInformationSimpleTableViewCell.setUp(tableView: tableView, indexPath: indexPath, title: "Last date updated", subtitle: "12/07/2018")
        } else if indexPath.row == 5 {
            
            return AppInformationImageTableViewCell.setUp(tableView: tableView, indexPath: indexPath, title: "Privacy policy")//, subtitle: "https://hatdex.org/privacy-notice-hat-owner-services-and-hat-accounts")
        }
        
        return AppInformationImageTableViewCell.setUp(tableView: tableView, indexPath: indexPath, title: "Support email")//, subtitle: "contact@hatdex.org")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            
            delegate?.openInSafari(url: "https://hatdex.org/")
        } else if indexPath.row == 5 {
            
            delegate?.openInSafari(url: "https://hatdex.org/privacy-notice-hat-owner-services-and-hat-accounts")
        } else if indexPath.row == 6 {
            
            delegate?.sendEmail(address: "contact@hatdex.org")
        }
    }
    
    // MARK: - Setup
    
    class func setUpCell(collectionView: UICollectionView, tool: HATToolsObject, indexPath: IndexPath, delegate: CellDelegate?) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.toolInformationCell, for: indexPath) as? ToolInformationCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.toolInformationCell, for: indexPath)
        }
        
        cell.tool = tool
        cell.baseVIew.layer.cornerRadius = 5
        cell.delegate = delegate
        
        return cell
    }
    
}
