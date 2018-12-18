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

internal class ProfileFieldsTableViewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Variables
    
    var textViewDelegate: TextViewResizeDelegate?
    var fieldUpdatedDelegate: FieldUpdatedDelegate?
    var profile: HATProfileObject?
    var indexPath: IndexPath?
    var isFieldPrivate: Bool = false
    /// The options of the picker view
    var dataSourceForPickerView: [String] = ["", "Male", "Female"]
    private var selectedDate: Date?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var fieldTextField: UITextField!
    @IBOutlet private weak var isFieldPublicButton: UIButton!
    @IBOutlet private weak var textView: UITextView!
    
    // MARK: - IBActions
    
    @IBAction func isFieldPublicButtonAction(_ sender: Any) {
        
        let indexPathString = "(\(indexPath!.section), \(indexPath!.row))"
        let value = HATProfileService.profileMapping[indexPathString]
        
        if self.isFieldPublicButton.tag == 0 {

            self.isFieldPublicButton.setTitle("Public", for: .normal)
            UIView.animate(withDuration: 0.1, animations: { [weak self] in

                self?.enableButton()
            })
        } else {

            self.isFieldPublicButton.setTitle("Private", for: .normal)
            UIView.animate(withDuration: 0.1, animations: { [weak self] in

                self?.disableButton()
            })
        }
        
        self.fieldUpdatedDelegate?.buttonStateChanged(dictionary: [indexPathString: value!])
    }
    
    // MARK: - View Controller functions

    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Set up Cell
    
    func setUpCell(profile: inout HATProfileObject?, indexPath: IndexPath, sharedFields: Dictionary<String, String>?, textViewDelegate: TextViewResizeDelegate? = nil, textFieldDelegate: FieldUpdatedDelegate? = nil, textFieldTag: Int = 0, shouldRoundBottomCorners: Bool = false) -> ProfileFieldsTableViewCell {
        
        if shouldRoundBottomCorners {
            
            self.roundCorners()
        } else {
            
            self.mainView.layer.mask = nil
        }
        
        guard profile != nil else {
            
            return self
        }
        
        self.profile = profile
        self.indexPath = indexPath

        let indexPathString = "(\(indexPath.section), \(indexPath.row ))"
        let mapping = HATProfileObject.mapping
        guard let mappingResult = mapping[indexPathString] else {
                
            return self
        }
        
        if self.textView != nil {
            
            self.textView.delegate = self
            self.textViewDelegate = textViewDelegate
            self.fieldUpdatedDelegate = textFieldDelegate
            self.textView.text = self.profile![keyPath: mappingResult.string]
            self.textView.tag = mappingResult.tag
            
            if self.textView.text == "" {
                
                let attributedText = NSAttributedString(string: "Say something nice about yourself for the world to see", attributes: [NSAttributedString.Key.font: UIFont.oswaldLight(ofSize: 14)])
                textView.attributedText = attributedText
                textView.textColor = .textFieldPlaceHolder
            }
        } else if self.fieldTextField != nil {
            
            self.fieldTextField.delegate = self
            self.fieldUpdatedDelegate = textFieldDelegate
            self.fieldTextField.placeholder = mappingResult.placeholder
            self.fieldTextField.text = self.profile![keyPath: mappingResult.string]
            self.fieldTextField.tag = mappingResult.tag
            
            if self.fieldTextField.tag == 55 {
                
                self.selectedDate = FormatterManager.formatStringToDate(string: profile!.data.personal.birthDate)
                if self.selectedDate != nil {
                    
                    let stringDate = FormatterManager.formatDateStringToUsersDefinedDate(date: self.selectedDate!, dateStyle: .short, timeStyle: .none)
                    self.fieldTextField.text = stringDate
                }
            } else if self.fieldTextField.tag == 50 {
                
                self.fieldTextField.text = self.fieldTextField.text?.capitalized
            }
        }
        
        if sharedFields != nil && (sharedFields?[indexPathString] != nil) {
            
            self.checkButtonState(false)
        } else {
            
            self.checkButtonState(true)
        }

        return self
    }
    
    func roundCorners() {
        
        if self.mainView != nil {
            
            let width = UIScreen.main.bounds.width - 20
            var bounds = self.bounds
            bounds.size.width = width

            self.mainView = self.mainView.roundCorners(roundingCorners: [.bottomLeft, .bottomRight], cornerRadious: 5, bounds: bounds)
        }
    }
    private func enableButton() {
        
        self.isFieldPublicButton.setTitle("Public", for: .normal)
        self.makeButton3D(button: self.isFieldPublicButton)
        //self.isFieldPublicButton.setTitleColor(.white, for: .normal)
        self.isFieldPublicButton.tag = 1
    }
    
    private func disableButton() {
        
        self.isFieldPublicButton.setTitle("Private", for: .normal)
        self.makeButtonFlat(button: self.isFieldPublicButton)
        //self.isFieldPublicButton.setTitleColor(.selectionColor, for: .normal)
        self.isFieldPublicButton.tag = 0
    }
    
    private func makeButton3D(button: UIButton) {
        
        button.layer.cornerRadius = 3.0
    }
    
    private func makeButtonFlat(button: UIButton) {
        
        button.layer.cornerRadius = 3.0
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        textViewDelegate?.textViewDidChange(textView: textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.textFieldPlaceHolder {
            
            textView.text = nil
            textView.textColor = UIColor.sectionTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            let attributedText = NSAttributedString(string: "Say something nice about yourself for the world to see", attributes: [NSAttributedString.Key.font: UIFont.oswaldLight(ofSize: 14)])
            textView.attributedText = attributedText
            textView.textColor = .textFieldPlaceHolder
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 50 {
            
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.autoresizingMask = []
            textField.inputView = pickerView
        } else if textField.tag == 55 {
            
            let datePickerView = UIDatePicker()
            datePickerView.addTarget(self, action: #selector(datePickerDidUpdateDate(datePicker:)), for: .valueChanged)
            datePickerView.locale = .current
            datePickerView.datePickerMode = .date
            textField.inputView = datePickerView
            let date = FormatterManager.formatStringToDate(string: textField.text!)
            if date != nil {
                
                datePickerView.setDate(date!, animated: true)
            }
            textField.text = FormatterManager.formatDateStringToUsersDefinedDate(
                date: datePickerView.date,
                dateStyle: .short,
                timeStyle: .none)
        }
        
        return true
    }
    
    // MARK: - Picker did update date
    
    /**
     Updates the textField according to the selection of the datePicker
     
     - parameter datePicker: The datePicker that called this method
     */
    @objc
    func datePickerDidUpdateDate(datePicker: UIDatePicker) {
        
        self.selectedDate = datePicker.date
        self.fieldTextField.text = FormatterManager.formatDateStringToUsersDefinedDate(
            date: datePicker.date,
            dateStyle: .short,
            timeStyle: .none)
        self.updateProfile()
        self.fieldUpdatedDelegate?.fieldUpdated(textField: self.fieldTextField, indexPath: indexPath!, profile: self.profile!, isTextURL: nil)
    }
    
    func updateProfile() {
        
        let indexPathString = "(\(indexPath!.section), \(indexPath!.row))"
        let mapping = HATProfileObject.mapping
        guard let mappingResult = mapping[indexPathString] else {
            
            return
        }
        
        let string: String
        if self.fieldTextField != nil {
            
            if self.fieldTextField.tag == 55 {
                
                if let selectedDate = selectedDate {
                    
                    string = FormatterManager.formatDateToISO(date: selectedDate)
                } else {
                    
                    string = FormatterManager.formatDateToISO(date: Date())
                }
            } else if self.fieldTextField.tag == 50 {
                
                string = self.fieldTextField.text!.lowercased()
            } else {
                
                string = self.fieldTextField.text!
            }
        } else {
            
            string = self.textView.text
        }
        self.profile![keyPath: mappingResult.string] = string
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.updateProfile()
        self.fieldUpdatedDelegate?.fieldUpdated(textField: self.fieldTextField, indexPath: indexPath!, profile: self.profile!, isTextURL: nil)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.updateProfile()
        
        if indexPath?.section == 2 && textField.text != "" {
            
            let result = self.checkIfTextFieldHoldsURL(textField.text)
            if result {
                
                self.updateProfile()
            }
            self.fieldUpdatedDelegate?.fieldUpdated(textField: self.fieldTextField, indexPath: indexPath!, profile: self.profile!, isTextURL: result)
        } else {
            
            self.fieldUpdatedDelegate?.fieldUpdated(textField: self.fieldTextField, indexPath: indexPath!, profile: self.profile!, isTextURL: nil)
        }
    }
    
    private func checkButtonState(_ state: Bool?) {
        
        guard let state: Bool = state else {
            
            return
        }
        
        if state {
            
            self.disableButton()
        } else {
            
            self.enableButton()
        }
        
        self.isFieldPrivate = state
    }
    
    // MARK: - UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.dataSourceForPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataSourceForPickerView[row].capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.fieldTextField.text = self.dataSourceForPickerView[row].capitalized
    }
    
    func resignKeyboard() {
        
        if self.fieldTextField != nil {
            
            self.fieldTextField.resignFirstResponder()
        } else if self.textView != nil {
            
            self.textView.resignFirstResponder()
        }
    }
    
    // MARK: - Check if textfield contains url
    
    func checkIfTextFieldHoldsURL(_ url: String?) -> Bool {
        
        guard url != nil else {
            
            return false
        }
        
        if let urlComponents = URLComponents.init(string: url!), urlComponents.host != nil, urlComponents.url != nil {
            
            return true
        }
        
        return false
    }
    
    func resignKeyboards() {
        
        self.fieldTextField?.endEditing(true)
        self.textView?.endEditing(true)
    }

}
