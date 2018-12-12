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

class AppInformationImageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoImageView: UIImageView!
    
    // MARK: - Tableview delegate
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Setup cell

    class func setUp(tableView: UITableView, indexPath: IndexPath, title: String) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.toolInformationImageCell, for: indexPath) as? AppInformationImageTableViewCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.toolInformationImageCell, for: indexPath)
        }
        
        cell.selectionStyle = .none
        cell.titleLabel.text = title
        cell.infoImageView.image = UIImage(named: ImageNamesConstants.openInNewWindowGray)
        
        return cell
    }
}
