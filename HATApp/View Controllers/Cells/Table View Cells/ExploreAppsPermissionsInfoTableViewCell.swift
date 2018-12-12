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

class ExploreAppsPermissionsInfoTableViewCell: UITableViewCell, UserCredentialsProtocol {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var applicationImageView: UIImageView!
    @IBOutlet private weak var applicationNameLabel: UILabel!
    @IBOutlet private weak var applicationGradeLabel: UILabel!
    @IBOutlet private weak var applicationPermissionDescriptionLabel: UILabel!
    
    // MARK: - Variables
    
    /// An optional SafariDelegateProtocol. Used to open the termsURL in Safari on button tap
    private weak var safariDelegate: SafariDelegateProtocol?
    
    // MARK: - Table view cell functions
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Set up cell

    class func setUp(tableView: UITableView, application: HATApplicationObject, indexPath: IndexPath, delegate: SafariDelegateProtocol?) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.appPermissionInformationCell, for: indexPath) as? ExploreAppsPermissionsInfoTableViewCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.appPermissionInformationCell, for: indexPath)
        }
        
        cell.updateLabels(application: application)
        cell.safariDelegate = delegate
        cell.applicationImageView.layer.masksToBounds = true
        cell.applicationImageView.layer.cornerRadius = cell.applicationImageView.frame.width / 2
        cell.applicationImageView.addBorder(width: 9, color: .white)

        if let url = URL(string: application.application.info.graphics.logo.normal) {
            
            cell.applicationImageView.cacheImage(
                resource: url,
                placeholder: nil,
                userDomain: cell.userDomain,
                progressBlock: nil,
                completionHandler: nil)
        }
        
        return cell
    }
    
    // MARK: - Update labels
    
    private func updateLabels(application: HATApplicationObject) {
        
        self.applicationNameLabel.text = application.application.info.name
        self.applicationPermissionDescriptionLabel.text = "\(application.application.info.name.capitalized) needs to read and/or write into your HAT microserver and will have the ability to take actions in your HAT. By agreeing, you confirm that you grant the permissions below."
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.learnMoreLabelTapped))
        tapGesture.numberOfTapsRequired = 1
        self.applicationGradeLabel.isUserInteractionEnabled = true
        self.applicationGradeLabel.addGestureRecognizer(tapGesture)
        
        if let rating = application.application.info.rating?.score {
            
            let newsString: NSMutableAttributedString = NSMutableAttributedString(string: "Rating: \(rating). Learn more")
            let startingPosition = newsString.string.count - 10
            newsString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], range: NSRange.init(location: startingPosition, length: 10))
            self.applicationGradeLabel.attributedText = newsString.copy() as? NSAttributedString
        } else {
            
            let newsString: NSMutableAttributedString = NSMutableAttributedString(string: "Rating: unrated. Learn more")
            let startingPosition = newsString.string.count - 10
            newsString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], range: NSRange.init(location: startingPosition, length: 10))
            self.applicationGradeLabel.attributedText = newsString.copy() as? NSAttributedString
        }
    }
    
    @objc
    private func learnMoreLabelTapped() {
        
        let url = "https://www.hatcommunity.org/hat-dex-rating"
        
        safariDelegate?.openInSafari(url: url, animated: true, completion: nil)
    }
}
