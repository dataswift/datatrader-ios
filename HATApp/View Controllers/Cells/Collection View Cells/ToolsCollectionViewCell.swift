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

class ToolsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var toolImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var enableToolButton: UIButton!
    
    // MARK: - Variable
    
    private var delegate: ToolsDelegate?
    private var tool: HATToolsObject?
    
    // MARK: - IBACtions
    
    @IBAction func connectToolButtonAction(_ sender: Any) {
        
        guard self.tool != nil else { return }
        
        self.delegate?.connectTool(tool!)
    }
    
    // MARK: - Setup cell
    
    static func setupCell(indexPath: IndexPath, collectionView: UICollectionView, tool: HATToolsObject, delegate: ToolsDelegate?) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.toolsCell, for: indexPath) as? ToolsCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.toolsCell, for: indexPath)
        }
        
        cell.delegate = delegate
        cell.tool = tool
        cell.setUpUI(tool: tool)
        
        return cell
    }
    
    private func setUpUI(tool: HATToolsObject) {
        
        self.layer.cornerRadius = 5
        
        self.titleLabel.text = tool.info.name
        self.descriptionLabel.text = tool.info.headline
        let stringURL = tool.info.graphics.logo.normal
        if let url = URL(string: stringURL)  {
            
            self.toolImageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: nil,
                progressBlock: nil,
                completionHandler: nil)
        }
        
        if !tool.status.available {
            
            self.enableToolButton.isHidden = true
        } else if tool.status.enabled && tool.status.available {
            
            self.enableToolButton.isHidden = false
            self.enableToolButton.setImage(UIImage(named: ImageNamesConstants.checkmarkYellow), for: .normal)
        }
    }
    
    // MARK: - Prepare for reuse
    
    override func prepareForReuse() {
        
        self.enableToolButton.setImage(UIImage(named: ImageNamesConstants.add), for: .normal)
    }
}
