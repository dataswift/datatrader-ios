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

class WeeklyInsightTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var plugImageView: UIImageView!
    @IBOutlet private weak var plugNameLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    // MARK: - tableCiewCll functions
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Set up
    
    class func setUp(tableView: UITableView, indexPath: IndexPath, nestedStructure: HATFeedContentNestedObject, source: String) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.weeklyInsightsTableViewCell, for: indexPath) as? WeeklyInsightTableViewCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.weeklyInsightsTableViewCell, for: indexPath)
        }
        
        cell.setUpUI(nestedStructure: nestedStructure, source: source)
        
        return cell
    }
    
    private func setUpUI(nestedStructure: HATFeedContentNestedObject, source: String) {
        
        self.plugNameLabel.text = nestedStructure.content
        self.countLabel.text = nestedStructure.badge
        self.plugImageView.setSocialIcon(source: source)
    }
}
