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

internal class HATSectionsViewController: HATUIViewController, UITableViewDelegate, UITableViewDataSource, CellSwitchStateDelegate {
    
    // MARK: - CellSwitchStateDelegate
    
    func tappedOnSwitchWhileLocationsAreDisabled() {
        
        self.createDressyClassicOKAlertWith(
            alertMessage: "Location service is disabled from iOS Settings. Please enable it there first.",
            alertTitle: "Location service disabled",
            okTitle: "OK",
            proceedCompletion: nil)
    }
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the tableView
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var logOutButton: UIButton!
    
    // MARK: - Variables
    
    private var selectedRowIndex: Int = 0
    /// The sections of the table view
    private let sections: [String] = ["Datatrader settings", "My account", "Version", "Vendor (where you got your HAT)", "HAT Issuer"]
    /// The rows in each section of the table view
    private let rows: [[String]] = [["Tech support", "Terms of service"], ["Go to my HAT app", "See my HAT enabled data", "See my data transaction history", "Reset password"], [""], ["Checking..."], ["Checking..."]]
    
    @IBAction func logOutButonAction(_ sender: Any) {
        
        self.createDressyClassicDialogueAlertWith(
            alertMessage: "This will empty the cache and log you out",
            alertTitle: "Log out?",
            okTitle: "Yes",
            cancelTitle: "No",
            proceedCompletion: { [weak self] in
                
                FeedbackManager.vibrateWithHapticEvent(type: .success)
                HATLoginService.logOut(userDomain: self?.userDomain ?? "", completion: {
                    
                    self?.navigateToViewControllerWith(name: ViewControllerNames.loginView)
                })
            }
        )
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        
        sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)
    }
    
    // MARK: - View Controller functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // remove the top space from the table view
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
        self.logOutButton.layer.cornerRadius = 5
        
        self.addSwipeRecogniserToShowSideMenu(view: self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // deselect row if selected
        if let index = self.tableView.indexPathForSelectedRow {
            
            self.tableView.deselectRow(at: index, animated: true)
        }
        
        self.setNavigationBarColorToDarkBlue(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.rows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.tableView.separatorStyle = .singleLine
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsTitleCell, for: indexPath) as? SettingsTableViewCell else {
                
                return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsTitleCell, for: indexPath)
            }
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.accessoryType = .disclosureIndicator
            
            return SettingsTableViewCell.setUpCell(cell: cell, title: self.rows[indexPath.section][indexPath.row])
        } else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsTitleCell, for: indexPath) as? SettingsTableViewCell else {
                
                return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsTitleCell , for: indexPath)
            }
            
            cell.selectionStyle = .default
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.accessoryType = .disclosureIndicator
            
            return SettingsTableViewCell.setUpCell(cell: cell, title: self.rows[indexPath.section][indexPath.row])
        } else if indexPath.section == 2 && indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsTitleCell, for: indexPath) as? SettingsTableViewCell else {
                
                return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsTitleCell, for: indexPath)
            }
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            cell.accessoryType = .none
            
            return SettingsTableViewCell.setUpCell(cell: cell, title: self.getAppVersion())
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsTitleCell, for: indexPath) as? SettingsTableViewCell else {
                
                return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsTitleCell , for: indexPath)
            }
            cell.selectionStyle = .none
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.accessoryType = .none
            cell.accessoryView = nil
            
            if self.userDomain.contains(".hubat.net") {
                
                if indexPath.section == 4 {
                    
                    return SettingsTableViewCell.setUpCell(cell: cell, title: "DataTraderGive Beta")
                } else {
                    
                    return SettingsTableViewCell.setUpCell(cell: cell, title: "HATLAB")
                }
            } else {
            
                if indexPath.section == 4 {
                    
                    return SettingsTableViewCell.setUpCell(cell: cell, title: "DataTraderGive")
                } else {
                    
                    return SettingsTableViewCell.setUpCell(cell: cell, title: "HAT Data Exchange Ltd.")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRowIndex = indexPath.row
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                self.mail.sendEmail(atAddress: "contact@hatdex.org", onBehalf: self)
                self.tableView.deselectRow(at: indexPath, animated: true)
            } else if indexPath.row == 1 {
                
                self.performSegue(withIdentifier: SeguesConstants.hatAppSettingsToMarkdown, sender: self)
            }
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                if let appURL = URL(string: "hatapp://hatapp"), UIApplication.shared.canOpenURL(appURL) {
                    
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                }
            } else if indexPath.row == 1 {
                
                self.performSegue(withIdentifier: SeguesConstants.dataplugsSegue, sender: self)
            } else if indexPath.row == 2 {
                
                self.performSegue(withIdentifier: SeguesConstants.dataDebitsSegue, sender: self)
            } else if indexPath.row == 3 {
                
                self.performSegue(withIdentifier: SeguesConstants.resetPasswordSegue, sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.hatSectionHeaderView) as? SettingsHeaderCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.hatSectionHeaderView)
        }
        
        return cell.setUpCell(cell: cell, headerTitle: self.sections[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc: MarkdownViewController = segue.destination as? MarkdownViewController {
            
            if self.selectedRowIndex == 3 {
                
                vc.url = TermsURL.termsAndConditions
            } else if self.selectedRowIndex == 4 || self.selectedRowIndex == 6 {
                
                vc.url = TermsURL.privacyPolicy
            }
        }
    }
}
