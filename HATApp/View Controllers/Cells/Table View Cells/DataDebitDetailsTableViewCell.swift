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

class DataDebitDetailsTableViewCell: UITableViewCell {
    
    // MARK: - IBOUtlets

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var showMoreButton: UIButton!
    
    // MARK: - Variables
    
    var indexPath: IndexPath?
    var isExpanded: Bool = false
    var delegate: UITableViewResizeDelegate?
    
    // MARK: - TableView cell functions
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Set up cell
    
    static func setUpCell(tableView: UITableView, indexPath: IndexPath, delegate: UITableViewResizeDelegate, isCellExpanded: Bool, dataDebit: DataDebitObject?, cellType: DataDebitDetailsSections) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.dataDebitsDetailsCell, for: indexPath) as? DataDebitDetailsTableViewCell {
            
            if cellType == .requirements {
                
                cell.isExpanded = true
            } else {
                
                cell.isExpanded = isCellExpanded
            }
            
            cell.indexPath = indexPath
            cell.delegate = delegate
            cell.setUpUI(dataDebit: dataDebit, cellType: cellType)
            cell.selectionStyle = .none
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.dataDebitsDetailsCell, for: indexPath)
    }
    
    // MARK: - Set up UI
    
    private func setUpUI(dataDebit: DataDebitObject?, cellType: DataDebitDetailsSections) {
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.expandCell))
        
        self.mainView.layer.cornerRadius = 5
        
        self.setUpLabels(dataDebit: dataDebit, cellType: cellType)
        
        let mainViewHeight = self.mainView.systemLayoutSizeFitting(self.mainView.frame.size, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow).height
        
        if mainViewHeight > self.mainView.frame.size.height && !isExpanded {
            
            let readmoreFont = UIFont.openSansExtrabold(ofSize: 13)
            let readmoreFontColor = UIColor.selectionColor
            
            self.descriptionLabel.isUserInteractionEnabled = true
            self.descriptionLabel.addTrailing(with: " ... ", moreText: "More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
            self.descriptionLabel.addGestureRecognizer(tapGestureRecogniser)
        } else {
            
            self.descriptionLabel.isUserInteractionEnabled = false
            self.descriptionLabel.removeGestureRecognizer(tapGestureRecogniser)
        }
    }
    
    private func setUpLabels(dataDebit: DataDebitObject?, cellType: DataDebitDetailsSections) {
        
        if cellType == .description {
            
            self.titleLabel.text = "Description"
            
            let descriptionText: String?
            if dataDebit?.requestDescription == "" || dataDebit?.requestDescription == nil {
                
                descriptionText = "This Data Debit is in an old format, and the HAT App is unable to display all the information associated with it fully. This may include a logo, title and full description."
            } else {
                
                descriptionText = dataDebit?.requestDescription
            }
            
            self.descriptionLabel.text = descriptionText
        } else if cellType == .purpose {
            
            self.titleLabel.text = "Purpose"
            self.descriptionLabel.text = dataDebit?.permissionsLatest.purpose
        } else {
            
            self.titleLabel.text = "Data that \(dataDebit?.dataDebitKey ?? "") have access to:"
            self.descriptionLabel.attributedText = NSAttributedString.formatRequiredDataDefinitionText(requiredDataDefinition: [(dataDebit?.permissionsLatest.bundle)!])
        }
    }
    
    // MARK: - Expand cell
    
    @objc
    private func expandCell() {
        
        self.isExpanded = true
        
        if self.indexPath != nil {
            
            delegate?.resizeCellAt(indexPath: self.indexPath!)
        }
    }

}
