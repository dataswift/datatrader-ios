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

enum ApplicationPermissionsSections: String {
    
    case profile = "Profile"
    case rolesGranted = "permissions:"
    case permissions = "will have access to:"
}

class AppPermissionsViewController: HATUIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewResizeDelegate {
    
    func resizeCellAt(indexPath: IndexPath) {
        
        self.resizedCells.insert(indexPath)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
    }
    
    var resizedCells: Set<IndexPath> = []
    var app: HATApplicationObject?
    var isUserOnlyCheckingPermissions: Bool = false
    private var sections: [ApplicationPermissionsSections] = []
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var agreeButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    @IBAction func doNotAgreeButtonAction(_ sender: Any) {
        
        if self.navigationController != nil {
            
            self.navigationController?.popViewController(animated: true)
        } else {
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func agreeButtonAction(_ sender: Any) {
        
        if isUserOnlyCheckingPermissions {
            
            self.doNotAgreeButtonAction(sender)
        } else {
            
            guard let appID = app?.application.id else { return }
            
            self.showPopUp(message: "Setting Up \(appID)", buttonTitle: nil, buttonAction: nil)
            
            HATExternalAppsService.setUpApp(
                userToken: self.userToken,
                userDomain: self.userDomain,
                applicationID: appID,
                completion: appSuccessfullySetUp,
                failCallBack: appFailedToSetUp)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.agreeButton.layer.cornerRadius = 5
        
        self.calculateSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        if isUserOnlyCheckingPermissions {
            
            self.cancelButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func calculateSections() {
        
        sections.append(.profile)
        if app?.application.permissions.rolesGranted != nil {
            
            sections.append(.rolesGranted)
        }
        if app?.application.permissions.dataRetrieved != nil {
            
            sections.append(.permissions)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            
            guard let items = app?.application.permissions.rolesGranted.count else {
                
                return 1
            }
            
            return items
        } else if section == 2 {
            
            guard let items = app?.application.permissions.dataRetrieved?.bundle.count else {
                
                return 0
            }
            
            return items
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && indexPath.section == 0 {
            
            return ExploreAppsPermissionsInfoTableViewCell.setUp(tableView: tableView, application: self.app!, indexPath: indexPath, delegate: self)
        } else {
            
            return PermissionsTableViewCell.setUpCell(tableView: tableView, indexPath: indexPath, application: app!, cellType: self.sections[indexPath.section], isCellExpanded: self.resizedCells.contains(indexPath), delegate: self, normalCellHeight: 100)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let headerView = UIView()
            
            headerView.backgroundColor = .clear
            
            return headerView
        } else if section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.permissionsHeaderCell) as? HATHeaderTableViewCell else { return nil }
            
            cell.setHeader(text: "\(self.app?.application.info.name.capitalized ?? "") \(self.sections[section].rawValue)")
            
            return cell.contentView
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.permissionsHeaderCell) as? HATHeaderTableViewCell else { return nil }
            
            cell.setHeader(text: "Data that \(self.app?.application.info.name.capitalized ?? "") have access to: ")
            
            return cell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    // MARK: - Success Set up response
    
    private func appSuccessfullySetUp(app: HATApplicationObject, newUserToken: String?) {
        
        self.dismissPopUp()
        
        if app.setup {
            
            if app.application.setup.kind == "External" && app.application.setup.iosUrl != nil {
                
                if let appURL = URL(string: self.app!.application.setup.iosUrl!) {
                    
                    if UIApplication.shared.canOpenURL(appURL) {
                        
                        let appID = self.app!.application.id
                        let url = "https://\(self.userDomain)/#/hatlogin?name=\(appID)&redirect=\(appURL)&fallback=\(Auth.urlScheme)://dismisssafari"
                        self.openInSafari(url: url, animated: true, completion: nil)
                    } else {
                        
                        let itunesURL = self.app!.application.kind.url
                        self.openInSafari(url: itunesURL, animated: true, completion: nil)
                    }
                } else {
                    
                    self.openInSafari(url: self.app!.application.kind.url, animated: true, completion: nil)
                }
            } else {
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Failed setting up application
    
    private func appFailedToSetUp(error: HATTableError) {
        
        guard let appID = app?.application.id else { return }
        
        self.dismissPopUp { [weak self] in
            
            self?.showPopUp(message: "There was an error trying to setup \(appID)", buttonTitle: nil, buttonAction: nil, selfDissmising: true)
        }
    }
}
