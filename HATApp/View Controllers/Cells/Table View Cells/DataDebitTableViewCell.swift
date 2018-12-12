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

internal class DataDebitTableViewCell: UITableViewCell, UserCredentialsProtocol {

    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the title label
    @IBOutlet private weak var debitTitleLabel: UILabel!
    /// An IBOutlet for handling the expiry date label
    @IBOutlet private weak var debitExpiryDateLabel: UILabel!
    @IBOutlet private weak var dataDebitVendorLabel: UILabel!
    /// An IBOutlet for handling the debit image
    @IBOutlet private weak var debitImageView: UIImageView!
    /// An IBOutlet for handling the main UIView.
    @IBOutlet private weak var mainView: UIView!
    
    // MARK: - View Controller funtions
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Set up cell
    
    /**
     Sets up the cell according to the model passed in
     
     - parameter cell: The cell to set up
     - parameter dataDebit: The dataDebit model to user in order to set up the cel
     
     - returns: A cell that has been set up according to the model passed in
     */
    func setUpCell(cell: DataDebitTableViewCell, dataDebit: DataDebitObject) -> DataDebitTableViewCell {
        
        cell.mainView.layer.cornerRadius = 5
        cell.debitImageView.layer.cornerRadius = cell.debitImageView.frame.width / 2
        cell.debitImageView.layer.masksToBounds = true
        cell.setTitle(dataDebit.dataDebitKey)
        cell.setExpiryDate(dataDebit)
        cell.downloadDataDebitImage(dataDebit: dataDebit)
        cell.setVendor(dataDebit)
        
        return cell
    }
    
    private func downloadDataDebitImage(dataDebit: DataDebitObject) {
        
        guard let url = URL(string: dataDebit.requestClientLogoUrl) else {
            
            self.debitImageView.image = UIImage(named: ImageNamesConstants.dataDebits)
            return
        }
        
        self.debitImageView.cacheImage(
            resource: url,
            placeholder: nil,
            userDomain: self.userDomain,
            progressBlock: nil,
            completionHandler: { [weak self] image, error, _, _ in
                
                if image == nil || error != nil {
                    
                    self?.debitImageView.image = UIImage(named: ImageNamesConstants.dataDebits)
                }
        })
    }
    
    /**
     Sets the title of the data debit
     
     - parameter title: The title of the data debit
     */
    func setTitle(_ title: String) {
        
        self.debitTitleLabel.text = title
    }
    
    /**
     Sets the expiryDate label according to the date passed in and the user's time zone and region
     
     - parameter date: The expiry date as an ISO string
     */
    func setExpiryDate(_ dataDebit: DataDebitObject) {
        
        let endDate: String?
        if dataDebit.permissionsActive != nil {
            
            endDate = dataDebit.permissionsActive!.end
        } else {
            
            endDate = dataDebit.permissionsLatest.end
        }
        guard let date: Date = HATFormatterHelper.formatStringToDate(string: endDate ?? "") else {
            
            if dataDebit.active {
               
                self.debitExpiryDateLabel.text = "Active"
            } else {
                
                self.debitExpiryDateLabel.text = "Expired"
            }
            
            return
        }
        
        let dateString = FormatterManager.formatDateStringToUsersDefinedDate(date: date, dateStyle: .short, timeStyle: .short)
        
        if dataDebit.active {
            
            self.debitExpiryDateLabel.text = "Active until \(dateString)"

        } else {
            
            self.debitExpiryDateLabel.text = "Expired on \(dateString)"
        }
    }
    
    /**
     Sets the vendor label according to the date passed in and the user's time zone and region
     
     - parameter date: The expiry date as an ISO string
     */
    func setVendor(_ dataDebit: DataDebitObject) {
        
        self.dataDebitVendorLabel.text = "by \(dataDebit.requestClientName)"
    }

}
