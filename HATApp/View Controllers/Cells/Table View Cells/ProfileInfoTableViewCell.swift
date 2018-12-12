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

internal class ProfileInfoTableViewCell: UITableViewCell, UserCredentialsProtocol {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var hatNameLabel: UILabel!
    @IBOutlet private weak var clusterNameLabel: UILabel!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var storageUsedLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var spaceWarningLabel: UILabel!
    
    // MARK: - View Controller functions
        
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell() -> ProfileInfoTableViewCell {
        
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.addBorder(width: 6, color: .white)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        
        HATProfileService.setHATName(userDomain: userDomain, hatNameLabel: self.hatNameLabel, clusterNameLabel: self.clusterNameLabel)
        self.getProfileImageFromHAT()
        self.getStorageFromHAT()
        
        self.mainView.addShadow(color: .darkGray, shadowRadius: 3, shadowOpacity: 0.6, width: 1, height: 0)
        self.mainView.layer.cornerRadius = 5
        
        return self
    }
    
    func getStorageFromHAT() {
        
        HATService.updateSystemStats(
            userToken: userToken,
            userDomain: userDomain,
            systemStatusString: updateSystemStatus,
            usedPercentage: updateUsedProgressBar,
            newUserToken: setNewToken,
            errorCallback: errorCheckingStatus)
    }
    
    private func errorCheckingStatus(error: JSONParsingError) {
        
    }
    
    private func updateSystemStatus(text: String) {
        
        self.storageUsedLabel.text = text
    }
    
    private func updateUsedProgressBar(usedPercentage: Float) {
        
        self.progressBar.setProgress(usedPercentage, animated: true)

        if usedPercentage > 0.9 {
            
            self.progressBar.progressTintColor = .hatPasswordRed
            self.spaceWarningLabel.isHidden = false
            self.spaceWarningLabel.text = "Your HAT storage is reaching the maximum allowance."
            self.spaceWarningLabel.textColor = .hatPasswordRed
        } else if usedPercentage > 0.75 {
            
            self.progressBar.progressTintColor = .hatPasswordOrange
        }
    }
    
    private func setNewToken(newToken: String?) {
        
       KeychainManager.setKeychainValue(key: KeychainConstants.userToken, value: newToken)
    }
    
    private func getProfileImageFromHAT() {
        
        HATProfileService.getProfile(
            userDomain: userDomain,
            userToken: userToken,
            successCallback: gotProfile,
            failCallback: receivedErrorGettingProfile)
    }
    
    private func gotProfile(profile: HATProfileObject, newUserToken: String?) {
        
        func downloadImage() {
            
            ImageManager.downloadProfileImage(profile: profile, on: self.profileImageView, userToken: userToken)
        }
        
        if let profileImage = CacheManager<HATProfileObject>.retrieveImage(fromCache: "images", forKey: "profile", networkRequest: downloadImage) {
            
            DispatchQueue.main.async { [weak self] in
                
                guard let weakSelf = self else { return }
                
                if profileImage != UIImage(named: ImageNamesConstants.profilePlaceholder) {
                    
                    weakSelf.profileImageView.layer.masksToBounds = true
                    weakSelf.profileImageView.layer.cornerRadius = weakSelf.profileImageView.frame.width / 2
                    weakSelf.profileImageView.image = profileImage
                } else {
                    
                    downloadImage()
                }
            }
        }
    }
    
    private func receivedErrorGettingProfile(error: HATTableError) {
        
    }
}
