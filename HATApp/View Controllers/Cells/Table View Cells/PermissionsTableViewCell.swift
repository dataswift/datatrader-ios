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

class PermissionsTableViewCell: UITableViewCell {

    // MARK: - Variables

    var indexPath: IndexPath?
    var isExpanded: Bool = false
    var delegate: UITableViewResizeDelegate?

    // MARK: - IBoutlets

    @IBOutlet private weak var permissionImageView: UIImageView!
    @IBOutlet private weak var permissionTitleLabel: UILabel!
    @IBOutlet private weak var permissionDescriptionLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!

    // MARK: - Table View cell fucntions

    override func awakeFromNib() {

        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)
    }

    // MARK: - Set up cell

    class func setUpCell(tableView: UITableView, indexPath: IndexPath, application: HATApplicationObject, cellType: ApplicationPermissionsSections, isCellExpanded: Bool, delegate: UITableViewResizeDelegate, normalCellHeight: Float) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.permissionsCell, for: indexPath) as? PermissionsTableViewCell else {

            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.permissionsCell, for: indexPath)
        }

        cell.updateUI(tableView: tableView, indexPath: indexPath, application: application, cellType: cellType, isCellExpanded: isCellExpanded, delegate: delegate, normalCellHeight: normalCellHeight - 10)

        return cell
    }

    private func updateUI(tableView: UITableView, indexPath: IndexPath, application: HATApplicationObject, cellType: ApplicationPermissionsSections, isCellExpanded: Bool, delegate: UITableViewResizeDelegate, normalCellHeight: Float) {

        self.mainView.layer.cornerRadius = 5
        self.isExpanded = isCellExpanded
        self.delegate = delegate
        self.indexPath = indexPath

        if cellType == .rolesGranted {

            self.updateRolesGrandedCellLabels(application: application, indexPath: indexPath)
        } else if cellType == .permissions {

            self.updatePermissionsCellLabels(application: application, indexPath: indexPath)
        }

        let mainViewHeight = self.mainView.systemLayoutSizeFitting(self.mainView.frame.size, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow).height

        if mainViewHeight > CGFloat(normalCellHeight) && !self.isExpanded && cellType == .permissions {

            let readmoreFont = UIFont.openSansExtrabold(ofSize: 13)
            let readmoreFontColor = UIColor.selectionColor

            self.permissionDescriptionLabel.isUserInteractionEnabled = true
            self.permissionDescriptionLabel.addTrailing(with: " ... ", moreText: "More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)

            let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.expandCell))
            self.permissionDescriptionLabel.addGestureRecognizer(tapGestureRecogniser)

            self.mainView.frame.size.height = CGFloat(normalCellHeight)
        } else {

            self.permissionDescriptionLabel.isUserInteractionEnabled = false
            self.permissionDescriptionLabel.gestureRecognizers?.removeAll()

            self.isExpanded = true
            //self.delegate?.resizeCellAt(indexPath: indexPath)
            self.mainView.frame.size.height = mainViewHeight
        }
    }

    private func updateRolesGrandedCellLabels(application: HATApplicationObject, indexPath: IndexPath) {

        let role = application.application.permissions.rolesGranted[indexPath.row].role
        let detail = application.application.permissions.rolesGranted[indexPath.row].detail

        let localisedRole = NSLocalizedString(role, tableName: "appPermissions", bundle: Bundle.main, value: role, comment: "")
        self.permissionTitleLabel.text = localisedRole

        if detail != nil {

            let localizedDetail = String(format: NSLocalizedString("\(role) %@", tableName: "appPermissions", bundle: Bundle.main, value: "\(role) %@", comment: ""), detail!)
            self.permissionDescriptionLabel.text = localizedDetail
        } else {
            
            if role == "applicationlist" {
                
                self.permissionDescriptionLabel.text = "This app needs to be able to list other available applications."
            } else if role == "retrieveapplicationtoken" {
                
                self.permissionDescriptionLabel.text = "This app needs to be able to generate application tokens to interact with the HAT."
            }
        }
    }

    private func updatePermissionsCellLabels(application: HATApplicationObject, indexPath: IndexPath) {

        for (index, item) in application.application.permissions.dataRetrieved!.bundle.enumerated() where index == indexPath.row {

            self.permissionTitleLabel.text = item.value.endpoints.first?.endpoint.replacingOccurrences(of: "/", with: " ")
            self.permissionDescriptionLabel.attributedText = NSAttributedString.formatRequiredDataDefinitionText(requiredDataDefinition: [application.application.permissions.dataRetrieved!], indexToRead: index)
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

    override func prepareForReuse() {

        self.permissionTitleLabel.text = ""
        self.permissionDescriptionLabel.text = ""
        self.permissionDescriptionLabel.attributedText = nil
        self.isExpanded = false
        self.indexPath = nil
        self.delegate = nil
    }

}
