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

class ToolsDetailsViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CollectionViewCellNotificationDelegate, CustomFeedLayoutDelegate, CellDelegate {
    
    // MARK: - CellDelegate protocol
    
    func openInSafari(url: String) {
        
        self.openSafari(to: url)
    }
    
    func sendEmail(address: String) {
        
        self.mail.sendEmail(atAddress: address, onBehalf: self)
    }
    
    // MARK: - CollectionViewCellNotificationDelegate
    
    func openSafari(to url: String) {
        
        self.openInSafari(url: url, animated: true, completion: nil)
    }
    
    func indicatorTabsTapped(selectedIndex: Int) {
        
        self.selectedSection = selectedIndex
        self.dataPreviews.removeAll()
        self.updateCollectionViewFlowLayout()
    }
    
    // MARK:  - CustomFeedLayoutDelegate protocol
    
    private struct CellSize {
        
        static let image: CGFloat = 290
        static let info: CGFloat = 390
        static let information: CGFloat = 375
        static let screenshots: CGFloat = 450
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForSheFeedItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {

            let state = ApplicationConnectionState.getState(tool: self.selectedTool!)

            var height: CGFloat = 0
            if state == .failing || state == .needsUpdating || state == .fetching {
                
                height = 60
            }
            
            return CellSize.info + height
        }
        
        if selectedSection == 0 {
            
            if indexPath.row == 1 {
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 64, height: 16))
                label.attributedText = self.selectedTool!.info.description.html?.trimString().convertHtml()
                label.font = UIFont.openSans(ofSize: 13)
                label.numberOfLines = 0
                label.isHidden = true
                let tempStringHeight = label.systemLayoutSizeFitting(label.frame.size, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow).height
                
                return tempStringHeight + 60
            } else if indexPath.row == 2 && !(self.selectedTool?.info.graphics.screenshots.isEmpty ?? true) {
                
                return CellSize.screenshots
            }
            
            return CellSize.information
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
                    
                    return item.content!.text!.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 100, font: UIFont.openSans(ofSize: 13)) + CellSize.image + typeHeight
                } else {
                    
                    return item.title.text.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 100, font: UIFont.openSans(ofSize: 13)) + CellSize.image + typeHeight
                }
            }
            
            if item.content?.text != nil {
                
                return item.content!.text!.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 100, font: UIFont.openSans(ofSize: 13)) + 100 + typeHeight
            } else {
                
                return item.title.text.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 100, font: UIFont.openSans(ofSize: 13)) + 100 + typeHeight
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var moreButton: UIButton!
    
    // MARK: - Variables
    
    private var selectedSection: Int = 0
    private var dataPreviews: [HATFeedObject] = []
    private var fetchingDataPreviews: Bool = false
    var selectedTool: HATToolsObject?
    private var selectedFeedItem: HATFeedObject?
    
    // MARK: - IBActions
    
    @IBAction func goToAppButtonAction(_ sender: Any) {
        
        guard self.selectedTool != nil else { return }
        
        if self.selectedTool!.status.available && !self.selectedTool!.status.enabled {
            
            HATToolsService.enableTool(
                toolName: self.selectedTool!.id,
                userDomain: self.userDomain,
                userToken: self.userToken,
                completion: self.toolStatusChanged,
                failCallBack: self.errorInteractingWithTool)
        }
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let disableAppAction = UIAlertAction(title: "Disable Tool", style: .destructive, handler: { [weak self] _ in
            
            guard let weakSelf = self else { return }
            
            weakSelf.createDressyClassicDialogueAlertWith(
                alertMessage: "This will disable this tool. You can reconnect at any point.",
                alertTitle: "Disable tool?",
                okTitle: "Yes",
                cancelTitle: "No",
                proceedCompletion: {
                    
                    weakSelf.showPopUp(message: "Disabling, please wait..", buttonTitle: nil, buttonAction: nil)
                    
                    HATToolsService.disableTool(
                        toolName: weakSelf.selectedTool?.id ?? "",
                        userDomain: weakSelf.userDomain,
                        userToken: weakSelf.userToken,
                        completion: weakSelf.toolStatusChanged,
                        failCallBack: weakSelf.errorInteractingWithTool)
                }
            )
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addActions(actions: [disableAppAction, cancelAction])
        actionSheet.addiPadSupport(barButtonItem: self.navigationItem.rightBarButtonItem!, sourceView: self.moreButton)
        
        // present the action Sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func toolStatusChanged(tool: HATToolsObject, newUserToken: String?) {
        
        if tool.status.enabled {
            
            HATToolsService.triggerToolUpdate(
                toolName: tool.id,
                userDomain: self.userDomain,
                userToken: self.userToken,
                completion: { _, _ in return },
                failCallBack: self.errorInteractingWithTool)
        }
        self.selectedTool = tool
        self.updateCollectionViewFlowLayout()
        self.checkForDataPreview()
    }
    
    private func errorInteractingWithTool(error: HATTableError) {
        
        FeedbackManager.vibrateWithHapticEvent(type: .warning)
        
        let message: String
        if self.selectedTool?.status.enabled ?? false {
            
            message = "Failed disabling"
        } else {
            
            message = "Failed enabling"
        }
        
        self.showPopUp(message: message, buttonTitle: nil, buttonAction: nil, selfDissmising: true)
    }
    
    // MARK: - ViewController methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.updateCollectionViewFlowLayout()
        self.checkForDataPreview()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAppStatus), name: NotificationNamesConstants.refreshAppStatus, object: nil)
        
        if (self.selectedTool?.status.enabled ?? true) && !(self.selectedTool?.status.available ?? false) {
            
            self.moreButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
        self.setNavigationBarColorToClear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    // MARK: - Update UI
    
    private func updateCollectionViewFlowLayout() {
        
        if let cvl: DataPreviewsFeedLayout = self.collectionView.collectionViewLayout as? DataPreviewsFeedLayout {
            
            cvl.emptyCache()
            cvl.delegate = self
            if self.selectedSection == 1 && self.dataPreviews.isEmpty {
                
                self.showPopUp(message: "Fetching previews...", buttonTitle: nil, buttonAction: nil)
                self.checkForDataPreview()
            }
            self.collectionView.reloadData()
            cvl.invalidateLayout()
        }
    }
    
    // MARK: - Check for data previews
    
    private func checkForDataPreview() {
        
        if self.selectedTool != nil && self.selectedSection == 1 {
            
            self.getFromSheFeed()
        } else {
            
            self.dismissPopUp()
        }
    }
    
    private func getFromSheFeed() {
        
        guard self.selectedTool != nil,
            let endpoint = self.selectedTool?.info.dataPreviewEndpoint else { return }

        let url = "https://\(userDomain)/api/v2.6/she/feed/she/activity-records"

        let headers = ["x-auth-token": self.userToken]

        self.fetchingDataPreviews = true
        
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.JSONEncoding.default, contentType: ContentType.json, parameters: [:], headers: headers, completion: { [weak self] response in

            guard let weakSelf = self else { return }

            switch response {

            case .error(_, _, _):

                break
            case .isSuccess(let isSuccess, let statusCode, let result, _):

                if isSuccess && statusCode != nil && statusCode! != 401 {

                    if let array = result.array, !(result.array?.isEmpty ?? true) {

                        for item in array {

                            if let obj: HATFeedObject = HATFeedObject.decode(from: item.dictionaryValue) {

                                weakSelf.dataPreviews.append(obj)
                            }
                        }

                        weakSelf.updateCollectionViewFlowLayout()
                    }
                }
            }
            
            weakSelf.dismissPopUp()
            weakSelf.fetchingDataPreviews = false
        })
    }
    
    @objc
    private func refreshAppStatus() {
        
        self.showPopUp(message: "Refreshing Tool...", buttonTitle: nil, buttonAction: nil)
        
        HATToolsService.getTool(
            toolName: self.selectedTool?.id ?? "",
            userDomain: self.userDomain,
            userToken: self.userToken,
            completion: gotToolFromDex,
            failCallBack: errorGettingTool)
    }
    
    private func gotToolFromDex(tool: HATToolsObject, newToken: String?) {
        
        self.selectedTool = tool
        self.updateCollectionViewFlowLayout()
        
        self.dismissPopUp()
    }
    
    private func errorGettingTool(error: Error) {
        
        self.dismissPopUp { [weak self] in
            
            self?.showPopUp(message: "Failed to refresh", buttonTitle: nil, buttonAction: nil, selfDissmising: true)
        }
    }
    
    // MARK: - CollectionView methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.selectedTool != nil {
            
            if self.selectedSection == 0 {
                
                if !(self.selectedTool!.info.graphics.screenshots.isEmpty ?? true) {

                    return 4
                }
                
                return 3
            } else {
                
                if self.dataPreviews.isEmpty {
                    
                    return 2
                } else {
                    
                    return self.dataPreviews.count + 1
                }
            }
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {

            let state = ApplicationConnectionState.getState(tool: self.selectedTool!)
            
            return AppInfoCollectionViewCell.setupCell(
                indexPath: indexPath,
                collectionView: collectionView,
                name: self.selectedTool?.info.name ?? "",
                rating: nil,
                bannerURL: "",
                logoURL: self.selectedTool?.info.graphics.logo.normal ?? "",
                state: state,
                type: "Tool",
                delegate: self)
        } else {

            if self.selectedSection == 0 {

                if indexPath.row == 1 {

                    return ExploreAppsImageCollectionViewCell.setupCell(indexPath: indexPath, collectionView: collectionView, description: self.selectedTool!.info.description.text.convertHtml())
                }
                
                if indexPath.row == 2 {
                    
                    return ExploreAppsDetailsScreenshotCollectionViewCell.setupCell(indexPath: indexPath, collectionView: collectionView, screenshots: self.selectedTool!.info.graphics.screenshots)
                }

                return ToolInformationCollectionViewCell.setUpCell(collectionView: collectionView, tool: self.selectedTool!, indexPath: indexPath, delegate: self)
            } else {

                if self.dataPreviews.isEmpty {

                    let message: String
                    if self.fetchingDataPreviews {
                        
                        message = ""
                    } else {
                        
                        message = "No previews found. Please connect to see your preview."
                    }
                    return DataPreviewMessageCollectionViewCell.setupCell(indexPath: indexPath, collectionView: self.collectionView, message: message)
                }
                
                if (self.dataPreviews[indexPath.row - 1].types?.contains("insight") ?? false) && self.dataPreviews[indexPath.row - 1].content?.nestedStructure != nil {
                    
                    return WeeklyInsightsCollectionViewCell.setUp(collectionView: collectionView, indexPath: indexPath, feedItem: self.dataPreviews[indexPath.row - 1])
                }
                return ExploreAppsDataCollectionViewCell.setupCell(indexPath: indexPath, collectionView: collectionView, dataPreview: self.dataPreviews[indexPath.row - 1], source: self.dataPreviews[indexPath.row - 1].source, userDomain: self.userDomain)
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
                //self.performSegue(withIdentifier: SeguesConstants.dataPreviewToMapSegue, sender: self)
            }
        }
    }

}
