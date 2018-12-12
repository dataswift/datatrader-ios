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

class PreferencesProfileTableViewController: UITableViewController, UserCredentialsProtocol, LoadingPopUpDelegateProtocol {
    
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
    
    private var profile: ShapeProfileObject?
    private let sections: [String] = ["Education", "Info", "Locale", "Employment Status", "Living info"]
    private let rows: [[String]] = [["What is the highest academic qualification?"], ["Date of birth", "Gender", "Income group"], ["City", "State/County", "Country"], ["Employment status"], ["Relationship status", "Type of accomodation", "Living situation", "How many usually live in your household?", "How many children do you have?", "Do you have any additional dependents"]]
    private let answers: [String: [String]] = ["What is the highest academic qualification?": ["GCSE/O levels", "High School/A levels", "Bachelors degree", "Masters degree", "Doctorate", "Do not want to say"],
                                            "Date of birth": ["Date"],
                                            "Gender": ["Do not want to say", "Male", "Female", "Trans"],
                                            "Income group": ["<£20,000", "£20,001 - £40,000", "£40,001 - £100,000", "£100,001+"],
                                            "City": ["City"],
                                            "State/County": ["State/County"],
                                            "Country": ["Country"],
                                            "Employment status": ["Employed", "Self employed", "Unemployed", "Student", "Do not want to say"],
                                            "Relationship status": ["Married", "Engaged", "Living together", "Single", "Divorced", "Widowed", "Do not want to say"],
                                            "Type of accomodation": ["Detached house", "Flat", "Semi-detached", "Terraced", "End terrace", "Cottage", "Bungalow", "Do not want to say"],
                                            "Living situation": ["Own a home", "Renting", "Living with parents", "Homeless", "Do not want to say"],
                                            "How many usually live in your household?": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "Do not want to say"],
                                            "How many children do you have?": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "Do not want to say"],
                                            "Do you have any additional dependents": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "Do not want to say"]]
    // MARK: - IBAction
    
    @IBAction func saveButtonAction(_ sender: Any) {
       
        self.postProfile()
    }
    
    // MARK: - View Controller methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.profile = ShapeProfileObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.getProfile()
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.postProfile()
    }
    
    private func postProfile() {
        
        self.showPopUp(message: "Saving...", buttonTitle: nil, buttonAction: nil, selfDissmising: false, fromY: nil)

        self.profile?.dateCreated = Int(Date().timeIntervalSince1970)
        ShapeNetworkManager.postProfile(
            userDomain: self.userDomain,
            userToken: self.userToken,
            profile: self.profile!,
            successCallback: { [weak self] updated, newToken in
                
                self?.dismissPopUp(completion: nil)
            },
            failCallback: errorFetchingProfile)
    }
    
    private func getProfile() {
        
        self.showPopUp(message: "Fetching profile...", buttonTitle: nil, buttonAction: nil, selfDissmising: false, fromY: nil)

        ShapeNetworkManager.getProfile(
            userDomain: self.userDomain,
            userToken: self.userToken,
            successCallback: profileReceived,
            failCallback: errorFetchingProfile)
    }
    
    private func profileReceived(profile: ShapeProfileObject, newUserToken: String?) {
        
        self.dismissPopUp(completion: nil)
        self.profile = profile
        self.profile?.dateCreated = Int(Date().timeIntervalSince1970)
        self.tableView.reloadData()
    }
    
    private func errorFetchingProfile(error: HATTableError) {
        
        self.dismissPopUp(completion: nil)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.rows[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return PreferencesProfileTableViewCell.setUpCell(tableView: tableView, indexPath: indexPath, heading: self.rows[indexPath.section][indexPath.row], profile: self.profile!, answers: self.answers[self.rows[indexPath.section][indexPath.row]])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.preferencesProfileHeaderCell)
        
        cell?.textLabel?.text = self.sections[section]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }

}
