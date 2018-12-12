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

class DataDebitPrivacyPolicyTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    
    /// The terms URL taken from the dataDebit object during cell set up
    private var termsURL: String? = nil
    /// An optional SafariDelegateProtocol. Used to open the termsURL in Safari on button tap
    weak var safariDelegate: SafariDelegateProtocol?
    
    // MARK: - IBOutlets

    /// An IBoutlet for controling the button
    @IBOutlet private weak var privacyPolicyButton: UIButton!
    
    // MARK: - IBActions
    
    /**
     Checks the termsURL and opens the url in Safari
     
     - parameter sender: The object that called the function
     */
    @IBAction func privacyPolicyButtonAction(_ sender: Any) {
        
        guard termsURL != nil else { return }
        
        safariDelegate?.openInSafari(url: termsURL!, animated: true, completion: nil)
    }
    
    // MARK: - TableView cell functions
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Set up cell
    
    /**
     Sets up a cell and returns it to the table view view controller to show
     
     - parameter tableView: The table view that will show this cell
     - parameter indexPath: The indexPath of the cell in the tableView
     - parameter dataDebit: The data debit model to update the UI from
     - parameter delegate: A SafariDelegateProtocol to open the terms and condition on safari
     
     - returns: A set up DataDebitDetailsInfoTableViewCell if the checks are ok or a dequed cell from the tableView
     */
    static func setUpCell(tableView: UITableView, indexPath: IndexPath, dataDebit: DataDebitObject?, delegate: SafariDelegateProtocol?) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.privacyPolicyCell, for: indexPath) as? DataDebitPrivacyPolicyTableViewCell {
            
            cell.termsURL = dataDebit?.permissionsLatest.termsUrl
            cell.safariDelegate = delegate
            cell.selectionStyle = .none
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.privacyPolicyCell, for: indexPath)
    }
}
