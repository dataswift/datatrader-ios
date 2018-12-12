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

import UIKit

class PinInfoViewController: UIViewController {

    var mapInfo: MapLocation?
    var dateTimeString: String?
    weak var delegate: PinInfoViewControllerDelegate?
    
    @IBOutlet private weak var titleString: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var feedDescriptionLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var imageVIew: UIImageView!
    @IBOutlet private weak var grayImageOverlayView: UIView!
    
    @IBAction func cancelAction(_ sender: Any) {
        
        self.removeViewController()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.goToPreviousPin))
        //        leftSwipeGesture.direction = .right
        //
        //        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.goToNextPin))
        //        rightSwipeGesture.direction = .left
        //
        //        self.mainView.addGestureRecognizer(leftSwipeGesture)
        //        self.mainView.addGestureRecognizer(rightSwipeGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setUpLabels()
        
        self.setUpUI()
    }
    
    func reuseViewController(mapLocation: MapLocation) {
        
        self.mapInfo = mapLocation
        self.setUpLabels()
        self.setUpUI()
    }
    
    private func setUpLabels() {
        
        if self.titleString != nil && mapInfo != nil {
            
            self.titleString.text = mapInfo!.dataForAnnotationInfo?.title.text
        }
        
        if self.dateLabel != nil {
            
            self.dateLabel.text = self.dateTimeString
        }
        
        if self.feedDescriptionLabel != nil && mapInfo != nil {
            
            let date = FormatterManager.getDateFromString((mapInfo!.dataForAnnotationInfo?.date.iso)!)
            let dateString = FormatterManager.formatDateStringToUsersDefinedDate(date: date!, dateStyle: .medium, timeStyle: .short).replacingOccurrences(of: "-", with: "")
            self.feedDescriptionLabel.text = dateString
        }
        
        if self.descriptionLabel != nil && mapInfo != nil {
            
            self.descriptionLabel.text = mapInfo!.dataForAnnotationInfo?.content?.text
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    private func setUpUI() {
        
        guard let dataInfo = mapInfo!.dataForAnnotationInfo?.content else {
            
            return
        }
        
        if dataInfo.media == nil {
            
            var size = self.mainView.bounds.size
            size.width = self.view.bounds.size.width - 80
            let height = self.mainView.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow).height
            if height < 250 {
                
                self.view.frame.size.height = height + 20
            } else {
                
                self.view.frame.size.height = 250
            }
        } else {
            
            if let media = mapInfo!.dataForAnnotationInfo?.content?.media, self.imageVIew != nil {
                
                let url = URL(string: media[0].url)
                self.imageVIew.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { [weak self] image, error, cache, url in
                    
                    guard let weakSelf = self else { return }
                    
                    var size = weakSelf.view.bounds
                    weakSelf.view.layer.shadowColor = UIColor.darkGray.cgColor
                    weakSelf.view.layer.shadowRadius = 5
                    weakSelf.view.layer.shadowOpacity = 0.6
                    weakSelf.view.layer.shadowOffset = CGSize(width: 1, height: 0)
                    weakSelf.view.layer.cornerRadius = 5
                    
                    size.size.height = weakSelf.imageVIew.bounds.height
                    weakSelf.imageVIew.roundCorners(roundingCorners: [.bottomLeft, .bottomRight], cornerRadious: 5, bounds: size)
                    
                    size.size.height = weakSelf.grayImageOverlayView.bounds.height
                    weakSelf.grayImageOverlayView.roundCorners(roundingCorners: [.bottomLeft, .bottomRight], cornerRadious: 5, bounds: size)
                })
            }
        }
        
        self.view.layer.shadowColor = UIColor.darkGray.cgColor
        self.view.layer.shadowRadius = 5
        self.view.layer.shadowOpacity = 0.6
        self.view.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.view.layer.cornerRadius = 5
    }
    
    func setUpView(from viewController: BaseViewController, mapLocation: MapLocation?, dateTimeString: String? = nil, bounds: CGRect, delegate: PinInfoViewControllerDelegate?) -> PinInfoViewController {
        
        self.mapInfo = mapLocation
        self.delegate = delegate
        self.dateTimeString = dateTimeString
        let width = bounds.width - 32
        let rect = CGRect(x: bounds.origin.x + 16, y: bounds.origin.y + 16, width: width, height: 240)
        viewController.addChildViewController(self)
        self.view.frame = rect
        viewController.view.addSubview(self.view)
        self.didMove(toParentViewController: viewController)
        
        return self
    }

}
