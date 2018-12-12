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

class WeeklyInsightsCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    var items: [HATFeedContentNestedObject] = []
    var sources: [String] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var weeklySummaryLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var bannerImageView: UIImageView!
    
    // MARK: - Set up cell
    
    class func setUp(collectionView: UICollectionView, indexPath: IndexPath, feedItem: HATFeedObject) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.feedInsightsCell, for: indexPath) as? WeeklyInsightsCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.feedInsightsCell, for: indexPath)
        }
        
        if let structure = feedItem.content?.nestedStructure {
            
            var rows = 0
            for item in structure {
                
                rows = rows + item.value.count - 1

                for innerNestedItem in item.value {
                    
                    cell.sources.append(item.key)
                    cell.items.append(innerNestedItem)
                }
            }
        }
        
        cell.tableView.dataSource = cell
        cell.tableView.delegate = cell
        cell.tableView.reloadData()
        cell.mainView.layer.cornerRadius = 5
        cell.baseView.addShadow(color: .darkGray, shadowRadius: 3, shadowOpacity: 0.6, width: 1, height: 0)
        cell.dateLabel.text = feedItem.title.subtitle
        cell.weeklySummaryLabel.text = feedItem.title.text

        return cell
    }
    
    // MARK: - Table view functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return WeeklyInsightTableViewCell.setUp(tableView: tableView, indexPath: indexPath, nestedStructure: self.items[indexPath.row], source: self.sources[indexPath.row])
    }
    
    override func prepareForReuse() {
        
        self.items.removeAll()
        self.sources.removeAll()
    }
    
    // MARK - Layout attributes
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        return layoutAttributes
    }
}
