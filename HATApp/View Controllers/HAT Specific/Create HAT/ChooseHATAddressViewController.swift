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

internal class ChooseHATAddressViewController: HATCreationUIViewController {
    
    // MARK: - IBOutlets

    ///An IBOutlet to handle the imageView
    @IBOutlet private weak var imageView: UIImageView!
    ///An IBOutlet to handle the hatAddress textField
    @IBOutlet private weak var hatAddressTextField: UITextField!
    ///An IBOutlet to handle the next Button
    @IBOutlet private weak var nextButton: UIButton!
    ///An IBOutlet to handle the hat name Label
    @IBOutlet private weak var hatNameLabel: UILabel!
    ///An IBOutlet to handle the hat cluster Label
    @IBOutlet private weak var hatClusterLabel: UILabel!
    
    // MARK: - IBActions
    
    /**
     Called when next button is pressed. Check the fields for error and checks with hat the email field. If ok continues to the next screen
     
     - parameter sender: The object that called the function
     */
    @IBAction func nextButtonAction(_ sender: Any) {
        
        self.validateHATAddress()
    }
    
    // MARK: - View controller functions
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.hatAddressTextField.delegate = self
        self.hatAddressTextField.setLeftPaddingPoints(22)
        self.hatAddressTextField.layer.borderWidth = 1
        self.hatAddressTextField.layer.borderColor = UIColor.hatDisabled.cgColor
        
        self.nextButton.layer.cornerRadius = 5
        
        // add a target if user is editing the text field
        self.hatAddressTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.setNavigationBarColorToDarkBlue()
        self.updateHatNameAndClusterLabels()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Validate HAT Address
    
    /**
     Validates if the HAT address that user entered in the textfield is valid and can be used with the HAT
     */
    private func validateHATAddress() {
        
        let trimmedAddress: String = self.hatAddressTextField.text!.replacingOccurrences(of: " ", with: "")
        self.hatAddressTextField.text = trimmedAddress
        let address: String = trimmedAddress.replacingOccurrences(of: ".\(self.cluster)", with: "")
        
        HATService.validateHATAddress(
            address: address,
            cluster: cluster,
            succesfulCallBack: hatValid,
            failCallBack: hatInvalid)
    }
    
    /**
     Hat address is valid and can be used with HAT, go to next screen
     
     - parameter message: The message returned
     - parameter newToken: The new token returned from hat, it will be nil since there is no token used until now
     */
    private func hatValid(message: String, newToken: String?) {
        
        let domain: String = ".\(self.cluster)"

        self.purchaseModel.hatName = self.hatAddressTextField.text!.replacingOccurrences(of: domain, with: "")
        self.performSegue(withIdentifier: SeguesConstants.createPasswordSegue, sender: self)
    }
    
    /**
     <#Function Details#>
     
     - parameter error: An error occured while checking the HAT address with HAT
     */
    private func hatInvalid(error: JSONParsingError) {
        
        switch error {
        case .generalError(let message, _, _):
            
            self.createDressyClassicOKAlertWith(alertMessage: message, alertTitle: "Error!", okTitle: "Ok", proceedCompletion: nil)
        default:
            
            self.createDressyClassicOKAlertWith(alertMessage: "Unknown error", alertTitle: "Error!", okTitle: "Ok", proceedCompletion: nil)
        }
    }
    
    // MARK: - Text Field Did change
    
    /**
     <#Function Details#>
     */
    @objc
    func textFieldDidChange() {
        
        let domain: String = ".\(self.cluster)"
        
        // add the domain to what user is entering
        self.hatAddressTextField.text = self.hatAddressTextField.text!.replacingOccurrences(of: domain, with: "") + domain
        
        // only if there is a currently selected range
        let selectedRange: UITextPosition = self.hatAddressTextField.endOfDocument
            
        // and only if the new position is valid
        if let newPosition: UITextPosition = self.hatAddressTextField.position(from: selectedRange, offset: -domain.count) {
            
            // set the new position
            self.hatAddressTextField.selectedTextRange = self.hatAddressTextField.textRange(from: newPosition, to: newPosition)
        }
        
        self.updateButtonState(textFieldCharactersCount: (self.hatAddressTextField.text?.count ?? 0) - domain.count)
        self.updateHatNameAndClusterLabels()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptableCharacters = "abcdefghijklmnopqrstuvwxyz0123456789"
        let cs = CharacterSet(charactersIn: acceptableCharacters).inverted
        let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
        if string != filtered {
            
            return false
        }
        
        if range.location == 0 && string != "" {
            
            let acceptableNumericalCharacters = "0123456789"
            let csNumerical = CharacterSet(charactersIn: acceptableNumericalCharacters).inverted
            let filteredNumerical: String = (string.components(separatedBy: csNumerical) as NSArray).componentsJoined(by: "")
            if string == filteredNumerical {
                
                return false
            }
        }
        
        if textField.text!.count - self.cluster.count > 22 {
            
            // that means user tapped backspace
            if string == "" {
                
                return true
            }
            
            return false
        }
        
        textField.addFontChangingBasedOnText(range: range, string: string)

        let cluster = ".\(self.cluster)"
        let nsString = textField.text as NSString?
        let nsRange = nsString?.range(of: cluster)
        
        if (range.intersection(nsRange!) != nil) && nsRange?.location != range.location {
            
            let arbitraryValue: Int = nsRange!.location
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: arbitraryValue) {
                
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.nextButtonAction(self)
        
        return true
    }
    
    // MARK: - Update button state
    
    /**
     Updates the button color and if it's selectable or not, depenting from the password score
     */
    private func updateButtonState(textFieldCharactersCount: Int) {
        
        if self.hatAddressTextField.text?.replacingOccurrences(of: ".\(self.cluster)", with: "") != "" && textFieldCharactersCount > 3 && textFieldCharactersCount < 23 {
            
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.backgroundColor = .selectionColor
            self.nextButton.setTitleColor(.mainColor, for: .normal)
        } else {
            
            self.nextButton.isUserInteractionEnabled = false
            self.nextButton.backgroundColor = .hatDisabled
            self.nextButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK: - Update button state
    
    /**
     Updates the hat name and hat cluster labels with what the user has entered in the textfield
     */
    private func updateHatNameAndClusterLabels() {
        
        if let hatAddress = self.hatAddressTextField.text {
            
            let array = hatAddress.split(separator: ".")
            if !array.isEmpty {
                
                let hatName = array[0]
                
                self.hatNameLabel.text = String(describing: hatName)
                self.hatClusterLabel.text = ".\(self.cluster)"
            }
        }
        
        if self.hatAddressTextField.text?.replacingOccurrences(of: ".\(self.cluster)", with: "") == "" {
            
            self.hatNameLabel.text = "yourname"
            self.hatClusterLabel.text = ".\(self.cluster)"
        }
        
        self.animateLayoutChanges()
    }

}
