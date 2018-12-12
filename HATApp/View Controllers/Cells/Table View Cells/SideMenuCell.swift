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

internal class SideMenuCell: UITableViewCell {
    
    // MARK: - Variables

    /// The name of the view as seen in navigation bar
    private var labelName: String = ""
    /// The name of the viewController in Storyboard, restoration ID
    private var viewControllerName: String = ""
    
    // MARK: - IBOutlets
    
    /// An IBoutlet holding a reference to the label
    @IBOutlet private weak var label: UILabel!
    
    // MARK: - View Controller functions
    
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
     - parameter name: The name of the view
     - parameter viewControllerName: The name of the viewController in storyboard, restorationID

     - returns: The cell set up according the to the parameters
     */
    func setUpCell(cell: SideMenuCell, name: String?, viewControllerName: String?) -> SideMenuCell {
        
        guard let name: String = name, let viewControllerName: String = viewControllerName else {
            
            return cell
        }
        
        let view = UIView()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        cell.selectedBackgroundView = view
        cell.labelName = name
        cell.label.text = name
        cell.viewControllerName = viewControllerName
        
        return cell
    }

}
