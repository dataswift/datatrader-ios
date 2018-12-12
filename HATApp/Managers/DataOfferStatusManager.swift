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

enum DataOfferStatusManager: String {

    case accepted
    case completed
    case available
    
    static func getState(of dataOffer: DataOfferObject) -> DataOfferStatusManager {
        
        if dataOffer.claim.claimStatus == "completed" {
            
            return .completed
        } else if dataOffer.claim.claimStatus == "claimed" {
            
            return .accepted
        }
        
        return .available
    }
    
    static func appendRewardToAttributedString(attributedString: NSAttributedString, dataOffer: DataOfferObject) -> NSAttributedString {
        
        let status = DataOfferStatusManager.getState(of: dataOffer)
        if status == .completed {
            
            let tempAttributedString = NSMutableAttributedString(attributedString: attributedString)
            if dataOffer.reward.rewardType == "voucher" {
                
                tempAttributedString.append(NSAttributedString(string: "\nClick here: \(dataOffer.reward.codes!.first!)"))
                let attributes1: [NSAttributedString.Key : Any] = [
                    
                    .foregroundColor: UIColor.selectionColor
                ]
                tempAttributedString.addAttributes(attributes1, range: NSRange(location: 67, length: "Click here: \(dataOffer.reward.codes!.first!)".count))
                return tempAttributedString
            } else if dataOffer.reward.rewardType == "service" {
                
                tempAttributedString.append(NSAttributedString(string: "\nClick here: \(dataOffer.reward.vendorURL)"))
                let attributes1: [NSAttributedString.Key : Any] = [
                    
                    .foregroundColor: UIColor.selectionColor
                ]
                tempAttributedString.addAttributes(attributes1, range: NSRange(location: 67, length: "Click here: \(dataOffer.reward.vendorURL)".count))
                return tempAttributedString
            }
        }
        
        return attributedString
    }
    
    static func setUpProgressBar(offer: DataOfferObject, dataDebitValue: DataDebitValuesObject?, progressBar: UIProgressView, progressStatusLabel: UILabel) {
        
        if offer.claim.claimStatus == "claimed" {
            
            guard dataDebitValue != nil else {
                
                progressBar.progress = 0/3
                progressStatusLabel.text = "Checking status..."
                return
            }
            
            
            if let value = dataDebitValue?.conditions?.values.reduce(true, { $0 && $1 }) {
                
                if value {
                    
                    progressBar.progress = 2/3
                    progressStatusLabel.text = "2/3 Fetching"
                } else {
                    
                    progressBar.progress = 1/3
                    progressStatusLabel.text = "1/3 Offer accepted"
                }
            } else if let bundle = dataDebitValue?.bundle, !bundle.isEmpty {
                
                progressBar.progress = 2/3
                progressStatusLabel.text = "2/3 Fetching"
            } else {
                
                progressBar.progress = 0/3
                progressStatusLabel.text = "Problem claiming offer. Please tap here"
            }
        } else if offer.claim.claimStatus == "completed" {
            
            progressBar.progress = 3/3
            progressStatusLabel.text = "3/3 Offer completed"
        } else {
            
            progressBar.progress = 1/3
            progressStatusLabel.text = "1/3 Offer accepted"
        }
    }
}
