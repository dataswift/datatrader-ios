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

// MARK: Class

internal class FitbitDateTableViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var rightImageView: UIImageView!
    @IBOutlet private weak var leftImageView: UIImageView!
    
    // MARK: - Set date
    
    func setDateInLabel(dateString: String, isoDate: String) {
        
        self.dateLabel.text = dateString
        
        if let date = FormatterManager.formatStringToDate(string: isoDate) {
            
            let calendar = Calendar.current
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
            let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
            if Date.startOfDate(date: date) == Date.startOfDate() {
                
                self.dateLabel.textColor = .selectionColor
                self.dateLabel.text = "TODAY"
                self.rightImageView.backgroundColor = .selectionColor
                self.leftImageView.backgroundColor = .selectionColor
            } else if Date.startOfDate(date: date) == Date.startOfDate(date: tomorrow) {
                
                self.dateLabel.textColor = .sectionTextColor
                self.dateLabel.text = "TOMORROW"
                self.rightImageView.backgroundColor = .sectionTextColor
                self.leftImageView.backgroundColor = .sectionTextColor
            } else if Date.startOfDate(date: date) == Date.startOfDate(date: yesterday) {
                
                self.dateLabel.textColor = .sectionTextColor
                self.dateLabel.text = "YESTERDAY"
                self.rightImageView.backgroundColor = .sectionTextColor
                self.leftImageView.backgroundColor = .sectionTextColor
            } else {
                
                self.dateLabel.textColor = .sectionTextColor
                self.rightImageView.backgroundColor = .sectionTextColor
                self.leftImageView.backgroundColor = .sectionTextColor
            }
        } else {
            
            self.dateLabel.textColor = .sectionTextColor
            self.rightImageView.backgroundColor = .sectionTextColor
            self.leftImageView.backgroundColor = .sectionTextColor
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        let width = UIScreen.main.bounds.width
        layoutAttributes.size.width = width
        layoutAttributes.size.height = 50
        
        return layoutAttributes
    }
    
}

