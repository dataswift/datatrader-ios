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
import MapKit

// MARK: Class

internal class DataPlugsDetailsImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: FeedRefreshCellDelegate?
    private var feedObject: HATFeedObject?
    var image: UIImage?
    private var indexPath: IndexPath?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var imageUIView: UIView!
    @IBOutlet private weak var darkImageOverlayView: UIView!
    @IBOutlet private weak var plugFeedItemImageView: UIImageView!
    @IBOutlet private weak var feedArrowImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var imageDescriptionLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleAndImageView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var showMoreButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func showMoreButtonAction(_ sender: Any) {
        
        delegate?.showMoreButtonClicked(indexPath: self.indexPath!, cell: self)
    }
    
    // MARK: - Set up cell
    
    class func setUpCellCached(collectionView: UICollectionView, feedObject: HATFeedObject, image: UIImage?, indexPath: IndexPath, showDate: Bool = false) -> UICollectionViewCell {
        
        guard let cell: DataPlugsDetailsImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.plugFeedImageCell, for: indexPath) as? DataPlugsDetailsImageCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.plugFeedImageCell, for: indexPath)
        }
        
        cell.makeMainViewCornersRounded()
        cell.setTitle(title: feedObject.title.text)
        cell.setSubtitle(feedObject: feedObject)
        cell.setImageDescriptionLabel(feedObject: feedObject)
        cell.setMainFeedImage(source: feedObject.source)
        cell.mainImageView.image = image
        cell.image = image
        cell.feedObject = feedObject
        cell.indexPath = indexPath
        cell.setDate(feedObject: feedObject)
        cell.updateShoreMoreButton(feedItem: feedObject)
        cell.setNeedsLayout()
        
        return cell
    }
    
    class func setUp(collectionView: UICollectionView, indexPath: IndexPath, feedObject: HATFeedObject, userToken: String, userDomain: String, delegate: FeedRefreshCellDelegate) -> UICollectionViewCell {
        
        guard let cell: DataPlugsDetailsImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.plugFeedImageCell, for: indexPath) as? DataPlugsDetailsImageCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.plugFeedImageCell, for: indexPath)
        }
        
        cell.setDate(feedObject: feedObject)
        cell.makeMainViewCornersRounded()
        cell.delegate = delegate
        cell.indexPath = indexPath
        cell.feedObject = feedObject
        cell.setTitle(title: feedObject.title.text)
        cell.setSubtitle(feedObject: feedObject)
        cell.setMainFeedImage(source: feedObject.source)
        cell.setImageDescriptionLabel(feedObject: feedObject)
        cell.checkForImage(feedObject: feedObject, indexPath: indexPath, userToken: userToken, userDomain: userDomain)
        cell.updateShoreMoreButton(feedItem: feedObject)
        
        return cell
    }
    
    private func updateShoreMoreButton(feedItem: HATFeedObject) {
        
        if feedItem.source.contains("grouped") {
            
            self.showMoreButton.isHidden = false
            let itemsHidden = feedItem.source.split(separator: " ").last
            let buttonTitle = "Show \(itemsHidden!)  more"
            self.showMoreButton.setTitle(buttonTitle, for: .normal)
        } else {
            
            self.showMoreButton.isHidden = true
        }
    }
    
    private func checkForImage(feedObject: HATFeedObject, indexPath: IndexPath, userToken: String, userDomain: String) {
        
        if feedObject.content?.media != nil {
            
            guard !feedObject.content!.media!.isEmpty else { return }
            
            self.setMainImage(feedObject: self.feedObject!, indexPath: indexPath, delegate: delegate, userDomain: userDomain)
        } else if feedObject.location?.geo != nil {
            
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(feedObject.location!.geo!.latitude), longitude: CLLocationDegrees(feedObject.location!.geo!.longitude))
            self.getLocationAsImage(coordinates: coordinates, indexPath: indexPath)
        } else {
            
            self.getLocationAsImage(locationString: feedObject.location?.address?.name, indexPath: indexPath)
            self.imageDescriptionLabel.text = feedObject.location?.address?.name
        }
    }
    
    private func setDate(feedObject: HATFeedObject) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let weakSelf = self else {
                
                return
            }
            
            if weakSelf.dateLabel != nil {
                
                let date = FormatterManager.formatStringToDate(string: feedObject.date.iso)//feedObject.date.unix
                let dateString = FormatterManager.formatDateStringToUsersDefinedDate(date: date!, dateStyle: .none, timeStyle: .short)
                
                DispatchQueue.main.async {
                   
                    weakSelf.dateLabel.text = dateString
                }
            }
        }
    }
    
    private func getLocationAsImage(coordinates: CLLocationCoordinate2D, indexPath: IndexPath) {
        
        LocationManager.generateImageBaseOn(coordinates: coordinates, completion: { [weak self] image in
            
            guard let weakSelf = self else { return }
            
            weakSelf.mainImageView.image = image
            weakSelf.delegate?.resizeCellAt(indexPath: indexPath, cell: weakSelf)
        })
    }
    
    private func getLocationAsImage(locationString: String?, indexPath: IndexPath) {
        
        self.mainImageView.image = nil
        if locationString != nil {
            
            LocationManager.geoCodeUsingAddress(address: locationString!, completion: { [weak self] image in
                
                guard let weakSelf = self else { return }
                
                weakSelf.mainImageView.image = image
                weakSelf.delegate?.resizeCellAt(indexPath: indexPath, cell: weakSelf)
            })
        }
    }
    
    func makeMainViewCornersRounded() {
        
        self.mainView.layer.cornerRadius = 5
        self.titleAndImageView.layer.cornerRadius = 5
    }
    
    private func createLeftArrowInMainView() {
        
        self.mainView.addPikeOnView(side: .Left, size: 8)
    }
    
    private func setTitle(title: String) {
        
        self.titleLabel.text = title
    }
    
    private func setSubtitle(feedObject: HATFeedObject) {
        
        self.subtitleLabel.text = feedObject.title.subtitle

    }
    
    private func setMainFeedImage(source: String) {
        
        self.plugFeedItemImageView.setSocialIcon(source: source)
    }
    
    func setImageDescriptionLabel(feedObject: HATFeedObject) {
        
        guard let comment = feedObject.content?.text else {
            
            self.imageDescriptionLabel.isHidden = true
            return
        }
        
        self.imageDescriptionLabel.isHidden = false
        self.imageDescriptionLabel.text = comment
    }
    
    func setImageDescriptionLabel(string: String?) {
        
        self.imageDescriptionLabel.isHidden = false
        self.imageDescriptionLabel.text = string
    }
    
    func setMainImage(feedObject: HATFeedObject, indexPath: IndexPath, delegate: FeedRefreshCellDelegate?, userDomain: String) {
        
        guard feedObject.content != nil,
            let media = feedObject.content?.media,
            !feedObject.content!.media!.isEmpty else {
                
                return
        }
        
        let urlString: String
        if media[0].thumbnail != nil {
            
            urlString = media[0].thumbnail!
        } else if media[0].url != nil {
            
            urlString = media[0].url!
        } else {
            
            urlString = ""
        }
        guard let url = URL(string: urlString) else {
            
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let weakSelf = self else {
                
                return
            }
            
            weakSelf.mainImageView.cacheImage(resource: url, placeholder: nil, userDomain: userDomain, progressBlock: nil, completionHandler: { image, error, test2, test3 in
                
                DispatchQueue.main.async {
                    
                    weakSelf.image = image
                    weakSelf.makeMainViewCornersRounded()
                    weakSelf.delegate?.resizeCellAt(indexPath: indexPath, cell: weakSelf)
                }
            })
        }
        
    }

    override func prepareForReuse() {

        self.plugFeedItemImageView.image = nil
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
        self.dateLabel.text = nil
        self.imageDescriptionLabel.text = nil
        self.mainImageView.image = nil
        self.indexPath = nil
        self.feedObject = nil
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        layoutAttributes.frame.size.height = 263

        return layoutAttributes
    }
    
}
