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
import SafariServices

// MARK: Class

internal class DataPlugsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    /// The data plug model to set up the cell
    private var plug: HATApplicationObject?
    /// The app token of the data plug
    private var userToken: String?
    private var userDomain: String?
    /// The delegate of the cell
    private var delegate: DataPlugsDelegate?
    
    // MARK: - IBOutlets
    
    /// An IBOutlet to handle the image view of the plug
    @IBOutlet private weak var plugImageView: UIImageView!
    /// An IBOutlet to handle the title of the plug
    @IBOutlet private weak var plugTitle: UILabel!
    /// An IBOutlet to handle the description of the plug
    @IBOutlet private weak var plugDescription: UILabel!
    @IBOutlet private weak var buttonView: UIView!
    /// An IBOutlet to handle the button of the plug
    @IBOutlet private weak var plugButton: UIButton!
    
    // MARK: - IBActions
    
    /**
     The cell's button action to execute on tap
     
     - parameter sender: The object that called the object
     */
    @IBAction func plugButtonAction(_ sender: Any) {
        
        guard let plug: HATApplicationObject = self.plug else {
            
            return
        }
        
        delegate?.connectPlugInSafari(plug: plug)
    }
    
    // MARK: - Set up
    
    /**
     Sets up the cell according to the plug model
     
     - parameter collectionView: The collectionView to display the cell
     - parameter userToken: Ther user's token
     - parameter userDomain: The user's domain
     - parameter dataPlug: The data plug model to use in order to set up the plug
     - parameter delegate: The delegate of the cell, used to inform the delegate on connection of the plug
     
     - returns: The just set up cell
     */
    static func setUpCell(collectionView: UICollectionView, indexPath: IndexPath, userToken: String, userDomain: String, dataPlug: HATApplicationObject, delegate: DataPlugsDelegate?) -> UICollectionViewCell {
    
        guard let cell: DataPlugsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.dataPlugCell, for: indexPath) as? DataPlugsCollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiersConstants.dataPlugCell, for: indexPath)
        }
        
        cell.layer.cornerRadius = 5
        
        cell.plugTitle.text = dataPlug.application.id.capitalized
        cell.plugDescription.text = dataPlug.application.info.headline
        cell.plug = dataPlug
        cell.delegate = delegate
        cell.userToken = userToken
        cell.userDomain = userDomain
        cell.getImage(dataPlug: dataPlug, userToken: userToken)
        
        ApplicationConnectionState.updateStatusCellButton(cell.plugButton, basedOn: dataPlug)
        
        return cell
    }
    
    private func getImage(dataPlug: HATApplicationObject, userToken: String) {
        
        guard let url: URL = URL(string: dataPlug.application.info.graphics.logo.normal) else {
            
            return
        }
        
        self.plugImageView.layer.masksToBounds = true
        self.plugImageView.layer.cornerRadius = self.plugImageView.frame.width / 2
        self.plugImageView.downloadedFrom(
            url: url,
            userToken: userToken,
            progressUpdater: nil,
            completion: nil)
    }
}
