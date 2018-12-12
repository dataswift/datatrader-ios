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

enum DataDebitDetailsSections: String {
    
    case dataDebitInfo
    case description
    case purpose
    case requirements
    case application
    case termsAndConditions
}

class DataDebitsDetailsViewController: HATUIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewResizeDelegate {
    
    func resizeCellAt(indexPath: IndexPath) {
        
        self.resizedCells.insert(indexPath)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var moreButton: UIButton!
    
    // MARK: - IBAction
    
    @IBAction func moreButtonAction(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let disableDataDebit = UIAlertAction(title: "Disable data debit", style: .destructive, handler: { [weak self] _ in
            
            guard let weakSelf = self else { return }
            
            weakSelf.showPopUp(message: "Disabling, please wait..", buttonTitle: nil, buttonAction: nil)
            HATDataDebitsService.disableDataDebit(
                dataDebitID: weakSelf.dataDebit!.dataDebitKey,
                userToken: weakSelf.userToken,
                userDomain: weakSelf.userDomain,
                succesfulCallBack: {dataDebit, newUserToken in
                    
                    weakSelf.dismissPopUp()
                },
                failCallBack: {error in
                    
                    weakSelf.dismissPopUp()
                }
            )
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addActions(actions: [disableDataDebit, cancelAction])
        actionSheet.addiPadSupport(barButtonItem: self.navigationItem.rightBarButtonItem!, sourceView: self.moreButton)
        
        // present the action Sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Variables
    
    var resizedCells: Set<IndexPath> = []
    var dataDebit: DataDebitObject?
    private var tableSections: [DataDebitDetailsSections] = []
    private var selectedAppInfo: HATApplicationObject?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.calculateNumberOfSectionsForDataDebit()
        
        guard self.dataDebit != nil else { return }
        
        if !self.dataDebit!.active {
            
            self.moreButton.isHidden = true
        }
    }
    
    private func calculateNumberOfSectionsForDataDebit() {
        
        guard self.dataDebit != nil else { return }
        
        // data debit info always there
        tableSections.append(.dataDebitInfo)
        
        let permissions: DataDebitPermissionsObject
        if let activePermissions = self.dataDebit?.permissionsActive {
            
            permissions = activePermissions
        } else {
            
            permissions = self.dataDebit!.permissionsLatest
        }
        
        // always there
        tableSections.append(.description)
        
        if permissions.purpose != nil {
            
            tableSections.append(.purpose)
        }
        
        // always there
        tableSections.append(.requirements)
        
        let network = NetworkManager()
        network.checkState()
        
        if self.dataDebit?.requestApplicationId != nil && network.state == .online {
            
            tableSections.append(.application)
        }
        
        // always there
        tableSections.append(.termsAndConditions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setNavigationBarColorToClear()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableSections[indexPath.row] == .dataDebitInfo {
            
            return DataDebitDetailsInfoTableViewCell.setUpCell(tableView: tableView, indexPath: indexPath, dataDebit: dataDebit)
        } else if tableSections[indexPath.row] == .termsAndConditions {
            
            return DataDebitPrivacyPolicyTableViewCell.setUpCell(tableView: tableView, indexPath: indexPath, dataDebit: dataDebit, delegate: self)
        } else if tableSections[indexPath.row] == .application {
            
            return DataDebitsApplicationInfoTableViewCell.setUp(tableView: tableView, indexPath: indexPath, dataDebit: dataDebit)
        }
        
        return DataDebitDetailsTableViewCell.setUpCell(
            tableView: tableView,
            indexPath: indexPath,
            delegate: self,
            isCellExpanded: self.resizedCells.contains(indexPath),
            dataDebit: dataDebit,
            cellType: tableSections[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let appID = self.dataDebit?.requestApplicationId, self.tableSections[indexPath.row] == .application else { return }
        
        HATExternalAppsService.getAppInfo(
            userToken: userToken,
            userDomain: userDomain,
            applicationId: appID,
            completion: appInfoReceived,
            failCallBack: failedFetchingAppInfo)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 410
        }

        return UITableView.automaticDimension
    }
    
    private func appInfoReceived(appInfo: HATApplicationObject, newUserToken: String?) {
        
        self.selectedAppInfo = appInfo
        
        //self.performSegue(withIdentifier: SeguesConstants.dataDebitToAppDetailsSegue, sender: self)
    }
    
    private func failedFetchingAppInfo(error: HATTableError) {
        
    }

}
