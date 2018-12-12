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

internal class SettingsViewController: HATUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    /// The sections of the table view
    private let sections: [String] = ["App specific", "Hat specific", "Log Out"]
    /// The rows in each section of the table view
    private let rows: [[String]] = [["Tech Support", "Terms of Service"], ["My HAT private data account"], ["Log out"]]
    
    // MARK: - IBOutlets
    
    /// The table view of the view controller
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - IBActions
    
    /**
     Opens the side menu view controller
     
     - parameter sender: The object that called this function
     */
    @IBAction func menuButtonAction(_ sender: Any) {
        
        sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)
    }
    
    // MARK: - View Controller functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let title: String? = self.navigationController?.restorationIdentifier
        self.setTitle(title: title?.uppercased())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.setTitle(title: title?.uppercased())

        // deselect row if selected
        if let index = self.tableView.indexPathForSelectedRow {
            
            self.tableView.deselectRow(at: index, animated: true)
        }
        self.setNavigationBarColorToDarkBlue()
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
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsCell, for: indexPath)
        cell.textLabel?.text = self.rows[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsHeaderView, for: IndexPath(row: 0, section: section)) as? SettingsHeaderCell else {
         
            return self.tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.settingsHeaderView, for: IndexPath(row: 0, section: section))
        }
        
        return cell.setUpCell(cell: cell, headerTitle: self.sections[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.chooseSegueToPerform(indexPath: indexPath)
    }
    
    private func chooseSegueToPerform(indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 1 {
                
                self.performSegue(withIdentifier: SeguesConstants.showTermsSegue, sender: self)
            }
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                self.performSegue(withIdentifier: SeguesConstants.hatSectionsSegue, sender: self)
            }
        } else if indexPath.section == 2 {
            
            HATLoginService.logOut(userDomain: self.userDomain, completion: { [weak self] in
                
                self?.navigateToViewControllerWith(name: ViewControllerNames.loginView)
            })
        }
    }
}
