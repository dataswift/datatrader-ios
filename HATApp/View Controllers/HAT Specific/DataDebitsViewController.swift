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

internal class DataDebitsViewController: HATUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    /// An array of DataDebitObject to save the received objects from hat
    private var dataDebits: [DataDebitObject] = []
    private var selectedDataDebit: DataDebitObject?
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the tableView
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Auto - generated functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        self.getDataDebits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.setNavigationBarColorToClear()
        self.selectedDataDebit = nil
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view funtions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataDebits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: DataDebitTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.dataDebitCell, for: indexPath) as? DataDebitTableViewCell else {
            
            return self.tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.dataDebitCell, for: indexPath)
        }
        
        let index: Int = indexPath.row
        cell.selectionStyle = .none
        let dataDebit: DataDebitObject = self.dataDebits[index]
        return cell.setUpCell(cell: cell, dataDebit: dataDebit)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedDataDebit = self.dataDebits[indexPath.row]
        self.performSegue(withIdentifier: SeguesConstants.dataDebitDetailsSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 106
    }
    
    // MARK: - Get Data debits
    
    /**
     Download data debits from HAT
     */
    private func getDataDebits() {
        
        self.showPopUp(message: "Fetching data debits...", buttonTitle: nil, buttonAction: nil)
        
        HATDataDebitsService.getAvailableDataDebits(
            userToken: userToken,
            userDomain: userDomain,
            succesfulCallBack: gotDataDebits,
            failCallBack: failedGettingDataDebits)
    }
    
    /**
     Save the received objects from hat
     
     - parameter dataDebits: An array of DataDebitObject received from HAT
     - parameter newUserToken: The new user's token returned from HAT
     */
    private func gotDataDebits(dataDebits: [DataDebitObject], newUserToken: String?) {
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newUserToken)

        self.dismissPopUp()
        
        self.dataDebits = dataDebits
        self.tableView.reloadData()
    }
    
    /**
     Logs the error that has occured
     
     - parameter error: A DataPlugError representing the error that has occured whilst trying to download the available data debits
     */
    private func failedGettingDataDebits(error: DataPlugError) {
        
        switch error {
        case .generalError(_, let statusCode, _):
            
            if statusCode == 401 {
                
                self.tokenExpiredLogOut()
            }
        default:
            
            break
        }
        self.dismissPopUp()
        
        print(error)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? DataDebitsDetailsViewController {
            
            vc.dataDebit = self.selectedDataDebit
        }
    }
}
