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

class DataDebitsApplicationInfoTableViewCell: UITableViewCell, UserCredentialsProtocol {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var applicationImageView: UIImageView!
    @IBOutlet private weak var applicationNameLabel: UILabel!
    @IBOutlet private weak var applicationDescriptionLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    
    // MARK: - Table view cell functions
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Set up cell
    
    /**
     Sets up a cell from the data debit model
     
     - parameter tableView: The tableView to use in order to produce the cell we need
     - parameter indexPath: The indexPath of the cell in the tableView
     - parameter dataDebit: The data debit model to user to set up the cell
     
     - returns: A set up cell from the data debit model
     */
    static func setUp(tableView: UITableView, indexPath: IndexPath, dataDebit: DataDebitObject?) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.applicationInfoCell, for: indexPath) as? DataDebitsApplicationInfoTableViewCell,
            dataDebit != nil {
            
            cell.setUpUI(dataDebit: dataDebit!)
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.applicationInfoCell, for: indexPath)
    }
    
    // MARK: - Set up UI
    
    /**
     Sets up the UI of the cell from the data debit model
     
     - parameter dataDebit: The data debit model to user to set up the cell
     */
    private func setUpUI(dataDebit: DataDebitObject) {
        
        self.mainView.layer.cornerRadius = 5
        self.applicationImageView.layer.cornerRadius = self.applicationImageView.frame.width / 2
        self.applicationImageView.layer.masksToBounds = true
        self.applicationNameLabel.text = "Downloading app info"
        self.applicationDescriptionLabel.text = "Please wait"
        
        guard let applicationID = dataDebit.requestApplicationId else { return }
        
        HATExternalAppsService.getAppInfo(
            userToken: self.userToken,
            userDomain: self.userDomain,
            applicationId: applicationID,
            completion: receivedApplicationInfo,
            failCallBack: errorGettingAppInfo)
    }
    
    private func receivedApplicationInfo(appInfo: HATApplicationObject, newUserToken: String?) {
        
        self.applicationNameLabel.text = appInfo.application.info.name
        self.applicationDescriptionLabel.text = "Application used to request debit"
        
        let url = URL(string: appInfo.application.info.graphics.logo.normal)
        self.applicationImageView.cacheImage(resource: url, placeholder: nil, userDomain: self.userDomain, progressBlock: nil, completionHandler: nil)
    }
    
    private func errorGettingAppInfo(error: HATTableError) {
        
    }

}
