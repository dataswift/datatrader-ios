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

// MARK - Class

class SubscribeToMailingListsViewController: HATCreationUIViewController {
    
    enum Subscriptions: String {
        
        case madhatters = "optinMadHATTERS"
        case monthlyHatUpdates = "optinHatMonthly"
        case hatEcosystemUpdates = "optinHCF"
    }
    
    // MARK: - Variables
    
    var mailingListOptIns: [Subscriptions.RawValue] = []
    
    // MARK: - IBOutlets

    @IBOutlet private weak var madhattersCheckboxImageView: UIImageView!
    @IBOutlet private weak var monthlyHatUpdatesCheckBoxImageView: UIImageView!
    @IBOutlet private weak var hatEcosystemUpdatesCheckboxImageView: UIImageView!
    @IBOutlet private weak var subscriptionsInfoLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func netButtonAction(_ sender: Any) {
        
        self.purchaseModel.optins = self.mailingListOptIns
        self.performSegue(withIdentifier: SeguesConstants.createHATConfirmationSegue, sender: self)
    }
    
    // MARK: - UIViewController delegate
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addGestureRecognizersToCheckboxes()
        self.nextButton.layer.cornerRadius = 5
    }
    
    // MARK: - Gesture recognisers
    
    @objc func madHattersCheckBoxTapped() {
        
        let tuple = checkBoxTapped(checkBoxRole: Subscriptions.madhatters.rawValue, enabledSubscriptions: self.mailingListOptIns)
        self.mailingListOptIns = tuple.1
        self.switchCheckBoxImage(imageView: self.madhattersCheckboxImageView, isSelected: tuple.0)
    }
    
    @objc func monthlyHatCheckBoxTapped() {
        
        let tuple = checkBoxTapped(checkBoxRole: Subscriptions.monthlyHatUpdates.rawValue, enabledSubscriptions: self.mailingListOptIns)
        self.mailingListOptIns = tuple.1
        self.switchCheckBoxImage(imageView: self.monthlyHatUpdatesCheckBoxImageView, isSelected: tuple.0)
    }
    
    @objc func hatEcosystemCheckBoxTapped() {
        
        let tuple = checkBoxTapped(checkBoxRole: Subscriptions.hatEcosystemUpdates.rawValue, enabledSubscriptions: self.mailingListOptIns)
        self.mailingListOptIns = tuple.1
        self.switchCheckBoxImage(imageView: self.hatEcosystemUpdatesCheckboxImageView, isSelected: tuple.0)
    }
    
    // MARK: - CheckboxTapped
    
    private func checkBoxTapped(checkBoxRole: String, enabledSubscriptions: [Subscriptions.RawValue]) -> (Bool, [Subscriptions.RawValue]) {
        
        var newSubscriptions = enabledSubscriptions

        if enabledSubscriptions.contains(checkBoxRole) {
            
            newSubscriptions = newSubscriptions.filter({ return $0 != checkBoxRole})
            return (false, newSubscriptions)
        }
            
        newSubscriptions.append(checkBoxRole)
        return (true, newSubscriptions)
    }
    
    // MARK: - Change image on tap
    
    private func switchCheckBoxImage(imageView: UIImageView, isSelected: Bool) {
        
        if isSelected {
            
            imageView.image = UIImage(named: ImageNamesConstants.checkBoxCheckedWhite)
        } else {
            
            imageView.image = UIImage(named: ImageNamesConstants.checkBoxEmptyWhite)
        }
    }
    
    // MARK: - Add Gestures
    
    private func addGestureRecognizersToCheckboxes() {
        
        let madHattersGesture = UITapGestureRecognizer(target: self, action: #selector(madHattersCheckBoxTapped))
        let monthlyHatGesture = UITapGestureRecognizer(target: self, action: #selector(monthlyHatCheckBoxTapped))
        let hatEcosystemGesture = UITapGestureRecognizer(target: self, action: #selector(hatEcosystemCheckBoxTapped))
        
        self.madhattersCheckboxImageView.addGestureRecognizer(madHattersGesture)
        self.monthlyHatUpdatesCheckBoxImageView.addGestureRecognizer(monthlyHatGesture)
        self.hatEcosystemUpdatesCheckboxImageView.addGestureRecognizer(hatEcosystemGesture)
    }
    
}
