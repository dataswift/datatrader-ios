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

class ResetPasswordTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var firstScoreView: UIView!
    @IBOutlet private weak var secondScoreView: UIView!
    @IBOutlet private weak var thirdScoreView: UIView!
    @IBOutlet private weak var fourthScoreView: UIView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setDelegate(delegate: UITextFieldDelegate?) {
        
        self.textField.delegate = delegate
    }
    
    func getTextFromTextField() -> String {
        
        return self.textField.text ?? ""
    }
    
    class func setUpCell(cell: ResetPasswordTableViewCell, placeholderText: String, delegate: UITextFieldDelegate?, viewController: CreatePasswordTableViewController) -> ResetPasswordTableViewCell {
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.mainView.layer.borderWidth = 0
        cell.mainView.layer.borderColor = UIColor.clear.cgColor
        cell.textField.placeholder = placeholderText
        cell.setDelegate(delegate: delegate)
        
        return cell
    }
}
