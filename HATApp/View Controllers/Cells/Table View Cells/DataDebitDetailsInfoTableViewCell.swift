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

class DataDebitDetailsInfoTableViewCell: UITableViewCell, UserCredentialsProtocol {

    // MARK: - IBOUtlets
    
    /// An IBOutlet for the main white UIView. Used in order to round the corners and add shadow
    @IBOutlet private weak var mainView: UIView!
    /// An IBOutlet to show the data debit name in a UILabel
    @IBOutlet private weak var dataDebitNameLabel: UILabel!
    /// An IBOutlet to show the data debit description in a UILabel
    @IBOutlet private weak var dataDebitDescriptionLabel: UILabel!
    /// An IBOutlet to show the data debit status in a UIButton
    @IBOutlet private weak var dataDebitStatusButton: UIButton!
    /// An IBOutlet to show the data debit ImageView in a UIImageView
    @IBOutlet private weak var dataDebitImageView: UIImageView!
    /// An IBOutlet to show the data debit start date in a UILabel
    @IBOutlet private weak var dataDebitStartDateLabel: UILabel!
    /// An IBOutlet to show the data debit end date in a UILabel
    @IBOutlet private weak var dataDebitEndDateLabel: UILabel!
    /// An IBOutlet to hide the arrow between the start and end UILabels
    @IBOutlet private weak var dateArrowImageView: UIImageView!
    
    // MARK: - TableViewCell methods
    
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
     
     - returns: A set up DataDebitDetailsInfoTableViewCell if the checks are ok or a dequed cell from the tableView
     */
    static func setUpCell(tableView: UITableView, indexPath: IndexPath, dataDebit: DataDebitObject?) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.dataDebitDetailsInfoCell, for: indexPath) as? DataDebitDetailsInfoTableViewCell,
            dataDebit != nil {
            
            cell.setupUI(dataDebit: dataDebit!)
            cell.selectionStyle = .none
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.dataDebitDetailsInfoCell, for: indexPath)
    }
    
    // MARK: - Set up UI
    
    /**
     This is the main function used to set up the UI
     
     - parameter dataDebit: The data debit object to use while setting up the UI
     */
    private func setupUI(dataDebit: DataDebitObject) {
        
        self.addShadowAndRoundCorners()
        self.updateLabels(dataDebit: dataDebit)
        self.downloadDataDebitImage(dataDebit: dataDebit)
        self.updateButtonState(dataDebit: dataDebit)
    }
    
    /**
     Adds shadow and rounded corners in mainView IBOutlet and dataDebitImageView IBOutlet
     */
    private func addShadowAndRoundCorners() {
        
        self.mainView.layer.cornerRadius = 5
        self.mainView.addShadow(color: .darkGray, shadowRadius: 3, shadowOpacity: 0.6, width: 1, height: 0)
        
        self.dataDebitImageView.layer.masksToBounds = true
        self.dataDebitImageView.layer.cornerRadius = self.dataDebitImageView.frame.width / 2
        self.dataDebitImageView.addBorder(width: 6, color: .white)
    }
    
    // MARK: - Set up Labels
    
    /**
     Updates the name description and date labels
     
     - parameter dataDebit: The data debit object to get the data from
     */
    private func updateLabels(dataDebit: DataDebitObject) {
        
        self.dataDebitNameLabel.text = dataDebit.dataDebitKey
        self.dataDebitDescriptionLabel.text = "Details of your data debit agreement with this provider"
        self.updateDateLabels(dataDebit: dataDebit)
    }
    
    /**
     Updates the date labels from the data debit model
     
     - parameter dataDebit: The data debit object to get the data from
     */
    private func updateDateLabels(dataDebit: DataDebitObject) {
        
        var startDate: String = ""
        var endDate: String = ""
        if dataDebit.permissionsActive?.start == nil || dataDebit.permissionsActive?.start == "" {
            
            if dataDebit.permissionsLatest.start == nil || dataDebit.permissionsLatest.start == "" {
                
                startDate = ""
            } else {
                
                startDate = dataDebit.permissionsLatest.start!
            }
        } else {
            
            startDate = dataDebit.permissionsActive!.start!
        }
        if dataDebit.permissionsActive?.end == nil || dataDebit.permissionsActive?.end == "" {
            
            if dataDebit.permissionsLatest.end == nil || dataDebit.permissionsLatest.end == "" {
                
                endDate = ""
            } else {
                
                endDate = dataDebit.permissionsLatest.end!
            }
        } else {
            
            endDate = dataDebit.permissionsActive!.end!
        }
        
        if startDate == "" && endDate == "" {
            
            self.dataDebitStartDateLabel.text = ""
            self.dataDebitEndDateLabel.text = ""
            self.dateArrowImageView.isHidden = true
        } else if startDate != "" && endDate == "" {
            
            guard let date = FormatterManager.formatStringToDate(string: startDate) else { return }
            let dateString = FormatterManager.formatDateStringToUsersDefinedDate(date: date, dateStyle: .medium, timeStyle: .none).replacingOccurrences(of: "-", with: "")
            
            self.dataDebitStartDateLabel.text = dateString
            self.dateArrowImageView.isHidden = false
            self.dataDebitEndDateLabel.text = "Forever"
        } else if startDate != "" && endDate != "" {
            
            guard let startDate = FormatterManager.formatStringToDate(string: startDate),
                    let endDate = FormatterManager.formatStringToDate(string: endDate) else { return }
            
            let startDateString = FormatterManager.formatDateStringToUsersDefinedDate(date: startDate, dateStyle: .medium, timeStyle: .none).replacingOccurrences(of: "-", with: "")
            let endDateString = FormatterManager.formatDateStringToUsersDefinedDate(date: endDate, dateStyle: .medium, timeStyle: .none).replacingOccurrences(of: "-", with: "")
            
            self.dataDebitStartDateLabel.text = startDateString
            self.dateArrowImageView.isHidden = false
            self.dataDebitEndDateLabel.text = endDateString
        }
    }
    
    // MARK: - Change button state
    
    /**
     Updates the state of the button based on the data debit object
     
     - parameter dataDebit: The data debit object to get the data from
     */
    private func updateButtonState(dataDebit: DataDebitObject) {
        
        self.dataDebitStatusButton.layer.borderWidth = 1
        if dataDebit.active {
            
            self.dataDebitStatusButton.setTitleColor(.hatPasswordGreen, for: .normal)
            self.dataDebitStatusButton.setTitle("Active", for: .normal)
            self.dataDebitStatusButton.layer.borderColor = UIColor.hatPasswordGreen.cgColor
        } else {
            
            guard dataDebit.permissionsLatest.end != nil,
                let date = FormatterManager.formatStringToDate(string: dataDebit.permissionsLatest.end!) else {
                    
                    self.dataDebitStatusButton.setTitleColor(.hatDisabled, for: .normal)
                    self.dataDebitStatusButton.setTitle("Expired", for: .normal)
                    self.dataDebitStatusButton.layer.borderColor = UIColor.hatDisabled.cgColor
                    return
            }
            
            if date < Date() {
                
                self.dataDebitStatusButton.setTitleColor(.hatDisabled, for: .normal)
                self.dataDebitStatusButton.setTitle("Expired", for: .normal)
                self.dataDebitStatusButton.layer.borderColor = UIColor.hatDisabled.cgColor
            } else {
                
                self.dataDebitStatusButton.setTitleColor(.hatDisabled, for: .normal)
                self.dataDebitStatusButton.setTitle("Inactive", for: .normal)
                self.dataDebitStatusButton.layer.borderColor = UIColor.hatDisabled.cgColor
            }
        }
    }
    
    // MARK: - Download Data Debit image
    
    /**
     Downloads the data debit image
     
     - parameter dataDebit: The data debit object to get the data from
     */
    private func downloadDataDebitImage(dataDebit: DataDebitObject) {
        
        guard let url = URL(string: dataDebit.requestClientLogoUrl) else { return }
        
        self.dataDebitImageView.cacheImage(
            resource: url,
            placeholder: nil,
            userDomain: self.userDomain,
            progressBlock: nil,
            completionHandler: { [weak self] image, error, _, _ in
                
                if image == nil || error != nil {
                    
                    self?.dataDebitImageView.image = UIImage(named: ImageNamesConstants.dataDebits)
                }
        })
    }

}
