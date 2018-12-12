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

internal class FullScreenImageViewController: BaseViewController, UIScrollViewDelegate, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    /// The file object, passed on from previous view controller
    var file: FileUploadObject?
    /// The file object, passed on from previous view controller
    var image: UIImage?
    /// The file object, passed on from previous view controller
    var url: String?
    /// A Bool value to determine of the ui is visible or not
    private var isUIHidden: Bool = false
    private var pointWhereGestureStarted: CGPoint?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scollView: UIScrollView!
    @IBOutlet private weak var cancelButton: UIButton!
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        if let gesture = sender as? UIPanGestureRecognizer {
            
            //let velocity = gesture.velocity(in: self.imageView)
            switch gesture.state {
                
            case .began:
                
                self.pointWhereGestureStarted = gesture.translation(in: self.imageView)
            case .changed:
                
                let translation = gesture.translation(in: self.imageView)
                
                if abs(Int(self.pointWhereGestureStarted!.x) - Int(translation.x)) > 50 || abs(Int(self.pointWhereGestureStarted!.y) - Int(translation.y)) > 50 {
                    
                    self.dismiss(animated: true, completion: nil)
                }
            default:
                
                break
            }
        } else {
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - View Controller functions

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.scollView.maximumZoomScale = 6.0
        self.scollView.minimumZoomScale = 1.0
        self.scollView.delegate = self
        
        self.view.backgroundColor = .black
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideUI))
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(cancelButtonAction(_:)))
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(gesture)
        self.imageView.addGestureRecognizer(swipeGesture)

        self.loadImage()
        
        if self.navigationController != nil {
            
            self.cancelButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Load image
    
    private func loadImage() {
        
        if self.file != nil {
            
            if self.file?.image != nil {
                
                self.imageView.image = self.file!.image
            } else {
                
                if let url = URL(string: self.file!.contentURL) {
                    
                    self.imageView.downloadedFrom(
                        url: url,
                        userToken: userToken,
                        progressUpdater: nil,
                        completion: nil)
                }
            }
        } else if self.image != nil {
            
            self.imageView.image = self.image
        } else if self.url != nil {
            
            guard let url = URL(string: self.url!) else {
                
                self.imageView.image = UIImage(named: ImageNamesConstants.failedDownloading)
                return
            }
            
            self.imageView.cacheImage(
                resource: url,
                placeholder: nil,
                userDomain: self.userDomain,
                progressBlock: nil,
                completionHandler: { [weak self] image, error, cacheType, url in
                    
                    if error != nil || image == nil {
                        
                        self?.imageView.image = UIImage(named: ImageNamesConstants.failedDownloading)
                    }
                }
            )
        }
    }
    
    // MARK: - Hide UI
    
    /**
     Hides the navigation bar, tab bar and delete button
     */
    @objc
    private func hideUI() {
        
        self.navigationController?.setNavigationBarHidden(!(self.isUIHidden), animated: true)

        self.isUIHidden = !(self.isUIHidden)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
    }

}
