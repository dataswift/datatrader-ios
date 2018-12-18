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

class PreferencesInterestsTableViewController: UITableViewController, UserCredentialsProtocol, LoadingPopUpDelegateProtocol {
    
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
    
    // MARK: - Variables
    
    /// The sections of the table view
    private let sections: [[String]] = [
        ["Modern European", "Fusion", "Halal", "Chinese", "Thai", "Malaysian", "Vietnamese", "Japanese", "Italian", "Mediterranean", "Mexican", "International"],
        ["Wine", "Whiskey", "Vodka", "Beer", "Cocktails", "Non Alcoholic"],
        ["Games & Puzzles", "Film/Movies", "Series", "Music", "TV", "Gaming", "Sports"],
        ["Fitness", "Exercise", "Fashion And Styles", "Gardening and Landscaping", "Shopping", "Cooking and Recipes", "Travel", "Home furnishings", "Face and Body Care"],
        ["Computer Hardware", "Consumer electronics", "Programming", "Mobile Apps"]]
    /// The headers of the table view
    private let headers: [String] = ["Food",
                                     "Drinks",
                                     "Entertainment",
                                     "Lifestyle",
                                     "Technology"]
    
    /// The dictionary to send to hat
    private var interests: [String: Int] = [
        "Modern European": 0,
        "Fusion": 0,
        "Halal": 0,
        "Chinese": 0,
        "Thai": 0,
        "Malaysian": 0,
        "Vietnamese": 0,
        "Japanese": 0,
        "Italian": 0,
        "Mexican": 0,
        "International": 0,
        "Wine": 0,
        "Whiskey": 0,
        "Vodka": 0,
        "Beer": 0,
        "Gin": 0,
        "Non Alcoholic": 0,
        "Games & Puzzles": 0,
        "Film/Movies": 0,
        "Series": 0,
        "Music": 0,
        "TV": 0,
        "Gaming": 0,
        "Sports": 0,
        "Fitness": 0,
        "Exercise": 0,
        "Fashion And Styles": 0,
        "Gardening and Landscaping": 0,
        "Shopping": 0,
        "Cooking and Recipes": 0,
        "Travel": 0,
        "Home furnishing": 0,
        "Face and Body Care": 0,
        "Computer Hardware": 0,
        "Consumer electronics": 0,
        "Programming": 0,
        "Mobile Apps": 0,
        "unixTimeStamp": Int(Date().timeIntervalSince1970)]
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.interests["unixTimeStamp"] = Int(Date().timeIntervalSince1970)
        self.showPopUp(message: "Saving...", buttonTitle: nil, buttonAction: nil, selfDissmising: false, fromY: nil)
        HATAccountService.createTableValue(
            userToken: self.userToken,
            userDomain: self.userDomain,
            namespace: "datatrader",
            scope: "interests",
            parameters: self.interests,
            successCallback: { [weak self] json, token in
                
                self?.dismissPopUp(completion: nil)
            },
            errorCallback: failedReceivingInterests)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.getInterests()
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.saveButtonAction(self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return self.headers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.sections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.interestsCell, for: indexPath)

        cell.textLabel?.text = self.sections[indexPath.section][indexPath.row]
        cell.selectionStyle = .none
        
        if self.interests[self.sections[indexPath.section][indexPath.row]] == 1 {
            
            cell.accessoryType = .checkmark
        } else {
            
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark
        
        self.interests[cell!.textLabel!.text!] = 1
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .none
        self.interests[cell!.textLabel!.text!] = 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.headers[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackground
        
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 7, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont.oswaldLight(ofSize: 14)
        headerLabel.textColor = UIColor.appBlackColor
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    private func getInterests() {
        
        self.showPopUp(message: "Fetching interests", buttonTitle: nil, buttonAction: nil, selfDissmising: false, fromY: nil)
        
        HATAccountService.getHatTableValues(
            token: self.userToken,
            userDomain: self.userDomain,
            namespace: "datatrader",
            scope: "interests",
            parameters: ["take": "1", "orderBy": "unixTimeStamp", "ordering": "descending"],
            successCallback: { [weak self] jsonArray, newToken in
                
                self?.dismissPopUp(completion: nil)
                if !jsonArray.isEmpty, let tempDictionary = jsonArray[0].dictionary?["data"]?.dictionaryObject as? [String: Int] {
                        
                    self?.interestsReceived(interests: tempDictionary, newUserToken: newToken)
                }
            },
            errorCallback: failedReceivingInterests)
    }
    
    private func interestsReceived(interests: [String: Int], newUserToken: String?) {
        
        self.dismissPopUp(completion: nil)
        self.interests = interests
        self.tableView.reloadData()
    }
    
    private func failedReceivingInterests(error: HATTableError) {
        
        self.dismissPopUp(completion: nil)
    }

}
