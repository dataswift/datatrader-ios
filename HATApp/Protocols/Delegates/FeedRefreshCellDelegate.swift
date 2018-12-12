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

// MARK: Protocol

protocol FeedRefreshCellDelegate: class {
    
    // MARK: - Protocol's functions

    /**
     Sends a resize request to the tableview that holds that cell
     
     - parameter indexPath: The indexPath of the cell to resize
     - parameter cell: The cell to resize
     */
    func resizeCellAt(indexPath: IndexPath, cell: UICollectionViewCell)
    
    /**
     Show more button clicked. Load the rest of the cells that are hidden
     
     - parameter indexPath: The index path of the cell that has been clicked
     - parameter cell: The cell that has been clicked
     */
    func showMoreButtonClicked(indexPath: IndexPath, cell: UICollectionViewCell)
}
