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

import Cluster
import HatForIOS
import MapKit

// MARK: Class

internal class MapsViewController: HATUIViewController, MKMapViewDelegate, UpdateDateRangeProtocol, PinInfoViewControllerDelegate {
    
    let tapAreaSize = CGFloat(50)

    @objc
    private func tapped(gesture: UITapGestureRecognizer) {
        
        let point = gesture.location(in: self.view)
        
        self.userTappedOn(point: point)
    }
    
    @discardableResult
    func userTappedOn(point: CGPoint) -> Bool {
        
        let tapRect = CGRect(x: point.x - tapAreaSize / 2, y: point.y - tapAreaSize / 2 , width: tapAreaSize, height: tapAreaSize)
        
        for annotation in self.mapView.annotations {
            
            let annotationPoint = self.mapView.convert(annotation.coordinate, toPointTo: self.view)
            let annotationRect = CGRect(x: annotationPoint.x - 20, y: annotationPoint.y - 60, width: 40, height: 60)
            
            if tapRect.intersects(annotationRect) {
                
                self.isCollectionVIewScrollingEnabled = false

                self.mapView.selectAnnotation(annotation, animated: true)
                return true
            }
        }
        
        return false
    }
    
    func openImageViewer(url: String) {
        
        let mainStoryboard: UIStoryboard = HATUIViewController.getMainStoryboard()
        if let vc: FullScreenImageViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerNames.fullScreenImageViewController) as? FullScreenImageViewController {
            
            vc.url = url
            // present the next view controller
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func dismissView() {
        
        self.collectionView.isHidden = true
        self.collectionView.reloadData()
    }
    
    var fromDate: Date?
    var collectionViewSelectedIndex: Int?
    var toDate: Date?
    var selectedDateRangeIndex: Int?
    
    func newDateRangeSelected(from: Date, to: Date) {
        
        self.fromDate = from
        self.toDate = to
        let tempFromDateString = FormatterManager.formatDateStringToUsersDefinedDate(date: self.fromDate!, dateStyle: .short, timeStyle: .none)
        let tempToDateString = FormatterManager.formatDateStringToUsersDefinedDate(date: self.toDate!, dateStyle: .short, timeStyle: .none)
        if tempToDateString != tempFromDateString {
            
            self.selectedDateRangeIndex = 1
        }
        self.getLocations(startDate: from, endDay: to)
    }
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the mapView MKMapView
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var roundedButtonView: UIView!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBAction func filterButtonAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: SeguesConstants.filtersSegue, sender: self)
    }
    
    // MARK: - Variables
    
    private var sourceLoaded: Int = 0
    private let clusteringManager: ClusterManager = ClusterManager()
    private var locations: [MapLocation] = []
    private var orderedClusterLocations: [MKAnnotation] = []
    private var isRequestInProgress: Bool = false
    private var selectedAnnotationIndex: Int?
    private var isCollectionVIewScrollingEnabled: Bool = false
    var feedItem: HATFeedObject?
    
    // MARK: - View Controller functions

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        self.setTitle(title: "MAP")
        self.setNavigationBarColorToDarkBlue()
        
        self.roundedButtonView.makeViewFloating()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = false
        
        if self.feedItem == nil {
            
            let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipeGesture))
            leftSwipeGesture.direction = .right
            
            let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipeGesture))
            rightSwipeGesture.direction = .left
            
            self.collectionView.addGestureRecognizer(leftSwipeGesture)
            self.collectionView.addGestureRecognizer(rightSwipeGesture)
            reinitClusterManager()
            
            LocationObject.syncLocationsToHAT(
                userDomain: userDomain,
                userToken: userToken,
                completion: LocationObject.removeSyncedLocationsFromDB)
            
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissDetailsPopUp(gesture:)))
            self.mapView.addGestureRecognizer(tapGesture)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
            self.collectionView.addGestureRecognizer(tap)
        } else {
            
            self.roundedButtonView.isHidden = true
            if let location = self.feedItem?.location?.geo {
                
                let latitude = Double(location.latitude)
                let longitude = Double(location.longitude)

                self.addConvertedLocationToMap(latitude: latitude, longitude: longitude, feedItem: self.feedItem)
            } else if let address = self.feedItem?.location?.address {
                
                guard let name = address.name else { return }
                
                LocationManager.geoCodeUsingAddress(address: name, completionLocation: { [weak self] location in
                    
                    self?.addConvertedLocationToMap(latitude: location.latitude, longitude: location.longitude, feedItem: self?.feedItem)
                })
            }
        }
    }
    
    deinit {
        
        self.mapView = nil
        self.feedItem = nil
        self.fromDate = nil
        self.toDate = nil
        self.collectionViewSelectedIndex = nil
        self.selectedDateRangeIndex = nil
        self.selectedAnnotationIndex = nil
    }
    
    private func addConvertedLocationToMap(latitude: Double, longitude: Double, feedItem: HATFeedObject?) {
        
        var mapLocation = MapLocation()
        mapLocation.location.data.latitude = latitude
        mapLocation.location.data.longitude = longitude
        mapLocation.dataForAnnotationInfo = feedItem
        self.addLocations(locations: [mapLocation])
    }
    
    @objc
    func rightSwipeGesture() {
        
        guard self.collectionViewSelectedIndex != nil,
            self.orderedClusterLocations.count > self.collectionViewSelectedIndex! + 1 else { return }
        
        self.collectionView.isScrollEnabled = true
        self.collectionView.scrollToItem(at: IndexPath(row: self.collectionViewSelectedIndex! + 1, section: 0), at: .centeredHorizontally, animated: true)
        self.collectionView.isScrollEnabled = false
        self.collectionViewSelectedIndex = self.collectionViewSelectedIndex! + 1
        
        let coordinates = self.orderedClusterLocations[self.collectionViewSelectedIndex!].coordinate
        
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        self.isCollectionVIewScrollingEnabled = true
        
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc
    func leftSwipeGesture() {
    
        guard self.collectionViewSelectedIndex != nil,
            self.collectionViewSelectedIndex! > 0,
            !self.orderedClusterLocations.isEmpty else { return }
        
        self.collectionViewSelectedIndex = self.collectionViewSelectedIndex! - 1

        self.collectionView.isScrollEnabled = true
        self.collectionView.scrollToItem(at: IndexPath(row: self.collectionViewSelectedIndex!, section: 0), at: .centeredHorizontally, animated: true)
        self.collectionView.isScrollEnabled = false
        
        let coordinates = self.orderedClusterLocations[self.collectionViewSelectedIndex!].coordinate
        
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        self.isCollectionVIewScrollingEnabled = true

        self.mapView.setRegion(region, animated: true)
    }
    
    @objc
    private func dismissDetailsPopUp(gesture: UITapGestureRecognizer?)  {
        
        if let point = gesture?.location(in: self.mapView) {
            
            if !self.userTappedOn(point: point) {
                
                self.collectionView.isHidden = true
                self.collectionView.reloadData()
            }
        } else {
            
            self.collectionView.isHidden = true
            self.collectionView.reloadData()
        }
    }
    
    private func reinitClusterManager() {
        
        clusteringManager.minCountForClustering = 3
        clusteringManager.shouldRemoveInvisibleAnnotations = true
        clusteringManager.clusterPosition = .average
        clusteringManager.cellSize = 100
        clusteringManager.maxZoomLevel = 17
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if self.fromDate == nil && self.feedItem == nil {
            
            let date: Date = Date()
            self.getLocations(startDate: date, endDay: date)
        }

        let status: CLAuthorizationStatus = LocationManager.checkAuthorisation().1
        if status == .denied {
            
            self.createDressyClassicOKAlertWith(alertMessage: "", alertTitle: "Uploading of location has been disabled for this device", okTitle: "OK", proceedCompletion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.dismissDetailsPopUp(gesture: nil)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Get Locations

    private func getLocations(startDate: Date, endDay: Date) {
        
        guard !self.isRequestInProgress else { return }
        
        self.showPopUp(message: "Fetching Locations, Please Wait", buttonTitle: nil, buttonAction: nil, selfDissmising: false)
        
        self.locations.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        clusteringManager.removeAll()
        
        let startOfDay = Date.startOfDateInUnixTimeStamp(date: startDate)
        let endOfDay = Date.endOfDateInUnixTimeStamp(date: endDay)

        let parameters = ["since": startOfDay, "until": endOfDay!]
        
        self.isRequestInProgress = true
        
        HATFeedService.getFeed(
            userDomain: userDomain,
            userToken: userToken,
            parameters: parameters,
            hatSuffix: "",
            successCallback: locationsFromSheFeedReceived,
            failed: failedFetchingLocationsFromFeed)
        
        HATAccountService.createCombinator(
            userDomain: userDomain,
            userToken: userToken,
            endPoint: "rumpel/locations/ios",
            combinatorName: "locationsfilter",
            fieldToFilter: "dateCreated",
            lowerValue: startOfDay,
            upperValue: endOfDay!,
            successCallback: locationsCombinatorCreated,
            failCallback: failedCreatingCombinator)
        
        let locationsDB = LocationObject.getLocationsFromDB()
        var tempArray: [MapLocation] = []
        for location in locationsDB where location.dateCreated <= endOfDay! && location.dateCreated >= startOfDay {
            
            let tempLoc = MapLocation(from: location)
            tempArray.append(tempLoc)
        }
        self.addLocations(locations: tempArray)
    }
    
    private func addLocations(locations: [MapLocation]) {
        
        self.sourceLoaded = self.sourceLoaded + 1
        
        self.locations.append(contentsOf: locations)
                
        if !self.locations.isEmpty {
            
            let pins = clusteringManager.createAnnotationsFrom(objects: locations)
            clusteringManager.add(pins)
            
            let allPins = clusteringManager.createAnnotationsFrom(objects: self.locations)
            clusteringManager.fitMapViewToAnnotationList(allPins, mapView: self.mapView)
            
            self.orderedClusterLocations = self.clusteringManager.annotations.sorted(by: {annot1, annot2 in
                
                guard let annotation1 = annot1 as? CustomAnnotation, let annotation2 = annot2 as? CustomAnnotation else { return false }
                
                return annotation1.mapLocation!.dataForAnnotationInfo!.date.unix < annotation2.mapLocation!.dataForAnnotationInfo!.date.unix
            })
            
            if sourceLoaded == 3 {
                
                self.dismissPopUp()
            }
        } else if self.sourceLoaded == 3 && self.locations.isEmpty {
            
            self.dismissPopUp(completion: { [weak self] in
                
                self?.showPopUp(message: "No locations found for the selected date", buttonTitle: nil, buttonAction: nil, selfDissmising: true)
            })
        }
    }
    
    private func receivedLocations(locations: [HATLocationsObject], newUserToken: String?) {
        
        self.isRequestInProgress = false
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newUserToken)
        
        var tempArray: [MapLocation] = []
        
        for location in locations where !locations.isEmpty {

            let tempLocation = MapLocation(location: location, object: nil)
            tempArray.append(tempLocation)
        }
        self.addLocations(locations: tempArray)
    }
    
    private func locationsCombinatorCreated(result: Bool, newUserToken: String?) {
        
        KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newUserToken)

        HATLocationService.getLocationCombinator(
            userDomain: userDomain,
            userToken: userToken,
            successCallback: receivedLocations,
            failCallback: failedCreatingCombinator)
    }
    
    private func locationsFromSheFeedReceived(feed: [HATFeedObject], newUserToken: String?) {
        
        self.isRequestInProgress = false
        
        var tempLocationArray: [MapLocation] = []

        for item in feed where item.location != nil {
            
            if item.location?.geo != nil {
                
                let location = MapLocation(from: item, coordinates: nil)
                tempLocationArray.append(location)
            } else if (item.location?.address != nil && item.location?.address?.name != nil) {
                
                LocationManager.geoCodeUsingAddress(address: item.location!.address!.name!, completionLocation: {[weak self] coordinates in
                    
                    guard let weakSelf = self else { return }

                    let location = MapLocation(from: item, coordinates: coordinates)
                    weakSelf.addLocations(locations: [location])
                })
            }
        }
        
        self.addLocations(locations: tempLocationArray)
    }
    
    private func failedCreatingCombinator(error: HATError) {
        
        self.dismissPopUp()

        switch error {
        case .generalError(_, let statusCode, let error):
            
            if error != nil && statusCode != nil {
                
                LoggerManager.logCustomError(error: error!, info: ["status code:": statusCode!])
            }
            if statusCode == 401 {
                
                LoggerManager.logCustomError(error: AuthenticationError.tokenExpired, info: ["status code": 401])
                
                self.tokenExpiredLogOut()
            }
        default:
            
            break
        }
    }
    
    private func failedFetchingLocationsFromFeed(error: HATTableError) {
        
        self.dismissPopUp()
        
        switch error {
        case .generalError(_, let statusCode, let error):
            
            if error != nil && statusCode != nil {
                
                LoggerManager.logCustomError(error: error!, info: ["status code:": statusCode!])
            }
            if statusCode == 401 {
                
                LoggerManager.logCustomError(error: AuthenticationError.tokenExpired, info: ["status code": 401])
                
                self.tokenExpiredLogOut()
            }
        default:
            
            break
        }
    }
    
    // MARK: - MapView delegate methods
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        clusteringManager.reload(mapView: mapView)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else { return }
        
        if let cluster = annotation as? ClusterAnnotation {
            
            var zoomRect = MKMapRectNull
            for annotation in cluster.annotations {
                
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 10, 10)
                
                if MKMapRectIsNull(zoomRect) {
                    
                    zoomRect = pointRect
                } else {
                    
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        } else {
            
            guard let pin = annotation as? CustomAnnotation,
                pin.mapLocation?.dataForAnnotationInfo != nil else { return }
            
            self.selectedAnnotationIndex = self.orderedClusterLocations.index(where: { item in
                
                // something goes wrong here
                guard let customItem = item as? CustomAnnotation else { return false }
                
                return (customItem.mapLocation!.location.data.latitude == pin.mapLocation!.location.data.latitude && customItem.mapLocation!.location.data.longitude == pin.mapLocation!.location.data.longitude && customItem.mapLocation!.dataForAnnotationInfo!.date.unix == pin.mapLocation!.dataForAnnotationInfo!.date.unix && customItem.mapLocation!.dataForAnnotationInfo!.source == pin.mapLocation!.dataForAnnotationInfo!.source)
            })
            
            self.collectionViewSelectedIndex = selectedAnnotationIndex
            
            if self.collectionView.isHidden {
                
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
            
            self.collectionView.scrollToItem(at: IndexPath(row: self.collectionViewSelectedIndex!, section: 0), at: .centeredHorizontally, animated: isCollectionVIewScrollingEnabled)
        }
        
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        views.forEach { $0.alpha = 0 }
        
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: {
            
                views.forEach { $0.alpha = 1 }
            },
            completion: nil)
    }
    
    /**
     Called through map delegate to update its annotations
     
     - parameter mapView: the maoview object
     - parameter annotation: annotation to render
     
     - returns: An optional object of type MKAnnotationView
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? ClusterAnnotation {
            
            guard let style = annotation.style else { return nil }
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            var clusterIsBeingMadeOfDifferentLocationSources: Bool = false
            var sources: Set<String> = []
            for location in annotation.annotations {
                
                guard let location = location as? CustomAnnotation else { continue }
                
                if let source = location.mapLocation?.dataForAnnotationInfo?.source {
                    
                    sources.insert(source)
                }
                if sources.count > 1 {
                    
                    clusterIsBeingMadeOfDifferentLocationSources = true
                    break
                }
            }
            
            if let view = view as? BorderedClusterAnnotationView {
                
                view.annotation = annotation
                view.configure(with: style, clusterIsBeingMadeOfDifferentLocationSources: clusterIsBeingMadeOfDifferentLocationSources)
            } else {
                
                view = BorderedClusterAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier,
                    style: style,
                    borderColor: .white,
                    clusterIsBeingMadeOfDifferentLocationSources: clusterIsBeingMadeOfDifferentLocationSources)
            }
            
            return view
        } else {
            
            guard let annotation = annotation as? CustomAnnotation else { return nil }
            
            return annotation.setUpCluster(mapView: self.mapView)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? FilterViewController {
            
            vc.delegate = self
            vc.firstDate = self.fromDate
            vc.toDate = self.toDate
            vc.selectedRangeIndex = self.selectedDateRangeIndex ?? 0
        }
    }
}

extension MapsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.orderedClusterLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let annotation = self.orderedClusterLocations[indexPath.row] as? CustomAnnotation
        
        if annotation?.mapLocation?.dataForAnnotationInfo?.content?.media != nil && !(annotation?.mapLocation?.dataForAnnotationInfo?.content?.media?.isEmpty)! {
            
            return MapImagePinCollectionViewCell.setUp(collectionView: collectionView, mapLocation: annotation!.mapLocation!, indexPath: indexPath, delegate: self)
        } else {
            
            return MapTextPinCollectionViewCell.setUp(collectionView: collectionView, mapLocation: annotation!.mapLocation!, indexPath: indexPath, delegate: self)
        }
    }
}
