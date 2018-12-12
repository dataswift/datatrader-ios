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

import SwiftyJSON
import HatForIOS

// MARK: Class

internal struct HATDictionary: HATObject {
    
    var hatDictionary: Dictionary<String, String?> = [:]
}

internal class AccountSettingsViewController: HATUIViewController, UITableViewDelegate, UITableViewDataSource, TextViewResizeDelegate, FieldUpdatedDelegate, PhotoPickerDelegate, RefreshControlProtocol, UIScrollViewDelegate {
    
    // MARK: - Variables

    private var isKeyboardActive: Bool = false
    var viewInitiatedFromSettings: Bool = false
    /// The Photo picker used to upload a new photo
    private let photoPicker: ImageManager = ImageManager()
    /// The sections of the table view
    private var shared: Dictionary<String, String>?
    private let sections: [String] = ["", "PUBLIC PROFILE", "SOCIAL", "ABOUT"]
    /// The rows in each section of the table view
    private let rows: [[String]] = [[""], ["Personal info", "firstName", "lastName", "gender", "birthday", "primaryEmail", "secondaryEmail", "mobilePhone", "homePhone"], ["Online", "Facebook", "Twitter", "Linkedin", "Youtube", "Website", "Blog", "Google"], ["About", "title", "story"]]
    private var profile: HATProfileObject?
    private var isDataEdited: Bool = false {
        
        didSet {
            
            self.changeStateOfButton(enabled: true, backgroundColor: .selectionColor, title: "SAVE")
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var backgroundVIewYPosConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomView: UIView!
    
    // MARK: - IBAction

    @IBAction func menuButtonAction(_ sender: Any) {
        
        sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)
    }
    
    @IBAction func saveProfileButtonAction(_ sender: Any) {
        
        FeedbackManager.vibrateWithHapticIntensity(type: .light)
        
        func success() {
            
            self.changeStateOfButton(enabled: false, backgroundColor: .hatDisabled, title: "SAVED")
        }
        
        func imageUploaded(fileID: String?) {
            
            if fileID != nil {
                
                self.imageUploadCompleted(fileID: fileID!)
            }
            let hatObject = HATSyncObject<HATProfileDataObject>.init(url: "https://\(userDomain)/api/v2.6/data/rumpel/profile", object: self.profile!.data, data: nil, dictionary: nil)
            CacheManager<HATProfileObject>.saveObjects(objects: [self.profile!], inCache: "profile", key: "profile")
            CacheManager<HATProfileDataObject>.syncObjects(objects: [hatObject], key: "profile")
            CacheManager<HATProfileDataObject>.checkForUnsyncedObjects(forKey: "profile", userToken: userToken, completion: success)
        }
        
        self.changeStateOfButton(enabled: false, backgroundColor: .hatDisabled, title: "SAVE")
        
        let cells = self.tableView.visibleCells
        for cell in cells {
            
            guard let cell = cell as? ProfileFieldsTableViewCell else {
                
                continue
            }
            
            cell.resignKeyboard()
        }
        
        self.profile?.data.dateCreated = Int(Date().timeIntervalSince1970)
        self.profile?.data.dateCreatedLocal = FormatterManager.formatDateToISO(date: Date())
        self.profile?.data.shared = (self.shared != nil)
        
        if let profileCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileAccountSettingsTableViewCell {
            
            guard let image = profileCell.getProfileImage() else {
                
                return
            }
            CacheManager<HATProfileObject>.saveImages(image: image, inCache: "images", key: "profile")
            CacheManager<HATProfileObject>.syncImage(image: image, key: "profileImage")
        }
        
        // check for image, in new image to sync sync it and execute imageUploaded, else execute imageUploaded in order for the profile object to be executed as well
        CacheManager<HATProfileObject>.checkForUnsyncedImages(forKey: "profileImage", userToken: userToken, userDomain: userDomain, completion: imageUploaded)
        
        HATProfileService.updateStructure(sharedFields: self.shared, userDomain: self.userDomain, userToken: self.userToken)
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
        
        self.tableView.estimatedRowHeight = 44
        
        self.saveButton.layer.cornerRadius = 5

        if self.viewInitiatedFromSettings {
            
            self.navigationItem.leftBarButtonItem = nil
        } else {
            
            self.addSwipeRecogniserToShowSideMenu(view: self.tableView)
        }
        
        self.keyboardManager.view = self.view
        self.keyboardManager.addKeyboardHandling()
        self.keyboardManager.hideKeyboardWhenTappedAround()
        
        self.setTitle(title: "PROFILE")
        self.addRefreshControlTo(self.tableView, target: self, selector: #selector(refreshData), refreshControlColor: .white)
        
        self.getProfile()

        self.changeStateOfButton(enabled: false, backgroundColor: .hatDisabled, title: "SAVED")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.resignKeyboardWhenInBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardActive), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardInactive), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setNavigationBarColorToClear()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        
        super.willMove(toParent: parent)
        
        self.setNavigationBarColorToDarkBlue()
    }
    
    @objc
    private func refreshData() {
        
        func onlineCompletion() {
            
            CacheManager<HATFeedObject>.removeAllObjects(fromCache: "profile")
            CacheManager<HATFeedObject>.removeAllObjects(fromCache: "images")
            self.profile = nil
            self.shared = nil

            self.getProfile()
        }
        
        func offlineCompletion() {
            
            let stopRefreshingAnimation = self.tableView.refreshControl?.endRefreshing
            
            self.createDressyClassicOKAlertWith(
                alertMessage: "Your device is not connected to the internet. Cannot refresh data",
                alertTitle: "No internet connection",
                okTitle: "OK",
                proceedCompletion: {
                    
                    stopRefreshingAnimation?()
                }
            )
        }
        
        NetworkManager().checkState(onlineCompletion: onlineCompletion, offlineCompletion: offlineCompletion)
    }
    
    @objc
    private func keyboardActive() {
        
        self.isKeyboardActive = true
    }
    
    @objc
    private func keyboardInactive() {
        
        self.isKeyboardActive = false
        if let scrollView = self.hatUIViewScrollView {
            
            self.scrollBackgroundImage(offsetPosY: scrollView.contentOffset.y)
        }
    }
    
    @objc
    private func resignKeyboardWhenInBackground() {
        
        self.view.endEditing(true)
        self.view.resignFirstResponder()
        self.tableView.endEditing(true)
        self.tableView.resignFirstResponder()
        self.backgroundImageView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.hatUIViewScrollView = scrollView
        guard !self.isKeyboardActive else { return }
        
        self.scrollBackgroundImage(offsetPosY: scrollView.contentOffset.y)
    }
    
    private func scrollBackgroundImage(offsetPosY: CGFloat) {
        
        guard self.backgroundImageView != nil,
            self.navigationController != nil else { return }
        
        if (self.backgroundImageView.frame.height - (self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.height) - offsetPosY) < 0 {
            
            self.setNavigationBarColorToDarkBlue()
            self.backgroundImageView.isHidden = true
        } else {
            
            self.setNavigationBarColorToClear()
            self.backgroundImageView.isHidden = false
        }
        
        if -offsetPosY <= 0 {
            
            self.backgroundVIewYPosConstraint.constant = -offsetPosY
        } else {
            
            self.backgroundVIewYPosConstraint.constant = 0
        }
    }
    
    // MARK: - Table view functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.profile == nil {
            
            return 0
        }
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.profile == nil {
            
            return 0
        }
        return self.rows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = .clear

        if indexPath.section == 0 && indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.profileAccountSettingsCell, for: indexPath) as? ProfileAccountSettingsTableViewCell else {
                
                return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.profileAccountSettingsCell, for: indexPath)
            }

            return cell.setUpCell(profile: self.profile!, sharedMedia: self.shared, delegate: self, imageViewControllerDelegate: self)
        } else {
            
            if indexPath.row == 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.hatSectionCell, for: indexPath) as? SettingsHeaderCell else {
                    
                    return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.hatSectionCell, for: indexPath)
                }
                
                return cell.setUpCell(cell: cell, headerTitle: self.rows[indexPath.section][indexPath.row], roundTopCorners: true)
            } else if indexPath.section == 3 && indexPath.row == 2 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.accountTextViewFieldCell, for: indexPath) as? ProfileFieldsTableViewCell else {
                    
                    return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.accountTextViewFieldCell, for: indexPath)
                }
                
                return cell.setUpCell(profile: &self.profile, indexPath: indexPath, sharedFields: self.shared, textViewDelegate: self, textFieldDelegate: self, shouldRoundBottomCorners: true)
            } else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.accountFieldCell, for: indexPath) as? ProfileFieldsTableViewCell else {
                    
                    return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.accountFieldCell, for: indexPath)
                }
                
                if (tableView.numberOfRows(inSection: indexPath.section) - 1) == indexPath.row {
                    
                    return cell.setUpCell(profile: &self.profile, indexPath: indexPath, sharedFields: self.shared, textFieldDelegate: self, shouldRoundBottomCorners: true)
                }
                
                return cell.setUpCell(profile: &self.profile, indexPath: indexPath, sharedFields: self.shared, textFieldDelegate: self)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section > 0 && indexPath.row == 0 {
            
            return 60
        } else if (indexPath.section == 0 && indexPath.row == 0) {
            
            return UITableView.automaticDimension
        } else if (indexPath.section == 3 && indexPath.row == 2) {
            
            let text = self.profile?.data.about.body
            let width = UIScreen.main.bounds.width - 114
            let height: CGFloat = 50
            let tempTextView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
            tempTextView.font = UIFont.openSans(ofSize: 14)
            tempTextView.text = text
            
            let calculatedSize = tempTextView.systemLayoutSizeFitting(CGSize(width: width, height: height), withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow).height
            if calculatedSize < 120 {
                
                return 120
            } else {
                
                return calculatedSize
            }
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 0
        }
        
        return 30
    }
    
    // MARK: - Get profile
    
    private func getProfile() {

        self.showPopUp(message: "Fetching Profile Please Wait", buttonTitle: nil, buttonAction: nil, selfDissmising: false, fromY: self.bottomView.frame.minY)

        let getProfile = { [weak self] in
            
            guard let weakSelf = self else {
                
                return
            }
            
            HATProfileService.getProfile(
                userDomain: weakSelf.userDomain,
                userToken: weakSelf.userToken,
                successCallback: weakSelf.receivedProfile,
                failCallback: weakSelf.receivedError)
        }
        
        let getStructure = { [weak self] in
            
            guard let weakSelf = self else {
                
                return
            }
            
            HATProfileService.getPhataStructureBundle(
                userDomain: weakSelf.userDomain,
                userToken: weakSelf.userToken,
                success: weakSelf.receivedStructure,
                fail: weakSelf.receivedErrorGettingBundle)
        }
        
        if let profileResults: [HATProfileObject] = CacheManager<HATProfileObject>.retrieveObjects(fromCache: "profile", forKey: "profile", networkRequest: getProfile) {
            
            self.receivedProfile(profile: profileResults[0], newUserToken: nil)
            
            self.dismissPopUp()
        } else {
            
            getProfile()
        }
        
        if let structureResults: [HATDictionary] = CacheManager<HATDictionary>.retrieveObjects(fromCache: "profile", forKey: "structure", networkRequest: getStructure) {
            
            self.receivedStructure(dict: JSON(structureResults[0].hatDictionary).dictionaryValue)
        } else {
            
            getStructure()
        }
    }
    
    private func receivedProfile(profile: HATProfileObject, newUserToken: String?) {
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newUserToken)

        self.tableView.refreshControl?.endRefreshing()
        self.profile = profile
        
        self.reloadTableView()
        
        if self.shared != nil {
            
            self.dismissPopUp()
        }
        
        CacheManager<HATProfileObject>.saveObjects(objects: [profile], inCache: "profile", key: "profile")
    }
    
    private func receivedStructure(dict: Dictionary<String, JSON>) {
        
        if let dictionary = JSON(dict).dictionaryObject as? Dictionary<String, String> {
            
            self.shared = HATProfileService.mapProfileStructure(returnedDictionary: dictionary)
            self.reloadTableView()
            
            if self.profile != nil {
                
                self.dismissPopUp()
            }
            
            let hatDictionary = HATDictionary(hatDictionary: dictionary)
            
            CacheManager<HATDictionary>.saveObjects(objects: [hatDictionary], inCache: "profile", key: "structure")
        }
    }
    
    private func receivedError(error: HATTableError) {
        
        switch error {
        case .generalError(_, let statusCode, _):
            
            if statusCode == 401 {
                
                self.tokenExpiredLogOut()
            }
        default:
            
            break
        }
        self.dismissPopUp()
        self.dismissUploadingPopUp()
        
        self.profile = HATProfileObject()
        
        self.reloadTableView()
    }
    
    private func receivedErrorGettingBundle(error: HATTableError) {
        
        func bundleCreated(isBundleReady: Bool) {
            
            if isBundleReady {
             
                HATProfileService.getPhataStructureBundle(
                    userDomain: userDomain,
                    userToken: userToken,
                    success: receivedStructure,
                    fail: receivedErrorGettingBundle)
            }
        }
        
        HATProfileService.createPhataStructureBundle(
            userDomain: userDomain,
            userToken: userToken,
            success: bundleCreated,
            fail: receivedErrorGettingBundle)
    }
    
    private func reloadTableView() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
        }
    }
    
    func textViewDidChange(textView: UITextView) {

        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)

        if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 3)) as? ProfileFieldsTableViewCell {
            
            cell.layer.mask = nil
            
            cell.roundCorners()
        }
        
        let indexPathString = "(\(3), \(2))"
        let mapping = HATProfileObject.mapping
        guard let field = mapping[indexPathString] else {
            
            return
        }
        
        self.profile?[keyPath: field.string] = textView.text
        
        self.isDataEdited = true
        let offset: CGPoint = self.tableView.contentOffset

        self.tableView.layoutIfNeeded()
        self.tableView.contentOffset = offset
        
        self.tableView.scrollToRow(at: IndexPath(row: 2, section: 3), at: .bottom, animated: true)
    }
    
    func fieldUpdated(textField: UITextField, indexPath: IndexPath, profile: HATProfileObject, isTextURL: Bool?) {
        
        let indexPathString = "(\(indexPath.section), \(indexPath.row))"
        let mapping = HATProfileObject.mapping
        guard let field = mapping[indexPathString] else {
            
            return
        }
        
        if isTextURL == false {
            
            self.createDressyClassicOKAlertWith(alertMessage: "Please enter a valid URL address like: https://www.example.com", alertTitle: "Invalid address", okTitle: "OK", proceedCompletion: {
                
                textField.text = ""
            })
        } else {
            
            self.profile?[keyPath: field.string] = profile[keyPath: field.string]
            
            self.isDataEdited = true
        }
    }
    
    func buttonStateChanged(dictionary: Dictionary<String, String>) {
        
        let mutableDictionary = NSMutableDictionary(dictionary: self.shared ?? [:])

        for item in dictionary {
            
            if mutableDictionary[item.key] != nil {
                
                mutableDictionary.removeObject(forKey: item.key)
            } else {
                
                mutableDictionary.addEntries(from: dictionary)
            }
        }

        self.shared = mutableDictionary as? Dictionary<String, String>
        self.isDataEdited = true
    }
    
    func didChooseImageWithInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if let profileInfoCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileAccountSettingsTableViewCell {
                
                let imageview = profileInfoCell.getProfileImageView()
                UIView.transition(with: imageview, duration: 10, options: .curveEaseInOut, animations: {
                    
                    profileInfoCell.changeProfileImage(image)
                }, completion: nil)
            }
            
            self.isDataEdited = true
        }
    }
    
    func didFinishWithError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
    }
    
    // MARK: - Change Button State
    
    private func changeStateOfButton(enabled: Bool, backgroundColor: UIColor, title: String) {
        
        self.saveButton.isUserInteractionEnabled = enabled
        self.saveButton.backgroundColor = backgroundColor
        self.saveButton.setTitle(title, for: .normal)
        if enabled {
            
            self.saveButton.setTitleColor(.mainColor, for: .normal)
        } else {
            
            self.saveButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK: - Present Image Picker
    
    func presentImagePicker() {
        
        self.photoPicker.delegate = self
        self.photoPicker.createActionSheet(view: self, sourceRect: self.tableView.visibleCells[0].frame, sourceView: self.tableView.visibleCells[0])
    }
    
    // MARK: - Upload Completed
    
    private func imageUploadCompleted(fileID: String) {
        
        let url = FileURL.convertURL(fileID: fileID, userDomain: userDomain)
        self.profile?.data.dateCreated = Int(Date().timeIntervalSince1970)
        self.profile?.data.dateCreatedLocal = FormatterManager.formatDateToISO(date: Date())
        self.profile?.data.photo.avatar = url
        
        let indexPathString = "(0, 0)"
        self.shared?.updateValue("photo.avatar", forKey: indexPathString)
    }
}
