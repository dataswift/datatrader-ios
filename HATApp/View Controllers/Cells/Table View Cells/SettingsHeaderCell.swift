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

internal class SettingsHeaderCell: UITableViewCell {
    
    // MARK: - IBOutlet

    /// An IBOutlet to handle the header label
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var mainBlueView: UIView!
    
    // MARK: - View Controller methods
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Set up cell
    
    /**
     Sets up the cell according to our needs
     
     - parameter cell: The cell to set up
     - parameter headerTitle: The header title to show in cell
     
     - returns: The cell set up according the to the parameters
     */
    func setUpCell(cell: SettingsHeaderCell, headerTitle: String?, roundTopCorners: Bool? = false) -> SettingsHeaderCell {
        
        cell.headerLabel.text = headerTitle
        if roundTopCorners! && self.mainBlueView != nil {
            
            self.mainBlueView = self.mainBlueView.roundCorners(roundingCorners: [.topLeft, .topRight], cornerRadious: 5, bounds: self.mainBlueView.bounds)
        }
        return cell
    }

}
