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

internal class ImagesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Set up
    
    func setUpCell(image: FileUploadObject, indexPath: IndexPath, userToken: String, imageDownloaded: ((UIImage, IndexPath) -> Void)?) -> ImagesCollectionViewCell {
        
        guard let url = URL(string: image.contentURL) else {
            
            return self
        }
        
        self.imageView.downloadedFrom(
            url: url,
            userToken: userToken,
            progressUpdater: nil,
            completion: { [weak self] in
            
                guard let weakSelf = self else {
                    
                    return
                }
                
                imageDownloaded?(weakSelf.imageView.image!, indexPath)
                weakSelf.imageView.cropImage(width: weakSelf.imageView.frame.size.width, height: weakSelf.imageView.frame.size.height)
            }
        )
        
        return self
    }
}
