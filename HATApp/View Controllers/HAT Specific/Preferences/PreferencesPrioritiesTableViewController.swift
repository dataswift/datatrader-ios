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

class PreferencesPrioritiesTableViewController: UITableViewController, NewPrioritySelectedDelegate, UserCredentialsProtocol, LoadingPopUpDelegateProtocol {
    
    var loadingPopUp: LoadingScreenViewController?
    
    func showPopUp(message: String, buttonTitle: String?, buttonAction: (() -> Void)?, selfDissmising: Bool, fromY: CGFloat?) {
        
        guard let popUp: LoadingScreenViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerNames.loadingView) as? LoadingScreenViewController,
            self.loadingPopUp == nil else { return }
        
        var fromY = fromY
        if fromY == nil {
            
            fromY = self.view.bounds.maxY
        }
        
        popUp.view.frame = CGRect(x: 0, y: self.view.bounds.maxY + 48, width: self.view.bounds.width, height: 48)
        self.loadingPopUp = popUp
        self.view.addSubview(self.loadingPopUp!.view)
        self.loadingPopUp?.roundCorners()
        self.loadingPopUp?.setMessage(message)
        self.loadingPopUp?.setButtonTitle(buttonTitle)
        self.loadingPopUp?.completionAction = buttonAction
        
        if buttonTitle == nil {
            
            self.loadingPopUp?.setButtonHidden(true)
        }
        
        // Auto hide if no completionAction was provided and the selfDissmising flag is true
        if self.loadingPopUp?.completionAction == nil && selfDissmising == true {
            
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { [weak self] _ in
                
                self?.dismissPopUp(completion: nil)
            })
        }
        
        // Animate the pop up
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                
                guard let weakSelf = self else { return }
                weakSelf.loadingPopUp?.view.frame = CGRect(x: 0, y: fromY! - 68, width: weakSelf.view.bounds.width, height: 48)
            },
            completion: nil)
    }
    
    func dismissPopUp(completion: (() -> Void)?) {
        
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                
                guard let weakSelf = self else { return }
                weakSelf.loadingPopUp?.view.frame = CGRect(x: 0, y: weakSelf.view.bounds.maxY + 68, width: weakSelf.view.bounds.width, height: 48)
            },
            completion: { [weak self] _ in
                
                self?.loadingPopUp?.removeViewController()
                self?.loadingPopUp = nil
                completion?()
            }
        )
    }

    func newPrioritySelected(indexPath: IndexPath, position: Int) {
        
        self.prioritiesSelection[self.rows[indexPath.section][indexPath.row]] = position
    }
    
    private var sections = ["Please indicate how important from 1 (not at all) to 5 (very much)"]
    private var rows = [["Food shopping", "Hydrating properly", "Cooking and eating healthier meals", "Healthier desserts", "Squeezing physical activity into my schedule", "Workout motivation", "Maximaze my workout results", "Increasing physical activity", "Improve my sleep habits", "Manage my stress", "Moderation and balancing my lifestyle", "Personal habits", "My own behaviour for happiness", "Interpersonal relationships and happiness", "Buying from ethical companies", "Controlling my spending", "Budgeting wisely", "unixTimeStamp"]]
    private let initValues: [Int] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, Int(Date().timeIntervalSince1970)]
    private var prioritiesSelection: [String: Int] = [:]

    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.prioritiesSelection["unixTimeStamp"] = Int(Date().timeIntervalSince1970)
        self.showPopUp(message: "Saving...", buttonTitle: nil, buttonAction: nil, selfDissmising: false, fromY: nil)
        HATAccountService.createTableValue(
            userToken: self.userToken,
            userDomain: self.userDomain,
            namespace: "datatrader",
            scope: "priorities",
            parameters: self.prioritiesSelection,
            successCallback: { [weak self] json, token in
                
                self?.dismissPopUp(completion: nil)
            },
            errorCallback: failedReceivingPriorities)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let zipped = zip(rows[0], initValues)
        self.prioritiesSelection = Dictionary(uniqueKeysWithValues: zipped)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.getPriorities()
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.saveButtonAction(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.rows[section].count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return PreferenciesPrioritiesTableViewCell.setUpCell(tableView: tableView, indexPath: indexPath, title: self.rows[indexPath.section][indexPath.row], selection: self.prioritiesSelection[self.rows[indexPath.section][indexPath.row]], delegate: self)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.preferencesPrioritiesHeaderCell)
        
        cell?.textLabel?.text = self.sections[section]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    private func getPriorities() {
        
        self.showPopUp(message: "Fetching priorities", buttonTitle: nil, buttonAction: nil, selfDissmising: false, fromY: nil)
        HATAccountService.getHatTableValues(
            token: self.userToken,
            userDomain: self.userDomain,
            namespace: "datatrader",
            scope: "priorities",
            parameters: ["take": "1", "orderBy": "unixTimeStamp", "ordering": "descending"],
            successCallback: { [weak self] jsonArray, newToken in
                
                self?.dismissPopUp(completion: nil)
                if !jsonArray.isEmpty, let tempDictionary = jsonArray[0].dictionary?["data"]?.dictionaryObject as? [String: Int] {
                    
                    self?.prioritiesReceived(priorities: tempDictionary, newUserToken: newToken)
                }
            },
            errorCallback: failedReceivingPriorities)
    }
    
    private func prioritiesReceived(priorities: [String: Int], newUserToken: String?) {
        
        self.dismissPopUp(completion: nil)
        self.prioritiesSelection = priorities
        self.prioritiesSelection["unixTimeStamp"] = Int(Date().timeIntervalSince1970)
        self.tableView.reloadData()
    }
    
    private func failedReceivingPriorities(error: HATTableError) {
        
        self.dismissPopUp(completion: nil)
    }

}
