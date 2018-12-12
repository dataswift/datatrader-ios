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

class PreferencesProfileTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Variables
    
    private var indexPath: IndexPath?
    private var profile: ShapeProfileObject?
    private var answers: [String] = []
    
    // MARK: - IBoutlets

    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - TableviewCell methods
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - PickerView methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return answers.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return answers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.textField.text = self.answers[row]
        self.textFieldDidChange()
    }
    
    // MARK: - Set up
    
    class func setUpCell(tableView: UITableView, indexPath: IndexPath, heading: String, profile: ShapeProfileObject, answers: [String]?) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.preferencesProfileCell, for: indexPath) as? PreferencesProfileTableViewCell else {
            
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiersConstants.preferencesProfileCell, for: indexPath)
        }
        
        cell.answers = answers ?? []
        cell.headingLabel.text = heading
        cell.indexPath = indexPath
        cell.profile = profile
        cell.setUpCell(indexPath: indexPath, profile: profile)
        cell.textField.addTarget(cell, action: #selector(textFieldDidChange), for: .editingChanged)

        return cell
    }
    
    // MARK: - Picker did update date
    
    /**
     Updates the textField according to the selection of the datePicker
     
     - parameter datePicker: The datePicker that called this method
     */
    @objc
    func datePickerDidUpdateDate(datePicker: UIDatePicker) {
        
        //self.selectedDate = datePicker.date
        self.textField.text = FormatterManager.formatDateStringToUsersDefinedDate(
            date: datePicker.date,
            dateStyle: .short,
            timeStyle: .none)
        self.profile?.dateOfBirth = self.textField.text!
    }
    
    private func setUpCell(indexPath: IndexPath, profile: ShapeProfileObject) {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            
            let datePickerView = UIDatePicker()
            datePickerView.addTarget(self, action: #selector(datePickerDidUpdateDate(datePicker:)), for: .valueChanged)
            
            datePickerView.locale = .current
            datePickerView.datePickerMode = .date
            textField.inputView = datePickerView
            let date = FormatterManager.formatStringToDate(string: textField.text!)
            if date != nil {
                
                datePickerView.setDate(date!, animated: true)
            }
        } else if indexPath.section != 2 {
            
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            self.textField.inputView = pickerView
        }
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            self.textField.text = profile.highestAcademicQualification
        } else if indexPath.section == 1 && indexPath.row == 0 {
            
            self.textField.text = profile.dateOfBirth
        } else if indexPath.section == 1 && indexPath.row == 1 {
            
            self.textField.text = profile.gender
        } else if indexPath.section == 1 && indexPath.row == 2 {
            
            self.textField.text = profile.incomeGroup
        } else if indexPath.section == 2 && indexPath.row == 0 {
            
            self.textField.text = profile.city
        } else if indexPath.section == 2 && indexPath.row == 1 {
            
            self.textField.text = profile.state
        } else if indexPath.section == 2 && indexPath.row == 2 {
            
            self.textField.text = profile.country
        } else if indexPath.section == 3 && indexPath.row == 0 {
            
            self.textField.text = profile.employmentStatus
        } else if indexPath.section == 4 && indexPath.row == 0 {
            
            self.textField.text = profile.relationshipStatus
        } else if indexPath.section == 4 && indexPath.row == 1 {
            
            self.textField.text = profile.typeOfAccomodation
        } else if indexPath.section == 4 && indexPath.row == 2 {
            
            self.textField.text = profile.livingSituation
        } else if indexPath.section == 4 && indexPath.row == 3 {
            
            self.textField.text = profile.numberOfPeopleInHousehold
        } else if indexPath.section == 4 && indexPath.row == 4 {
            
            self.textField.text = profile.numberOfChildren
        } else if indexPath.section == 4 && indexPath.row == 5 {
            
            self.textField.text = profile.additionalDependets
        }
    }
    
    @objc private func textFieldDidChange() {
        
        guard indexPath != nil, profile != nil else { return }
        
        if indexPath!.section == 0 && indexPath!.row == 0 {
            
            profile!.highestAcademicQualification = self.textField.text ?? ""
        } else if indexPath!.section == 1 && indexPath!.row == 0 {
            
            profile!.dateOfBirth = self.textField.text ?? ""
        } else if indexPath!.section == 1 && indexPath!.row == 1 {
            
            profile!.gender = self.textField.text ?? ""
        } else if indexPath!.section == 1 && indexPath!.row == 2 {
            
            profile!.incomeGroup = self.textField.text ?? ""
        } else if indexPath!.section == 2 && indexPath!.row == 0 {
            
            profile!.city = self.textField.text ?? ""
        } else if indexPath!.section == 2 && indexPath!.row == 1 {
            
            profile!.state = self.textField.text ?? ""
        } else if indexPath!.section == 2 && indexPath!.row == 2 {
            
            profile!.country = self.textField.text ?? ""
        } else if indexPath!.section == 3 && indexPath!.row == 0 {
            
            profile!.employmentStatus = self.textField.text ?? ""
        } else if indexPath!.section == 4 && indexPath!.row == 0 {
            
            profile!.relationshipStatus = self.textField.text ?? ""
        } else if indexPath!.section == 4 && indexPath!.row == 1 {
            
            profile!.typeOfAccomodation = self.textField.text ?? ""
        } else if indexPath!.section == 4 && indexPath!.row == 2 {
            
            profile!.livingSituation = self.textField.text ?? ""
        } else if indexPath!.section == 4 && indexPath!.row == 3 {
            
            profile!.numberOfPeopleInHousehold = self.textField.text ?? ""
        } else if indexPath!.section == 4 && indexPath!.row == 4 {
            
            profile!.numberOfChildren = self.textField.text ?? ""
        } else if indexPath!.section == 4 && indexPath!.row == 5 {
            
            profile!.additionalDependets = self.textField.text ?? ""
        }
    }

}
