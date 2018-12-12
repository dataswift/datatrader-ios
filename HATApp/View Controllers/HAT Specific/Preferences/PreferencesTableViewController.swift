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

import UIKit

// MARK: Class

class PreferencesTableViewController: UITableViewController, SideMenuDelegateProtocol, PresentableSideMenuProtocol {
    
    func dismissSideMenu(sender: UIViewController, dismissView: Bool) {
        
        sideMenuViewController?.dismissAnimation()
        sideMenuViewController = nil
    }
    
    var sideMenuViewController: SideMenuViewController?
    
    
    // MARK: - Variables
    
    private let rows: [[String]] = [["My profile", "My priorities", "My interests"]]
    private let sections: [String] = [""]
    
    @IBAction func menuButtonAction(_ sender: Any) {
        
        sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)

    }
    
    // MARK: - View Controllers

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(self.swipedOpenMenu))
        swipeGesture.direction = .right
        swipeGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeGesture)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.backgroundColor = .navigationBarColor
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .navigationBarColor
    }

    /**
     Opens the side menu
     */
    @objc
    private func swipedOpenMenu() {
        
        sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.rows[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.preferencesCell, for: indexPath)

        cell.textLabel?.text = self.rows[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            self.performSegue(withIdentifier: SeguesConstants.preferencesToProfileSegue, sender: self)
        } else if indexPath.row == 1 {
            
            self.performSegue(withIdentifier: SeguesConstants.preferencesToPrioritiesSegue, sender: self)
        } else if indexPath.row == 2 {
            
            self.performSegue(withIdentifier: SeguesConstants.prioritiesToInterestsSegue, sender: self)
        }
    }

}
