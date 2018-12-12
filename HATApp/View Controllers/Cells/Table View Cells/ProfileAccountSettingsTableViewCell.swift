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

internal class ProfileAccountSettingsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UserCredentialsProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var hatNameLabel: UILabel!
    @IBOutlet private weak var clusterNameLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    
    private var socialButtons: [SocialButton] = []
    private var profile: HATProfileObject?
    private var sharedMedia: Dictionary<String, String>?
    weak var safariDelegate: SafariDelegateProtocol?
    weak var imageViewControllerDelegate: AccountSettingsViewController?
    
    // MARK: - View Controller functions
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.mainView.addShadow(color: .darkGray, shadowRadius: 3, shadowOpacity: 0.6, width: 1, height: 0)
        self.mainView.layer.cornerRadius = 5
        
        self.profileImageView.addBorder(width: 6, color: .white)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
                
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.openProfileInSafari))
        self.mainView.addGestureRecognizer(gestureRecogniser)
        
        HATProfileService.setHATName(userDomain: userDomain, hatNameLabel: self.hatNameLabel, clusterNameLabel: self.clusterNameLabel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Set up Cell
    
    func setUpCell(profile: HATProfileObject, sharedMedia: Dictionary<String, String>?, delegate: SafariDelegateProtocol?, imageViewControllerDelegate: AccountSettingsViewController?) -> ProfileAccountSettingsTableViewCell {
        
        self.profile = profile
        self.safariDelegate = delegate
        self.imageViewControllerDelegate = imageViewControllerDelegate
        
        if self.profileImageView.image == UIImage(named: ImageNamesConstants.profilePlaceholder) {
            
            DispatchQueue.global().async { [weak self] in
                
                guard let weakSelf = self else {
                    
                    return
                }
                
                let getProfileImage = {
                    
                    ImageManager.downloadProfileImage(profile: weakSelf.profile, on: weakSelf.profileImageView, userToken: weakSelf.userToken)
                }
                if let profileImage = CacheManager<HATProfileObject>.retrieveImage(fromCache: "images", forKey: "profile", networkRequest: getProfileImage) {
                    
                    DispatchQueue.main.async {
                        
                        weakSelf.changeProfileImage(profileImage)
                    }
                }
            } 
        }
        
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.showActionSheet))
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(gestureRecogniser)
        self.sharedMedia = sharedMedia
        
        self.checkForSocialLinks()
        
        return self
    }
    
    @objc
    private func openProfileInSafari() {
        
        self.safariDelegate?.openInSafari(url: "https://\(userDomain)", animated: true, completion: nil)
    }
    
    func changeProfileImage(_ image: UIImage?) {
        
        UIView.transition(with: self.profileImageView, duration: 5, options: .transitionCrossDissolve, animations: {
            
            self.profileImageView.image = image
        }, completion: nil)
    }
    
    func getProfileImage() -> UIImage? {
        
        return self.profileImageView.image
    }
    
    func getProfileImageView() -> UIImageView {
        
        return self.profileImageView
    }
    
    // MARK: - Collection View functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.socialButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.socialButtonCell, for: indexPath) as? AccountSocialButtonsCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.socialButtonCell, for: indexPath)
        }
        
        let tempCell = cell.setUpCell(button: self.socialButtons[indexPath.row], delegate: self.safariDelegate)
        return tempCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        let totalCellWidth = 35 * self.socialButtons.count
        let totalSpacingWidth = 5 * (self.socialButtons.count - 1)
        
        let leftInset = (self.collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    private func checkForSocialLinks() {
        
        self.socialButtons.removeAll()
        
        guard let profile = profile,
            self.sharedMedia != nil else {
            
            return
        }
        
        if profile.data.online.website != "" && self.sharedMedia!.values.contains("online.website") {
            
            var button: SocialButton = SocialButton()
            button.name = "website"
            button.url = profile.data.online.website
            button.button = UIButton()
            button.button?.setImage(UIImage(named: ImageNamesConstants.website), for: .normal)
            
            self.socialButtons.append(button)
        }
        if profile.data.online.youtube != "" && self.sharedMedia!.values.contains("online.youtube") {
            
            var button: SocialButton = SocialButton()
            button.name = "youtube"
            button.url = profile.data.online.youtube
            button.button = UIButton()
            button.button?.setImage(UIImage(named: ImageNamesConstants.youtube), for: .normal)
            
            self.socialButtons.append(button)
        }
        if profile.data.online.linkedin != "" && self.sharedMedia!.values.contains("online.linkedin")  {
            
            var button: SocialButton = SocialButton()
            button.name = "linkedin"
            button.url = profile.data.online.linkedin
            button.button = UIButton()
            button.button?.setImage(UIImage(named: ImageNamesConstants.linkedIn), for: .normal)
            
            self.socialButtons.append(button)
        }
        if profile.data.online.facebook != "" && self.sharedMedia!.values.contains("online.facebook") {
            
            var button: SocialButton = SocialButton()
            button.name = "facebook"
            button.url = profile.data.online.facebook
            button.button = UIButton()
            button.button?.setImage(UIImage(named: ImageNamesConstants.facebookGray), for: .normal)

            self.socialButtons.append(button)
        }
        if profile.data.online.twitter != "" && self.sharedMedia!.values.contains("online.twitter") {
            
            var button: SocialButton = SocialButton()
            button.name = "twitter"
            button.url = profile.data.online.twitter
            button.button = UIButton()
            button.button?.setImage(UIImage(named: ImageNamesConstants.twitterGray), for: .normal)

            self.socialButtons.append(button)
        }
        if profile.data.online.google != "" && self.sharedMedia!.values.contains("online.google") {
            
            var button: SocialButton = SocialButton()
            button.name = "google"
            button.url = profile.data.online.google
            button.button = UIButton()
            button.button?.setImage(UIImage(named: ImageNamesConstants.googleFeedGray), for: .normal)
            
            self.socialButtons.append(button)
        }
        if profile.data.online.blog != "" && self.sharedMedia!.values.contains("online.blog") {
            
            var button: SocialButton = SocialButton()
            button.name = "blog"
            button.url = profile.data.online.blog
            button.button = UIButton()
            button.button?.setImage(UIImage(named: ImageNamesConstants.blog), for: .normal)
            
            self.socialButtons.append(button)
        }
        
        self.collectionView.reloadData()
    }
    
    // MARK: - Show action sheet
    
    @objc
    private func showActionSheet() {
        
        self.imageViewControllerDelegate?.presentImagePicker()
    }
}
