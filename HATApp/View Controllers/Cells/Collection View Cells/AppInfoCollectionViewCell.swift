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

class AppInfoCollectionViewCell: UICollectionViewCell, UserCredentialsProtocol {
    
    @IBOutlet private weak var appBackgroundImageView: UIImageView!
    @IBOutlet private weak var appImageView: UIImageView!
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var appInfoSectionLabel: UILabel!
    @IBOutlet private weak var dataPreviewSectionLabel: UILabel!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var indicatorImageView: UIImageView!
    @IBOutlet private weak var appInfoView: UIView!
    @IBOutlet private weak var goToButton: UIButton!
    @IBOutlet private weak var indicatorCenterAlignmentConstraint: NSLayoutConstraint!
    @IBOutlet private weak var errorLabelToRatingLabelVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomSpaceVerticalConstraint: NSLayoutConstraint!
    @IBOutlet private weak var appNameTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var goldRateLabel: UILabel!
    @IBOutlet private weak var rateImageView: UIImageView!
    
    private var selectedSection: Int = 0
    weak var delegate: CollectionViewCellNotificationDelegate?
    
    // MARK: - Setup cell
    
    static func setupCell(indexPath: IndexPath, collectionView: UICollectionView, name: String, rating: String? = nil, bannerURL: String, logoURL: String, state: ApplicationConnectionState, type: String, delegate: CollectionViewCellNotificationDelegate) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appDescriptionCell", for: indexPath) as? AppInfoCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "appDescriptionCell", for: indexPath)
        }
        
        cell.delegate = delegate
        cell.setUpView(title: name, logoURL: logoURL, bannerURL: bannerURL, rating: rating)
        cell.addGestureRecognisersToSectionIndicators()
        ApplicationConnectionState.updateButton(cell.goToButton, basedOn: state, andType: type)
        ApplicationConnectionState.updateLabel(cell.errorMessageLabel, basedOn: state)
        cell.updateUI()

        cell.appImageView.bringSubviewToFront(cell.appInfoView)
        cell.appImageView.layer.masksToBounds = true
        cell.appImageView.layer.cornerRadius = cell.appImageView.frame.width / 2
        cell.appImageView.addBorder(width: 6, color: .white)

        return cell
    }
    
    private func updateUI() {
        
        self.appInfoView.layer.cornerRadius = 5
        self.appInfoView.addShadow(color: .darkGray, shadowRadius: 3, shadowOpacity: 0.6, width: 1, height: 0)
        
        self.appImageView.layer.cornerRadius = 5
        self.appImageView.layer.masksToBounds = true
        
        if self.goToButton != nil {
            
            self.goToButton.layer.cornerRadius = 5
        }
        
        if errorMessageLabel.text == "" && ratingLabel.text == "" {
            
            self.bottomSpaceVerticalConstraint.constant = 0
            self.errorLabelToRatingLabelVerticalSpacingConstraint.constant = 0
        } else if errorMessageLabel.text == "" || ratingLabel.text == "" {
            
            self.errorLabelToRatingLabelVerticalSpacingConstraint.constant = 0
        }
    }
    
    // MARK: - Set up View
    
    /**
     Sets up the view according to the plug object that has been passed on from the previous UIViewController
     */
    
    private func setUpView(title: String, logoURL: String, bannerURL: String, rating: String?) {
        
        if let appImageURL: URL = URL(string: logoURL) {
            
            DispatchQueue.main.async {
                
                if let appBackgroundImageURL: URL = URL(string: bannerURL) {
                    
                    self.appBackgroundImageView.cacheImage(
                        resource: appBackgroundImageURL,
                        placeholder: nil,
                        userDomain: self.userDomain,
                        progressBlock: nil,
                        completionHandler: nil)
                }
                
                let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.addActivityIndicator(onView: self.appImageView)
                self.appImageView.cacheImage(
                    resource: appImageURL,
                    placeholder: nil,
                    userDomain: self.userDomain,
                    progressBlock: nil,
                    completionHandler: { image, error, cacheType, url in
                    
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    }
                )
            }
        }
        
        self.appNameLabel.text = title.capitalized
        
        if let rating = rating {
            
            let partOne = NSAttributedString(
                string: "This app scores an \(rating) rating for data exchange ",
                attributes: [NSAttributedString.Key.font: UIFont.openSansItalic(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.sectionTextColor])
            
            let partTwo = NSAttributedString(
                string: "Learn more",
                attributes: [NSAttributedString.Key.font: UIFont.openSansExtrabold(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.selectionColor])
            
            self.addGestureRecogniserToRatingLabel()
            self.ratingLabel.attributedText = partOne.combineWith(attributedText: partTwo)
            
            let grade = NSAttributedString(
                string: rating,
                attributes: [NSAttributedString.Key.font: UIFont.openSansExtrabold(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            let rated = NSAttributedString(
                string: "",
                attributes: [NSAttributedString.Key.font: UIFont.openSansItalic(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.white])
            self.goldRateLabel.attributedText = grade.combineWith(attributedText: rated)

            self.rateImageView.isHidden = false
            self.goldRateLabel.isHidden = false
        } else {
            
            if self.appNameTopConstraint != nil {
                
                self.appNameTopConstraint.constant = 10
            }
        }
    }
    
    // MARK: - Gesture Recognisers
    
    private func addGestureRecognisersToSectionIndicators() {
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(appInfoSectionTapped))
        self.appInfoSectionLabel.addGestureRecognizer(tapGesture1)
        self.appInfoSectionLabel.isUserInteractionEnabled = true
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dataPreviewSectionTapped))
        self.dataPreviewSectionLabel.addGestureRecognizer(tapGesture2)
        self.dataPreviewSectionLabel.isUserInteractionEnabled = true
    }
    
    private func addGestureRecogniserToRatingLabel() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.ratingLabelTapped))
        self.ratingLabel.addGestureRecognizer(gesture)
        self.ratingLabel.isUserInteractionEnabled = true
    }
    
    @objc
    private func ratingLabelTapped() {
        
        self.delegate?.openSafari(to: "https://www.hatcommunity.org/hat-dex-rating")
    }
    
    @objc
    private func appInfoSectionTapped() {
        
        self.selectedSection = 0
        self.animateIndicator(
            cell: self,
            completion: { [weak self] in
            
                guard let weakSelf = self else {
                    
                    return
                }
                weakSelf.delegate?.indicatorTabsTapped(selectedIndex: weakSelf.selectedSection)
            }
        )
    }
    
    @objc
    private func dataPreviewSectionTapped() {
        
        self.selectedSection = 1
        self.animateIndicator(
            cell: self,
            completion: { [weak self] in
                
                guard let weakSelf = self else {
                    
                    return
                }
                weakSelf.delegate?.indicatorTabsTapped(selectedIndex: weakSelf.selectedSection)
            }
        )
    }
    
    // MARK: - Animate indicator
    
    private func animateIndicator(cell: AppInfoCollectionViewCell, completion: (()-> Void)? = nil) {
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .allowAnimatedContent,
            animations: {
                
                let xPos: CGFloat
                if cell.selectedSection == 0 {
                    
                    xPos = 0
                    
                    cell.appInfoSectionLabel.font = UIFont.openSansSemibold(ofSize: 13)
                    cell.dataPreviewSectionLabel.font = UIFont.openSansLight(ofSize: 13)
                } else {
                    
                    xPos = cell.dataPreviewSectionLabel.frame.midX - cell.appInfoSectionLabel.frame.midX
                    
                    cell.appInfoSectionLabel.font = UIFont.openSansLight(ofSize: 13)
                    cell.dataPreviewSectionLabel.font = UIFont.openSansSemibold(ofSize: 13)
                }
                
                cell.indicatorCenterAlignmentConstraint.constant = xPos
                cell.layoutIfNeeded()
            },
            completion: { _ in
                
                completion?()
            }
        )
    }
}
