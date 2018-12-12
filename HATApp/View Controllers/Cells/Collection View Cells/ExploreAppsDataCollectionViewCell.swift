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

class ExploreAppsDataCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!
    @IBOutlet private weak var sharedlabel: UILabel!
    @IBOutlet private weak var hatNameLabel: UILabel!
    @IBOutlet private weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var appImageView: UIImageView!
    
    // MARK: - Variables
    
    private var types: [String] = []
    private var hasImage: Bool = false
    var feedItem: HATFeedObject?
    
    // MARK: - CollectionView methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataPreviewImageCell", for: indexPath) as? ExploreAppsDataImageCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "dataPreviewImageCell", for: indexPath)
        }
        
        cell.setUpCell(cell: cell, imageURL: types[indexPath.row])
        return cell
    }
    
    // MARK: - Setup cell
    
    static func setupCell(indexPath: IndexPath, collectionView: UICollectionView, dataPreview: HATFeedObject, source: String, userDomain: String) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataPreviewCell", for: indexPath) as? ExploreAppsDataCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "dataPreviewCell", for: indexPath)
        }
        
        cell.feedItem = dataPreview
        cell.setDate(unixTimeStamp: Int(dataPreview.date.unix))
        cell.setTitle(title: userDomain)
        cell.setSubtitle(subtitle: dataPreview.content?.text ?? dataPreview.title.text)
        cell.setShared(shared: dataPreview.title.action)
        cell.searchForImages(items: dataPreview, userDomain: userDomain)
        cell.mainView.layer.cornerRadius = 5
        cell.appImageView.layer.masksToBounds = true
        cell.appImageView.layer.cornerRadius = cell.appImageView.frame.width / 2
        cell.setMainFeedImage(source: source)
        
        return cell
    }
    
    private func setMainFeedImage(source: String) {
        
        self.appImageView.setSocialIcon(source: source)
    }
    
    private func isTypeRecongised(type: String) -> Bool {
        
        if type.lowercased() == "fitbit" {
            
            return true
        } else if type.lowercased() == "facebook" {
            
            return true
        } else if type.lowercased() == "twitter" {
            
            return true
        } else if type.lowercased() == "she" {
            
            return true
        } else if type.lowercased() == "google" {
            
            return true
        } else if type.lowercased() == "notables" {
            
            return true
        } else if type.lowercased() == "spotify" {
            
            return true
        }
        
        return false
    }
    
    private func searchForImages(items: HATFeedObject?, userDomain: String) {
        
        self.hasImage = false
        self.types.removeAll()
        
        if items != nil {
            
            if items!.types != nil {
                
                for name in items!.types! where !items!.types!.isEmpty && self.isTypeRecongised(type: name) {
                    
                    self.types.append(name)
                }
                
                if self.types.isEmpty {
                    
                    self.collectionViewHeight.constant = 0
                } else {
                    
                    self.collectionViewHeight.constant = 30
                }
                
                self.setNeedsLayout()
                self.layoutIfNeeded()
                self.layoutSubviews()
                
                self.collectionView.reloadData()
            }
            
            if let media = items?.content?.media {
                
                if !media.isEmpty {
                    
                    var url: URL?
                    if media[0].url != "" && media[0].url != nil {
                        
                        self.hasImage = true
                        url = URL(string: media[0].url!)
                    } else if media[0].thumbnail != "" && media[0].thumbnail != nil {
                        
                        self.hasImage = true
                        url = URL(string: media[0].thumbnail!)
                    }
                    
                    if self.hasImage {
                        
                        self.imageViewHeight.constant = 188
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                        self.layoutSubviews()
                        
                        self.imageView.cacheImage(resource: url, placeholder: nil, userDomain: userDomain, progressBlock: nil, completionHandler: { [weak self] image, _, _, url in
                            
                            if image == nil {
                                
                                self?.imageView.contentMode = .scaleAspectFit
                                self?.imageView.image = UIImage(named: ImageNamesConstants.failedDownloading)
                            } else {
                                
                                self?.imageView.contentMode = .scaleAspectFill
                                self?.imageView.image = image
                            }
                        })
                    }
                }
            } else if let location = items?.location {
                
                self.hasImage = true
                self.generateImageFromLocation(location: location)
            } else {
                
                self.imageViewHeight.constant = 0
                self.setNeedsLayout()
                self.layoutIfNeeded()
                self.layoutSubviews()
            }
        }
    }
    
    private func generateImageFromLocation(location: HATFeedLocationObject?) {
        
        guard let location = location else { return }
        
        self.imageViewHeight.constant = 188
        self.imageView.image = UIImage(named: ImageNamesConstants.generatingMap)
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        if let geocode = location.geo {
            
            LocationManager.generateImageBaseOn(latitude: Double(geocode.latitude), longitude: Double(geocode.longitude), completion: { [weak self] image in
                
                self?.imageView.contentMode = .scaleAspectFill
                self?.imageView.image = image
            })
        } else if let address = location.address {
            
            if let name = address.name {
                
                LocationManager.geoCodeUsingAddress(address: name, completion: { [weak self] image in
                    
                    self?.imageView.contentMode = .scaleAspectFill
                    self?.imageView.image = image
                })
            }
        }
    }
    
    private func setDate(unixTimeStamp: Int) {
        
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimeStamp))
        let stringDate = FormatterManager.formatDateStringToUsersDefinedDate(date: date, dateStyle: .short, timeStyle: .short).replacingOccurrences(of: " - ", with: " ")
        self.dateLabel.text = "Posted on \(stringDate)"
    }
    
    private func setDate(date: Date?) {
        
        guard let date = date else {
            
            return
        }
        
        let stringDate = FormatterManager.formatDateStringToUsersDefinedDate(date: date, dateStyle: .short, timeStyle: .short).replacingOccurrences(of: " - ", with: " ")
        self.dateLabel.text = "Posted on \(stringDate)"
    }
    
    private func setTitle(title: String) {
        
        if title != "" {
            
            self.hatNameLabel.text = title
        }
    }
    
    private func setSubtitle(subtitle: String?) {
        
        if subtitle != nil {

            self.dataLabel.text = subtitle!.trimString()
        } else {

            self.dataLabel.text = ""
        }
    }
    
    private func setShared(shared: String?) {
        
        if shared != nil {
            
            self.sharedlabel.text = shared
        } else {
            
            self.sharedlabel.text = ""
        }
    }
    
    override func prepareForReuse() {
        
        self.imageView.image = nil
        self.hasImage = false
        self.feedItem = nil
        self.types.removeAll()
    }
}
