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

internal class DataPlugsDetailsFeedCollectionViewCell: UICollectionViewCell, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    weak var delegate: FeedRefreshCellDelegate?
    private var indexPath: IndexPath?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var feedArrow: UIImageView!
    @IBOutlet private weak var cellView: UIView!
    @IBOutlet private weak var feedItemImageView: UIImageView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var secondaryImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var showMoreButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func showMoreButtonAction(_ sender: Any) {
        
        delegate?.showMoreButtonClicked(indexPath: self.indexPath!, cell: self)
    }
    
    // MARK: - Set up cell
    
    class func setUp(collectionView: UICollectionView, indexPath: IndexPath, feedObject: HATFeedObject, reuseIdentifier: String, delegate: FeedRefreshCellDelegate) -> UICollectionViewCell {
        
        guard let cell: DataPlugsDetailsFeedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DataPlugsDetailsFeedCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        }
        
        cell.makeMainViewCornersRounded()
        cell.setTitle(title: feedObject.title.text)
        cell.setContent(content: feedObject.content?.text)
        cell.setSubtitle(subtitle: feedObject.title.subtitle)
        cell.setDate(feedObject: feedObject)
        cell.indexPath = indexPath
        cell.delegate = delegate
        cell.setMainFeedImage(source: feedObject.source)
        cell.setSecondaryImage(feedObject: feedObject)
        cell.delegate?.resizeCellAt(indexPath: indexPath, cell: cell)
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
    
    private func makeMainViewCornersRounded() {
        
        self.mainView.layer.cornerRadius = 5
    }
    
    private func setDate(feedObject: HATFeedObject) {
        
        if self.dateLabel != nil {
            
            let date = FormatterManager.formatStringToDate(string: feedObject.date.iso)//feedObject.date.unix
            let dateString = FormatterManager.formatDateStringToUsersDefinedDate(date: date!, dateStyle: .none, timeStyle: .short)
            
            self.dateLabel.text = dateString
        }
    }
    
    private func createLeftArrowInMainView() {
        
        self.mainView.addPikeOnView(side: .Left, size: 8)
    }
    
    private func setTitle(title: String) {
        
        if title != "" {
            
            self.titleLabel.text = title
        }
    }
    
    private func setContent(content: String?) {
        
        if content != nil && self.contentLabel != nil {
            
            self.contentLabel.text = content!.trimString()
        } else if self.contentLabel != nil {
            
            self.contentLabel.text = ""
        }
    }
    
    private func setSubtitle(subtitle: String?) {
        
        if subtitle != nil && self.subtitleLabel != nil {
            
            self.subtitleLabel.text = subtitle!.trimString()
        } else if self.subtitleLabel != nil {
            
            self.subtitleLabel.text = ""
        }
    }
    
    private func setMainFeedImage(source: String) {
        
        self.feedItemImageView.setSocialIcon(source: source)
    }
    
    private func setSecondaryImage(feedObject: HATFeedObject) {
        
        guard let action = feedObject.title.action else {
            
            self.secondaryImageView.isHidden = true
            return
        }
        
        if action == "steps" {
            
            self.secondaryImageView.image = UIImage(named: ImageNamesConstants.steps)
        }
    }
    
    private func setSecondaryImage(url: String) {
        
        guard let tempURL = URL(string: url) else {
            
            return
        }
        self.secondaryImageView.downloadedFrom(url: tempURL, userToken: userToken, progressUpdater: nil, completion: nil)
    }
    
    override func prepareForReuse() {
        
        self.feedItemImageView.image = nil
        self.titleLabel.text = nil
        self.secondaryImageView.image = nil
        
        if self.contentLabel != nil {
            
            self.contentLabel.text = nil
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
//        let width = UIScreen.main.bounds.width - 80//self.frame.width
//        let size = self.mainView.systemLayoutSizeFitting(CGSize(width: width, height: 1), withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow)
//        layoutAttributes.frame.size.height = size.height + 39
        
        return layoutAttributes
    }
}
