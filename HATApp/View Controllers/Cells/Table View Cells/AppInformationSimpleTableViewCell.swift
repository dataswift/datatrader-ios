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

class AppInformationSimpleTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Table view delegate

    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Set up cell
    
    class func setUp(tableView: UITableView, indexPath: IndexPath, title: String, subtitle: String) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.toolInformationSimpleCell, for: indexPath) as? AppInformationSimpleTableViewCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.toolInformationSimpleCell, for: indexPath)
        }
        
        cell.selectionStyle = .none
        cell.titleLabel.text = title
        cell.subtitleLabel.text = subtitle
        
        return cell
    }

}
