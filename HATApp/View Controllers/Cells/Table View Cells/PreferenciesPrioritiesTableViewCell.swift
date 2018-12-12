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

// MARK: Class

class PreferenciesPrioritiesTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    
    weak var prioritiesChangedDelegate: NewPrioritySelectedDelegate?
    private var indexPath: IndexPath?
    
    // MARK: - TableView cell methods

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Setup
    
    class func setUpCell(tableView: UITableView, indexPath: IndexPath, title: String, selection: Int?, delegate: NewPrioritySelectedDelegate) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.preferencesPrioritiesCell, for: indexPath) as? PreferenciesPrioritiesTableViewCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.preferencesPrioritiesCell, for: indexPath)
        }
        
        cell.resetStackView()
        cell.prioritiesChangedDelegate = delegate
        cell.titleLabel.text = title
        cell.indexPath = indexPath
        cell.setupUI(selected: selection)
        return cell
    }
    
    private func setupUI(selected: Int?) {
    
        let width = UIScreen.main.bounds.width - 132
        let spacing = width / 4
        self.stackView.spacing = spacing
        
        for (int, view) in self.stackView.arrangedSubviews.enumerated() {
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scoreViewsTapped(gesture:)))
            view.addGestureRecognizer(tapGesture)
            view.tag = int
            view.layer.cornerRadius = view.bounds.width / 2
            
            if int == selected ?? -1 {
                
                view.layer.borderColor = UIColor.selectionColor.cgColor
                view.layer.borderWidth = 2
                self.updateScore(score: selected!)
            }
        }
    }
    
    @objc
    private func scoreViewsTapped(gesture: UITapGestureRecognizer) {
        
        guard let view = gesture.view else { return }
        
        self.resetStackView()
        
        view.layer.borderColor = UIColor.selectionColor.cgColor
        view.layer.borderWidth = 2
        self.updateScore(score: view.tag)
        guard self.indexPath != nil else { return }
        self.prioritiesChangedDelegate?.newPrioritySelected(indexPath: self.indexPath!, position: view.tag)
    }
    
    private func resetStackView() {
        
        for view in self.stackView.arrangedSubviews {
            
            view.layer.borderWidth = 0
            view.layer.borderColor = nil
        }
    }
    
    private func updateScore(score: Int) {
        
        self.scoreLabel.isHidden = false
        self.scoreLabel.text = "\(score + 1)/5"
    }
    
    override func prepareForReuse() {
        
        self.resetStackView()
        self.scoreLabel.isHidden = true
    }

}
