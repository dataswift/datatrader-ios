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

import Alamofire
import Kingfisher

// MARK: Extension

extension UIImageView {
    
    // MARK: - Download image
    
    /**
     Downloads an Image from a url and shows it in the imageview that called this method
     
     - parameter url: The url to download the image from
     - parameter userToken: The user's token
     - parameter mode: The content mode of the image, default value = scaleAspectFit
     - parameter progressUpdater: A function to execute in order to get the current progress of the download
     - parameter completion: A function to execute when the download has completed
     */
    public func downloadedFrom(url: URL, userToken: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, progressUpdater: ((Double) -> Void)?, completion: (() -> Void)?) {
        
        let headers: Dictionary<String, String> = ["x-auth-token": userToken]
        self.contentMode = mode
        let weakSelf = self
        
        DispatchQueue.main.async {
            
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let manager = Alamofire.SessionManager(configuration: configuration)
            
            manager.request(
                url,
                method: .get,
                parameters: nil,
                encoding: Alamofire.JSONEncoding.default,
                headers: headers).downloadProgress(
                    closure: { progress in
                        
                        progressUpdater?(progress.fractionCompleted)
                }
                ).responseData(
                    completionHandler: { response in
                        
                        guard let data: Data = response.result.value else {
                            
                            self.image = UIImage(named: ImageNamesConstants.failedDownloading)
                            completion?()
                            return
                        }
                        
                        guard let image: UIImage = UIImage(data: data) else {
                            
                            self.image = UIImage(named: ImageNamesConstants.failedDownloading)
                            completion?()
                            return
                        }
                        
                        DispatchQueue.main.async {
                            
                            weakSelf.image = image
                            completion?()
                        }
                }
            ).session.finishTasksAndInvalidate()
        }
    }
    
    // MARK: - Crop image
    
    /**
     Crops image to the specified width and height
     
     - parameter width: The width of the cropped image
     - parameter height: The height of the cropped image
     */
    public func cropImage(width: CGFloat, height: CGFloat) {
        
        guard let image: UIImage = self.image else {
            
            return
        }
        
        var rect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        if Float(image.size.width) > Float(image.size.height) {
            
            print("image is landscape")
            
            rect = CGRect(
                x: 0,
                y: 0,
                width: Int(width),
                height: Int(height))
            
            let scale: CGFloat = height / image.size.height
            let newWidth: CGFloat = image.size.width * scale
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: height))
            
            image.draw(in: CGRect(
                x: 0,
                y: 0,
                width: newWidth,
                height: height))
        } else {
            
            print("image is portrait")
            
            rect = CGRect(
                x: 0,
                y: 0,
                width: Int(width),
                height: Int(height))
            
            let scale: CGFloat = width / image.size.width
            let newHeight: CGFloat = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
            
            image.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
        }
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(1)
        context?.stroke(rect)
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let unwrapImage: UIImage = newImage, let unwrapCGImage: CGImage = unwrapImage.cgImage {
            
            if let imageRef: CGImage = unwrapCGImage.cropping(to: rect) {
                
                let croppedImage: UIImage = UIImage(cgImage: imageRef)
                self.image = croppedImage
            }
        }
    }
    
    /**
     Sets the appropriete image based on the source of the feed item
     
     - parameter source: The source of the feed item. Based on this the app loads the appropriate image
     */
    func setSocialIcon(source: String) {
        
        if source.contains("fitbit") {
            
            self.image = UIImage(named: ImageNamesConstants.fitbitFeed)
        } else if source.contains("facebook") {
            
            self.image = UIImage(named: ImageNamesConstants.facebook)
        } else if source.contains("twitter") {
            
            self.image = UIImage(named: ImageNamesConstants.twitter)
        } else if source.contains("google") {
            
            self.image = UIImage(named: ImageNamesConstants.googleFeed)
        } else if source.contains("notables") {
            
            self.image = UIImage(named: ImageNamesConstants.notables)
        } else if source.contains("spotify") {
            
            self.image = UIImage(named: ImageNamesConstants.spotify)
        } else if source.contains("monzo") {
            
            self.image = UIImage(named: ImageNamesConstants.monzo)
        } else if source.contains("starling") {
            
            self.image = UIImage(named: ImageNamesConstants.starling)
        } else if source.contains("instagram") {
            
            self.image = UIImage(named: ImageNamesConstants.instagram)
        } else {
            
            self.image = UIImage(named: ImageNamesConstants.hatFeed)
        }
    }
    
    /**
     Downloads and caches an image
     
     - parameter resource: The url to download the item from
     - parameter placeholder: A placeholder image to use whilst downloading
     - parameter userDomain: The user's domain
     - parameter progressBlock: A function to execute on progress update
     - parameter completionHandler: A function to execute after the successful download of the image
     */
    func cacheImage(resource: Resource?, placeholder: Placeholder?, userDomain: String, progressBlock: DownloadProgressBlock?, completionHandler: CompletionHandler?) {
        
        let imageCache = ImageCache(name: userDomain)
        self.kf.setImage(with: resource, placeholder: placeholder, options: [.targetCache(imageCache)], progressBlock: progressBlock, completionHandler: completionHandler)
    }
}
