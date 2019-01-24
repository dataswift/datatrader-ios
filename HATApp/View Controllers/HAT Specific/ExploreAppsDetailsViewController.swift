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

import Alamofire
import HatForIOS
import SwiftyJSON

// MARK: Class

class ExploreAppsDetailsViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , CollectionViewCellNotificationDelegate, CustomFeedLayoutDelegate {
    
    // MARK: - CollectionViewCellNotificationDelegate
    
    func openSafari(to url: String) {
        
        self.openInSafari(url: url, animated: true, completion: nil)
    }
    
    func indicatorTabsTapped(selectedIndex: Int) {
        
        self.selectedSection = selectedIndex
        self.dataPreviews.removeAll()
        self.updateCollectionViewFlowLayout()
    }
    
    // MARK: - CustomFeedLayoutDelegate protocol
    
    private struct CellSize {
        
        static let image: CGFloat = 290
        static let info: CGFloat = 335
        static let screenShots: CGFloat = 450
        static let summary: CGFloat = 288
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForSheFeedItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            let state = ApplicationConnectionState.getState(application: self.selectedApp!)
            
            var height: CGFloat = 45
            if state == .failing || state == .needsUpdating || state == .fetching {
                
                height = 90
            }
            if self.selectedApp?.application.info.rating?.score != nil {
                
                height = height + 70
            }
            
            return CellSize.info + height
        }

        if selectedSection == 0 {
            
            if indexPath.row == 1 {
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 64, height: 16))
                label.attributedText = self.selectedApp!.application.info.description.html?.trimString().convertHtml()
                label.font = UIFont.oswaldLight(ofSize: 13)
                label.numberOfLines = 0
                label.isHidden = true
                let tempStringHeight = label.systemLayoutSizeFitting(label.frame.size, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow).height
                
                return tempStringHeight + 60
            } else {
                
                return CellSize.screenShots
            }
        } else {
            
            guard self.dataPreviews.count > indexPath.row - 1 else { return 40 }
            let item = self.dataPreviews[indexPath.row - 1]
            
            let typeHeight: CGFloat
            if item.source == "notables" && !(item.types?.isEmpty ?? true) {
                
                typeHeight = 40
            } else {
                
                typeHeight = 0
            }
            if item.content?.media != nil || item.location != nil {
                
                if item.content?.text != nil {
                    
                    return item.content!.text!.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 100, font: UIFont.oswaldLight(ofSize: 13)) + CellSize.image + typeHeight
                } else {
                    
                    return item.title.text.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 100, font: UIFont.oswaldLight(ofSize: 13)) + CellSize.image + typeHeight
                }
            }
            
            if item.content?.text != nil {
                
                return item.content!.text!.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 100, font: UIFont.oswaldLight(ofSize: 13)) + 100 + typeHeight
            } else {
                
                return item.title.text.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 100, font: UIFont.oswaldLight(ofSize: 13)) + 100 + typeHeight
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var moreButton: UIButton!
    
    // MARK: - Variables
    
    private var selectedSection: Int = 0
    private var dataPreviews: [HATFeedObject] = []
    private var userWantsToSeePermissions: Bool = false
    private var fetchingDataPreviews: Bool = false
    var selectedApp: HATApplicationObject?
    private var selectedFeedItem: HATFeedObject?
    
    // MARK: - IBActions
    
    @IBAction func goToAppButtonAction(_ sender: Any) {
        
        func checkIfAppInstalled() {
            
            if self.selectedApp!.application.setup.kind == "External" && self.selectedApp!.application.setup.iosUrl != nil {

                if let appURL = URL(string: self.selectedApp!.application.setup.iosUrl!) {

                    if UIApplication.shared.canOpenURL(appURL) {

                        let appID = self.selectedApp!.application.id
                        let url = "https://\(self.userDomain)/#/hatlogin?name=\(appID)&redirect=\(appURL)&fallback=\(Auth.urlScheme)://dismisssafari"
                        self.openInSafari(url: url, animated: true, completion: nil)
                    } else {

                        let itunesURL = self.selectedApp!.application.kind.url
                        self.openInSafari(url: itunesURL, animated: true, completion: nil)
                    }
                } else {
                    
                    self.openInSafari(url: self.selectedApp!.application.kind.url, animated: true, completion: nil)
                }
            } else if self.selectedApp?.application.kind.kind == "DataPlug" {
                
                if let appURL = URL(string: self.selectedApp!.application.setup.url!) {
                    
                    if UIApplication.shared.canOpenURL(appURL) {
                        
                        let appID = self.selectedApp!.application.id
                        let url = "https://\(self.userDomain)/#/hatlogin?name=\(appID)&redirect=\(appURL)&fallback=\(Auth.urlScheme)://dismisssafari"
                        self.openInSafari(url: url, animated: true, completion: nil)
                    } else {
                        
                        let itunesURL = self.selectedApp!.application.kind.url
                        self.openInSafari(url: itunesURL, animated: true, completion: nil)
                    }
                }
            } else {

                self.performSegue(withIdentifier: "connectAppFromDetails", sender: self)
            }
        }
        
        if self.selectedApp != nil {
            
            FeedbackManager.vibrateWithHapticIntensity(type: .light)

            if self.selectedApp!.application.setup.onboarding != nil && self.selectedApp!.application.setup.kind != "External" {
                
                OnboardingPageViewController.setupOnboardingScreens(onboardingScreens: self.selectedApp!.application.setup.onboarding!, from: self, completion: checkIfAppInstalled)
            } else {
                
               checkIfAppInstalled()
            }
        }
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        
        self.userWantsToSeePermissions = true

        let appType: String
        if self.selectedApp?.application.kind.kind == "DataPlug" {
            
            appType = "data plug"
        } else {
            
            appType = "application"
        }
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let permissionsAction = UIAlertAction(title: "Show permissions", style: .default, handler: { [weak self] _ in
            
            guard let weakSelf = self else { return }
            
            weakSelf.performSegue(withIdentifier: "connectAppFromDetails", sender: weakSelf)
        })
        let reconfigureApplication = UIAlertAction(title: "Reconfigure \(appType)", style: .default, handler: { [weak self] _ in
            
            guard let weakSelf = self else { return }
            
           weakSelf.goToAppButtonAction(weakSelf)
        })
        let disableAppAction = UIAlertAction(title: "Disable \(appType)", style: .destructive, handler: { [weak self] _ in
            
            guard let weakSelf = self else { return }

            weakSelf.createDressyClassicDialogueAlertWith(
                alertMessage: "This will disconnect \(appType). You can reconnect at any point.",
                alertTitle: "Disconnect \(appType)?",
                okTitle: "Yes",
                cancelTitle: "No",
                proceedCompletion: {
                    
                    weakSelf.showPopUp(message: "Disabling, please wait..", buttonTitle: nil, buttonAction: nil)
                    HATExternalAppsService.disableApplication(
                        appID: weakSelf.selectedApp!.application.id,
                        userDomain: weakSelf.userDomain,
                        userToken: weakSelf.userToken,
                        completion: { [weak self] app, token in
                            
                            guard let weakSelf = self else { return }
                            
                            FeedbackManager.vibrateWithHapticEvent(type: .success)
                            
                            weakSelf.dismissPopUp()
                            HATExternalAppsService.disableApplication(
                                appID: weakSelf.selectedApp!.application.id,
                                userDomain: weakSelf.userDomain,
                                userToken: weakSelf.userToken,
                                completion: weakSelf.appDisabled,
                                failCallBack: weakSelf.errorDisablingApp)
                        },
                        failCallBack: {error in
                            
                            FeedbackManager.vibrateWithHapticEvent(type: .warning)
                            weakSelf.dismissPopUp()
                        }
                    )
                }
            )
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if self.selectedApp!.setup {
            
            actionSheet.addActions(actions: [reconfigureApplication, permissionsAction, disableAppAction, cancelAction])
        } else {
            
            actionSheet.addActions(actions: [permissionsAction, cancelAction])
        }
        actionSheet.addiPadSupport(barButtonItem: self.navigationItem.rightBarButtonItem!, sourceView: self.moreButton)
        
        // present the action Sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func appDisabled(app: HATApplicationObject, newUserToken: String?) {
        
        self.selectedApp = app
        self.updateCollectionViewFlowLayout()
        self.checkForDataPreview()
    }
    
    private func errorDisablingApp(error: HATTableError) {
        
        self.showPopUp(message: "Failed disabling", buttonTitle: nil, buttonAction: nil, selfDissmising: true)
    }
    
    // MARK: - ViewController methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.updateCollectionViewFlowLayout()
        self.checkForDataPreview()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAppStatus), name: NotificationNamesConstants.refreshAppStatus, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.userWantsToSeePermissions = false
        self.navigationController?.navigationBar.tintColor = .white
        self.setNavigationBarColorToClear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    // MARK: - Update UI
    
    private func updateCollectionViewFlowLayout(fetchData: Bool = true) {
        
        if let cvl: DataPreviewsFeedLayout = self.collectionView.collectionViewLayout as? DataPreviewsFeedLayout {

            cvl.emptyCache()
            cvl.delegate = self
            self.collectionView.reloadData()
            cvl.invalidateLayout()
        }
    }
    
    // MARK: - Check for data previews
    
    private func checkForDataPreview() {
        
        if self.selectedApp?.mostRecentData != nil && self.selectedApp != nil && self.selectedSection == 1 {
            
            self.getFromSheFeed()
        } else {
            
            self.dismissPopUp()
        }
    }
    
    private func getFromSheFeed() {
        
        guard self.selectedApp != nil,
            let endpoint = self.selectedApp?.application.status.dataPreviewEndpoint else { return }
        
        self.fetchingDataPreviews = true

        let url = "https://\(userDomain)/api/v2.6/\(endpoint)"
        
        let headers = ["x-auth-token": self.userToken]
        
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.JSONEncoding.default, contentType: ContentType.json, parameters: [:], headers: headers, completion: { [weak self] response in
            
            guard let weakSelf = self else { return }
            weakSelf.fetchingDataPreviews = false

            switch response {
                
            case .error(_, _, _):
                
                weakSelf.dismissPopUp()
            case .isSuccess(let isSuccess, let statusCode, let result, _):

                if isSuccess && statusCode != nil && statusCode! != 401 {
                    
                    if let array = result.array, !(result.array?.isEmpty ?? true) {
                        
                        for item in array {
                            
                            if let obj: HATFeedObject = HATFeedObject.decode(from: item.dictionaryValue) {
                                
                                weakSelf.dataPreviews.append(obj)
                            }
                        }
                    }
                    
                    weakSelf.updateCollectionViewFlowLayout(fetchData: false)
                }
                
                weakSelf.dismissPopUp()
            }
        })
    }
    
    @objc
    private func refreshAppStatus() {
        
        self.showPopUp(message: "Refreshing App...", buttonTitle: nil, buttonAction: nil)
        
        HATExternalAppsService.getAppInfo(
            userToken: self.userToken,
            userDomain: self.userDomain,
            applicationId: self.selectedApp?.application.id ?? "",
            completion: gotAppsFromDex,
            failCallBack: errorGettingApps)
    }
    
    private func gotAppsFromDex(app: HATApplicationObject, newToken: String?) {
        
        self.selectedApp = app
        self.updateCollectionViewFlowLayout()
        
        self.dismissPopUp()
    }
    
    private func errorGettingApps(error: Error) {
        
        self.dismissPopUp { [weak self] in
            
            self?.showPopUp(message: "Failed to refresh", buttonTitle: nil, buttonAction: nil, selfDissmising: true)
        }
    }
    
    // MARK: - CollectionView methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.selectedApp != nil {
            
            if self.selectedSection == 0 {
                
                if !self.selectedApp!.application.info.graphics.screenshots.isEmpty {
                    
                    return 3
                }
                
                return 2
            } else {
                
                return 2
            }
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            let state = ApplicationConnectionState.getState(application: self.selectedApp!)
            
            return AppInfoCollectionViewCell.setupCell(
                indexPath: indexPath,
                collectionView: collectionView,
                name: self.selectedApp!.application.info.name,
                rating: self.selectedApp!.application.info.rating?.score,
                bannerURL: self.selectedApp!.application.info.graphics.banner.normal,
                logoURL: self.selectedApp!.application.info.graphics.logo.normal,
                state: state,
                type: self.selectedApp!.application.kind.kind,
                delegate: self)
        } else {
            
            if self.selectedSection == 0 {
                
                if indexPath.row == 1 {
                    
                    return ExploreAppsImageCollectionViewCell.setupCell(indexPath: indexPath, collectionView: collectionView, description: self.selectedApp!.application.info.description.html!.trimString().convertHtml())
                }
                
                return ExploreAppsDetailsScreenshotCollectionViewCell.setupCell(indexPath: indexPath, collectionView: collectionView, screenshots: self.selectedApp!.application.info.graphics.screenshots)
            } else {
                
                return GoToHatAppDataPreviewCollectionViewCell.setupCell(indexPath: indexPath, collectionView: collectionView, dataplugID: self.selectedApp!.application.id, userDomain: self.userDomain)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ExploreAppsDataCollectionViewCell {
            
            if let media = cell.feedItem?.content?.media {
                
                let mainStoryboard: UIStoryboard = HATUIViewController.getMainStoryboard()
                if let vc: FullScreenImageViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerNames.fullScreenImageViewController) as? FullScreenImageViewController {
                    
                    if let url = media[0].url {
                        
                        vc.url = url
                    } else if let thumbnail = media[0].thumbnail {
                        
                        vc.url = thumbnail
                    }
                    
                    // present the next view controller
                    self.present(vc, animated: true, completion: nil)
                }
            } else if cell.feedItem?.location != nil {
                
                self.selectedFeedItem = cell.feedItem
                self.performSegue(withIdentifier: SeguesConstants.dataPreviewToMapSegue, sender: self)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? AppPermissionsViewController {
            
            vc.app = self.selectedApp
            vc.isUserOnlyCheckingPermissions = self.userWantsToSeePermissions
        }
    }
}
