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

internal class SheFeedViewController: HATUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FeedRefreshCellDelegate, RefreshControlProtocol, UpdateDateRangeProtocol, CustomFeedLayoutDelegate {
    
    private struct CellSize {
        
        static let image: CGFloat = 206
        static let summary: CGFloat = 288
        static let header: CGFloat = 25
    }
    var fromDate: Date?
    var toDate: Date?
    var selectedDateRangeIndex: Int?
    
    func newDateRangeSelected(from: Date, to: Date) {
        
        self.fromDate = from
        self.toDate = to
        // returns 1 if true or 0 if false
        self.selectedDateRangeIndex = (Date.startOfDate(date: from) != Date.startOfDate(date: to)).hashValue
        self.hasUserFilteredData = true
        
        self.getFeed(userRequestedMoreItems: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForSheFeedItemAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        guard indexPath.section < self.grouppedFeedItems.count && indexPath.row < self.grouppedFeedItems[indexPath.section].count else { return CellSize.header }
        
        let item = self.grouppedFeedItems[indexPath.section][indexPath.row]

        if (item.types?.contains("insight") ?? false) && item.content?.nestedStructure != nil {
            
            if let structure = item.content?.nestedStructure {
                
                var rows = 0
                for dict in structure.values {
                    
                    rows = rows + dict.count
                }
                
                return CGFloat((rows * 44) + 74 - 22)
            }
            return CellSize.summary
        }

        if item.content?.media != nil || item.location != nil {
            
            if item.title.subtitle != nil {
                
                return 17 + item.title.text.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 128, font: UIFont.avenirRegular(ofSize: 14)) + CellSize.image
            }
            return item.title.text.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 128, font: UIFont.avenirRegular(ofSize: 14)) + CellSize.image
        }
        
        var height = item.title.text.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 128, font: UIFont.avenirRegular(ofSize: 14))
        
        if item.title.subtitle != nil {
            
            height = height + item.title.subtitle!.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 128, font: UIFont.avenirRegular(ofSize: 12))
        }
        if item.content?.text != nil {
            
            height = height + item.content!.text!.calculateLabelHeight(maxWidth: UIScreen.main.bounds.width - 100, font: UIFont.avenirRegular(ofSize: 12)) + 32
        } else {
            
            height = height + 20
        }
        
        return height
    }
    
    func resizeCellAt(indexPath: IndexPath, cell: UICollectionViewCell) {
        
        guard indexPath.section < self.grouppedFeedItems.count && indexPath.row < self.grouppedFeedItems[indexPath.section].count else { return }
        
        if let tempCell = cell as? DataPlugsDetailsImageCollectionViewCell {
            
            let cell = HATFeedCell(object: self.grouppedFeedItems[indexPath.section][indexPath.row], image: tempCell.mainImageView.image, indexPath: indexPath)
            cells.append(cell)
        }
    }
    
    func showMoreButtonClicked(indexPath: IndexPath, cell: UICollectionViewCell) {
        
        let item = self.grouppedFeedItems[indexPath.section][indexPath.row]
        guard let additionalItemsToLoadString = item.source.split(separator: " ").last else { return }
        guard let additionalItemsToLoad = Int(additionalItemsToLoadString) else { return }
        
        var feedArrayIndexOfItem: Int = 0
        
        for (index, tempItem) in self.feedItems[indexPath.section].enumerated() where item.date.unix == tempItem.date.unix && indexPath.row <= index {
            
            if tempItem.content?.text == item.content?.text {
                
                feedArrayIndexOfItem = index
                break
            }
        }
        
        guard self.feedItems[indexPath.section].count >= (1 + feedArrayIndexOfItem + additionalItemsToLoad) else { return }
        let items = self.feedItems[indexPath.section][(feedArrayIndexOfItem)..<(1 + feedArrayIndexOfItem + additionalItemsToLoad)]

        self.cells.removeAll()
        self.grouppedFeedItems[indexPath.section].remove(at: indexPath.row)
        self.grouppedFeedItems[indexPath.section].insert(contentsOf: items, at: indexPath.row)

        var indexPathsToInsert: [IndexPath] = []
        for index in 0...items.count - 1 {
            
            indexPathsToInsert.append(IndexPath(row: index + indexPath.row, section: indexPath.section))
        }
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
        if let cvl = self.collectionView.collectionViewLayout as? SheFeedLayout {

            cvl.emptyCache()
        }
    }
    
    // MARK: - Variables
    
    private var grouppedFeedItems: [[HATFeedObject]] = []
    private var feedItems: [[HATFeedObject]] = []
    private var cells: [HATFeedCell] = []
    private var totalPlugsConnected: Int = 0
    private var hasUserFilteredData: Bool = false
    private var isRequestInProgress: Bool = false
    private var selectedFeedItem: HATFeedObject?
    private var isUserRefreshingData: Bool = false
    private var totalTimesTriedToFetchPastFeed: Int = 0
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewMessageLabel: UILabel!
    @IBOutlet private weak var mapButton: UIButton!
    @IBOutlet private weak var floatingFilterView: UIView!
    @IBOutlet private weak var jumpToTodayButton: UIButton!
    @IBOutlet private weak var refreshButton: UIButton!
    @IBOutlet private weak var filterButton: UIButton!
    
    // MARK: - IBAction
    
    @IBAction func sideMenuButtonAction(_ sender: Any) {
        
        sideMenuViewController = SideMenuViewController.present(delegate: self, restorationID: self.navigationController?.restorationIdentifier)
    }
    
    @IBAction func locationButtonAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: SeguesConstants.mapsSegue, sender: self)
    }
    
    @IBAction func jumpToTodayAction(_ sender: Any) {
        
        FeedbackManager.vibrateWithHapticIntensity(type: .light)

        self.scrollToToday(animated: true)
    }
    
    @IBAction func refreshFeedAction(_ sender: Any) {
        
        FeedbackManager.vibrateWithHapticIntensity(type: .light)
        
        self.fromDate = nil
        self.toDate = nil
        self.totalTimesTriedToFetchPastFeed = 0
        self.refreshData()
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: SeguesConstants.filterFeedSegue, sender: self)
    }
    
    // MARK: - Notification Selectors
    
    @objc
    private func refreshData() {
        
        func onlineCompletion() {
            
            guard !self.grouppedFeedItems.isEmpty else { return }
            
            CacheManager<HATFeedObject>.removeAllObjects(fromCache: "cache")
            let indexPaths: [IndexPath] = self.generateIndexPathsToDelete(feedArray: self.grouppedFeedItems)
            let indexSet = IndexSet(integersIn: 0...self.grouppedFeedItems.count - 1)
            
            self.grouppedFeedItems.removeAll()
            self.feedItems.removeAll()
            self.cells.removeAll()
            self.isUserRefreshingData = true
            
            self.getFeed()
            self.updateCollectionView(indexPathsToDelete: indexPaths, indexPathsToInsert: nil, sectionsToDelete: indexSet, sectionsToInsert: nil, dismissLoadingScreen: false)
        }
        
        func offlineCompletion() {
            
            let stopRefreshingAnimation = self.collectionView.refreshControl?.endRefreshing
            
            self.createDressyClassicOKAlertWith(
                alertMessage: "Your device is not connected to the internet. Cannot refresh data",
                alertTitle: "No internet connection",
                okTitle: "OK",
                proceedCompletion: stopRefreshingAnimation
            )
        }
        
        self.hasUserFilteredData = false
        NetworkManager().checkState(onlineCompletion: onlineCompletion, offlineCompletion: offlineCompletion)
    }
    
    @objc
    private func navigateToMaps() {
        
        self.performSegue(withIdentifier: SeguesConstants.mapsSegue, sender: self)
    }
    
    // MARK: - View Controller finctions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addSwipeRecogniserToShowSideMenu(view: self.collectionView)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(SheFeedHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CellIdentifiersConstants.feedHeader)
        
        self.addRefreshControlTo(self.collectionView, target: self, selector: #selector(refreshData))
        
        if let cvl: SheFeedLayout = self.collectionView.collectionViewLayout as? SheFeedLayout {
            
            cvl.delegate = self
        }
        
        let swipeRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(navigateToMaps))
        swipeRecogniser.direction = .left
        self.collectionView.addGestureRecognizer(swipeRecogniser)
        
        // Flip image to the right of the text
        self.mapButton.flipImageToTheLeftSide()
        
        self.filterButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 3, bottom: 10, right: 5)
        self.jumpToTodayButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3)
        self.refreshButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3)
        
        self.floatingFilterView.makeViewFloating()
        
        self.setNavigationBarColorToDarkBlue()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.checkForFirstLaunch(completion: executeAfterOnboarding)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setNavigationBarColorToDarkBlue()
    }
    
    // MARK: - Onboarding checks
    
    private func executeAfterOnboarding() {
        
        if self.grouppedFeedItems.isEmpty {
            
            self.getFeed()
        }
        HATExternalAppsService.getExternalApps(userToken: self.userToken, userDomain: self.userDomain, completion: availablePlugs, failCallBack: receivedError)
    }
    
    private func checkForFirstLaunch(completion: () -> Void) {
        
        let isNewUser: String? = KeychainManager.getKeychainValue(key: KeychainConstants.newUser)
        
        if isNewUser != KeychainConstants.Values.setFalse {
            
            KeychainManager.setKeychainValue(key: KeychainConstants.newUser, value: KeychainConstants.Values.setFalse)
            self.navigateToViewControllerWithoutRemovingSuperView(name: ViewControllerNames.launchOnboarding)
        } else {
            
            completion()
        }
    }
    
    // MARK: - Collectionview functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.grouppedFeedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.grouppedFeedItems[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.section < self.grouppedFeedItems.count && indexPath.row < self.grouppedFeedItems[indexPath.section].count else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.plugFeedTextCell, for: indexPath)
        }
        
        if (Double(indexPath.section) > (0.85 * Double(self.grouppedFeedItems.endIndex))) && !isRequestInProgress && !self.hasUserFilteredData {
            
            self.getFeed(userRequestedMoreItems: true)
        }
        
        let feedItem: HATFeedObject = self.grouppedFeedItems[indexPath.section][indexPath.row]
        if (feedItem.types?.contains("insight") ?? false) && feedItem.content?.nestedStructure != nil {
            
            return WeeklyInsightsCollectionViewCell.setUp(collectionView: collectionView, indexPath: indexPath, feedItem: feedItem)
        } else if feedItem.content?.media != nil || feedItem.location != nil {
            
            if !cells.isEmpty {
                
                for cell in cells where cell.indexPath == indexPath {
                    
                    return DataPlugsDetailsImageCollectionViewCell.setUpCellCached(collectionView: collectionView, feedObject: cell.object!, image: cell.image, indexPath: indexPath)
                }
            }
            
            return DataPlugsDetailsImageCollectionViewCell.setUp(collectionView: collectionView, indexPath: indexPath, feedObject: self.grouppedFeedItems[indexPath.section][indexPath.row], userToken: self.userToken, userDomain: self.userDomain, delegate: self)
        } else if feedItem.content?.text == nil {
            
            return DataPlugsDetailsFeedCollectionViewCell.setUp(collectionView: collectionView, indexPath: indexPath, feedObject: self.grouppedFeedItems[indexPath.section][indexPath.row], reuseIdentifier: CellIdentifiersConstants.plugSimpleFeedTextCell, delegate: self)
        }
        
        return DataPlugsDetailsFeedCollectionViewCell.setUp(collectionView: collectionView, indexPath: indexPath, feedObject: self.grouppedFeedItems[indexPath.section][indexPath.row], reuseIdentifier: CellIdentifiersConstants.plugFeedTextCell, delegate: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for item in self.cells where item.indexPath == indexPath {
            
            // get the next view controller
            let mainStoryboard: UIStoryboard = HATUIViewController.getMainStoryboard()
            
            if let media = item.object?.content?.media {
                
                if let vc: FullScreenImageViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerNames.fullScreenImageViewController) as? FullScreenImageViewController {
                    
                    if let url = media[0].url {
                        
                        vc.url = url
                    } else if let thumbnail = media[0].thumbnail {
                        
                        vc.url = thumbnail
                    }
                    
                    // present the next view controller
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                
                self.selectedFeedItem = item.object
                self.performSegue(withIdentifier: SeguesConstants.mapsSegue, sender: self)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return SheFeedHeaderCollectionReusableView.setUpHeader(collectionView: collectionView, kind: kind, feedItem: self.grouppedFeedItems[indexPath.section][indexPath.row], indexPath: indexPath)
    }
    
    private func updateCollectionView(indexPathsToDelete: [IndexPath]?, indexPathsToInsert: [IndexPath]?, sectionsToDelete: IndexSet?, sectionsToInsert: IndexSet?, hasUserFilteredData: Bool = false, userRequestedMoreItems: Bool = false, dismissLoadingScreen: Bool = true) {
        
        self.collectionView.performBatchUpdates({ [weak self] in
            
            guard let weakSelf = self else { return }
            
            if let cvl = self?.collectionView.collectionViewLayout as? SheFeedLayout {
                
                cvl.emptyCache()
            }
            
            if sectionsToDelete != nil && !sectionsToDelete!.isEmpty && weakSelf.collectionView.numberOfSections > 0 {
                
                weakSelf.collectionView.deleteSections(sectionsToDelete!)
            }
            if indexPathsToDelete != nil && !indexPathsToDelete!.isEmpty && weakSelf.collectionView.numberOfSections > 0 {
                
                weakSelf.collectionView.deleteItems(at: indexPathsToDelete!)
            }
            if sectionsToInsert != nil && !sectionsToInsert!.isEmpty {
                
                weakSelf.collectionView.insertSections(sectionsToInsert!)
            }
            if indexPathsToInsert != nil && !indexPathsToInsert!.isEmpty {
                
                weakSelf.collectionView.insertItems(at: indexPathsToInsert!)
            }
        },
        completion: { [weak self] _ in
            
            guard let weakSelf = self else { return }
            
            if dismissLoadingScreen {
                
                weakSelf.dismissLoadingView(completion: {
                    
                    weakSelf.collectionView.isHidden = false
                })
            }
            weakSelf.collectionViewMessageLabel.isHidden = true
            weakSelf.isRequestInProgress = false
            
            if !hasUserFilteredData {
                
                if !userRequestedMoreItems {
                    
                    weakSelf.scrollToToday()
                } else {
                    
                    weakSelf.collectionView.collectionViewLayout.invalidateLayout()
                }
                CacheManager<HATFeedObject>.saveObjects(objects: weakSelf.feedItems, inCache: "cache", key: "feed")
            } else {
                
                weakSelf.collectionView.collectionViewLayout.invalidateLayout()
                weakSelf.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        })
    }
    
    // MARK: - Get feed
    
    private func receivedFeed(feedArray: [HATFeedObject], newUserToken: String?, userRequestedMoreItems: Bool = false) {
        
        self.isUserRefreshingData = false
        self.collectionView.refreshControl?.endRefreshing()
        self.dismissPopUp()

        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newUserToken)
        
        guard !feedArray.isEmpty,
            self.isViewLoaded else {
                
                if hasUserFilteredData {
                    
                    self.dismissPopUp(completion: { [weak self] in
                        
                        self?.showPopUp(message: "No data for the selected dates", buttonTitle: nil, buttonAction: nil, selfDissmising: true)
                        self?.hasUserFilteredData = false
                    })
                } else {
                    
                    if self.grouppedFeedItems.isEmpty {
                        
                        self.totalTimesTriedToFetchPastFeed += 1
                        self.getFeed(noDataFound: true)
                    }
                    
                    self.collectionView.isHidden = self.grouppedFeedItems.isEmpty
                }
                
                return
        }
        
        self.totalTimesTriedToFetchPastFeed = 0
        
        if self.hasUserFilteredData {
            
            let indexPathsToDelete: [IndexPath] = generateIndexPathsToDelete(feedArray: self.grouppedFeedItems)
            let sectionsToDelete: IndexSet?
            if !indexPathsToDelete.isEmpty {
                
                sectionsToDelete = IndexSet(integersIn: 0...indexPathsToDelete.last!.section)
            } else {
                
                sectionsToDelete = nil
            }
            self.feedItems.removeAll()
            self.grouppedFeedItems.removeAll()

            let tempFeedArray: [[HATFeedObject]] = HATFeedService.createSections(receivedArray: feedArray, feedItemsInCollectionView: &self.feedItems)
            let tempGroupedFeedArray: [[HATFeedObject]] = HATFeedService.createGrouppedSections(fromItems: tempFeedArray, groupIfMoreThan: 2)
            
            let indexPathsToInsert: [IndexPath] = self.generateIndexPathsToInsert(addSectionNumber: nil, feedArray: tempGroupedFeedArray)
            
            let sectionsToInsert = IndexSet(integersIn: 0...indexPathsToInsert.last!.section)
            
            self.grouppedFeedItems = tempGroupedFeedArray
            self.feedItems = tempFeedArray
            self.cells.removeAll()
            
            self.updateCollectionView(indexPathsToDelete: indexPathsToDelete, indexPathsToInsert: indexPathsToInsert, sectionsToDelete: sectionsToDelete, sectionsToInsert: sectionsToInsert, hasUserFilteredData: self.hasUserFilteredData, userRequestedMoreItems: userRequestedMoreItems)
        } else {
            
            let tempFeedArray: [[HATFeedObject]] = HATFeedService.createSections(receivedArray: feedArray, feedItemsInCollectionView: &self.feedItems)
            let tempGroupedFeedArray: [[HATFeedObject]] = HATFeedService.createGrouppedSections(fromItems: tempFeedArray, groupIfMoreThan: 2)
            let lastSectionFeedIndex = self.grouppedFeedItems.endIndex
            
            let sectionsToDelete = IndexSet(integersIn: lastSectionFeedIndex - 1...lastSectionFeedIndex - 1)
            let sectionsToInsert: IndexSet
            if lastSectionFeedIndex > 0 {
                
                sectionsToInsert = IndexSet(integersIn: lastSectionFeedIndex - 1...lastSectionFeedIndex + tempGroupedFeedArray.count - 1)
            } else {
                
                sectionsToInsert = IndexSet(integersIn: 0...tempGroupedFeedArray.count - 1)
            }
            let indexPathsToInsert: [IndexPath] = generateIndexPathsToInsert(addSectionNumber: lastSectionFeedIndex, feedArray: tempGroupedFeedArray)
            
            self.grouppedFeedItems.append(contentsOf: tempGroupedFeedArray)
            self.feedItems.append(contentsOf: tempFeedArray)
            self.cells.removeAll()
            
            self.updateCollectionView(indexPathsToDelete: nil, indexPathsToInsert: indexPathsToInsert, sectionsToDelete: sectionsToDelete, sectionsToInsert: sectionsToInsert, hasUserFilteredData: self.hasUserFilteredData, userRequestedMoreItems: userRequestedMoreItems)
        }
    }
    
    private func generateIndexPathsToInsert(addSectionNumber: Int?, feedArray: [[HATFeedObject]]) -> [IndexPath] {
        
        var indexPathsToInsert: [IndexPath] = []
        for section in feedArray.indices where !feedArray.isEmpty {
            
            for row in feedArray[section].indices {
                
                indexPathsToInsert.append(IndexPath(row: row, section: section + (addSectionNumber ?? 0)))
            }
        }
        
        return indexPathsToInsert
    }
    
    private func generateIndexPathsToDelete(feedArray: [[HATFeedObject]]) -> [IndexPath] {
        
        var indexPathsToDelete: [IndexPath] = []
        
        for section in feedArray.indices where feedArray.count > 0 {
            
            for row in feedArray[section].indices {
                
                indexPathsToDelete.append(IndexPath(row: row, section: section))
            }
        }
        
        return indexPathsToDelete
    }
    
    private func scrollToToday(_ shouldScroll: Bool = true, animated: Bool = false) {
        
        if shouldScroll {
            
            let endOfTheDay = Date.endOfDate()!
            let endOfTheDayUnix = Int(endOfTheDay.timeIntervalSince1970)
            
            for section in self.grouppedFeedItems.indices where self.grouppedFeedItems.count > 0 {
                
                for item in self.grouppedFeedItems[section] where item.date.unix <= endOfTheDayUnix {
                    
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: section), at: .top, animated: false)
                    return
                }
            }
        }
    }
    
    private func receivedError(error: HATTableError) {
        
        switch error {
        case .generalError(_, let statusCode, _):
            
            LoggerManager.logCustomError(error: AuthenticationError.tokenExpired, info: ["status code": statusCode ?? 0])
            
            if statusCode == 401 {
                
                self.tokenExpiredLogOut()
            }
        default:
            
            break
        }
    }
    
    private func availablePlugs(plugs: [HATApplicationObject], newUserToken: String?) {
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newUserToken)
        
        self.totalPlugsConnected = 0
        for plug in plugs where plug.application.kind.kind == "DataPlug" && plug.setup {
            
            self.totalPlugsConnected = self.totalPlugsConnected + 1
        }
        
        if self.totalPlugsConnected == 0 {
            
            self.createDressyClassicOKAlertWith(
                alertMessage: "TIP: Connect data plugs to pull in and claim your personal data to store in your HAT.",
                alertTitle: "Claim back your personal data",
                okTitle: "Connect Plugs",
                proceedCompletion: { [weak self] in
                    
                    self?.navigateToViewControllerWith(name: ViewControllerNames.dataPlugs)
                }
            )
        }
    }
    
    private func getFeed(userRequestedMoreItems: Bool = false, noDataFound: Bool = false) {
        
        self.isRequestInProgress = true
        
        HATService.triggerHAT(userDomain: userDomain, headers: ["x-auth-token" : userToken])
        
        if self.feedItems.isEmpty {
            
            self.showLoadingView(title: "Fetching Feed Please Wait", description: "Data can take a few minutes to come in")
            self.collectionView.isHidden = true
            self.collectionViewMessageLabel.isHidden = true
        } else {
            
            self.showPopUp(message: "Fetching Feed Please Wait", buttonTitle: nil, buttonAction: nil, selfDissmising: false)
        }
        
        let getFeed = { [weak self] in
            
            guard let weakSelf = self else { return }
            
            if noDataFound {
                
                if weakSelf.totalTimesTriedToFetchPastFeed < 10 {
                    
                    let date: Date
                    if let unix = weakSelf.grouppedFeedItems.last?.last?.date.unix {
                        
                        date = Date(timeIntervalSince1970: Double(unix))
                    } else {
                        
                        date = Date()
                    }
                    var dateComponents: DateComponents = DateComponents()
                    dateComponents.month = -3 * weakSelf.totalTimesTriedToFetchPastFeed
                    
                    let pastDate: Date = Calendar.current.date(byAdding: dateComponents, to: date)!
                    
                    let parameters: Dictionary<String, String> = HATFeedService.constructParameters(filterFromDate: pastDate, filterToDate: weakSelf.toDate, lastFeedItemDateISO: weakSelf.grouppedFeedItems.last?.last?.date.iso, noValuesFound: noDataFound)
                    
                    HATFeedService.getFeed(
                        userDomain: weakSelf.userDomain,
                        userToken: weakSelf.userToken,
                        parameters: parameters,
                        successCallback: { items, token in
                            
                            weakSelf.receivedFeed(feedArray: items, newUserToken: token, userRequestedMoreItems: userRequestedMoreItems)
                    },
                        failed: weakSelf.receivedError)
                } else {
                    
                    self?.showLoadingView(title: "No items found", description: "Connect Data Plugs to see your data in the feed")
                }
            } else {
                
                let parameters: Dictionary<String, String> = HATFeedService.constructParameters(filterFromDate: weakSelf.fromDate, filterToDate: weakSelf.toDate, lastFeedItemDateISO: weakSelf.grouppedFeedItems.last?.last?.date.iso)
                
                HATFeedService.getFeed(
                    userDomain: weakSelf.userDomain,
                    userToken: weakSelf.userToken,
                    parameters: parameters,
                    successCallback: { items, token in
                        
                        weakSelf.receivedFeed(feedArray: items, newUserToken: token, userRequestedMoreItems: userRequestedMoreItems)
                    },
                    failed: weakSelf.receivedError)
            }
        }
        
        if isUserRefreshingData || userRequestedMoreItems || hasUserFilteredData || noDataFound {
            
            getFeed()
        } else {
            
            if let results: [[HATFeedObject]] = CacheManager<HATFeedObject>.retrieveObjects(fromCache: "cache", forKey: "feed", networkRequest: getFeed) {
                
                self.dismissLoadingView(completion: { [weak self] in
                    
                    self?.collectionView.isHidden = false
                })
                self.feedItems = results
                self.grouppedFeedItems = HATFeedService.createGrouppedSections(fromItems: self.feedItems, groupIfMoreThan: 2)
                self.isRequestInProgress = false
                self.dismissPopUp()
                self.collectionView.reloadData()
                self.scrollToToday()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? FilterViewController {
            
            vc.delegate = self
            vc.firstDate = self.fromDate
            vc.toDate = self.toDate
            vc.selectedRangeIndex = self.selectedDateRangeIndex ?? 0
        } else if let vc = segue.destination as? MapsViewController {
            
            vc.feedItem = self.selectedFeedItem
            self.selectedFeedItem = nil
        }
    }
}
