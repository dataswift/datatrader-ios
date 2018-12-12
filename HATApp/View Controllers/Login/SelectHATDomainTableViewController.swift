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

class SelectHATDomainTableViewController: UITableViewController {

    var delegate: UserSelectedClusterDelegate?
    var preselectedCluster: String?
    
    private let domains: [String] = Domains.getAvailableDomains()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.setNavigationBarColorToDarkBlue()
        
        self.tableView.separatorInset = .zero
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.domains.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.domainCell, for: indexPath)

        cell.textLabel?.text = domains[indexPath.row]
        
        if cell.textLabel?.text == self.preselectedCluster {
            
            let image = UIImage(named: ImageNamesConstants.checkmark)
            let imageView = UIImageView(image: image)
            cell.accessoryView = imageView
        }
        cell.selectionStyle = .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let image = UIImage(named: ImageNamesConstants.checkmark)
        let imageView = UIImageView(image: image)
        cell?.accessoryView = imageView
        cell?.textLabel?.textColor = .black
        
        delegate?.userSelectedCluster(domains[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

}
