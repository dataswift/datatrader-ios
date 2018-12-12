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

// MARK: Extension

extension NSAttributedString {
    
    // MARK: - Combine 2 attributed strings
    
    /**
     Combines 2 attributed strings together
     
     - parameter attributedText: The second attributed string to combine
     
     - returns: An attributed string based on the string that called this method and the string passed as parameter
     */
    func combineWith(attributedText: NSAttributedString) -> NSAttributedString {
        
        let combination: NSMutableAttributedString = NSMutableAttributedString()
        
        combination.append(self)
        combination.append(attributedText)
        
        return combination
    }
    
    /**
     Formatts the requirements to show in a nice way
     
     - parameter requiredDataDefinition: The requred data definition array, holding all the requirements for this offer
     
     - returns: An NSMutableString with the requirements formmated as needed
     */
    class func formatRequiredDataDefinitionText(requiredDataDefinition: [DataOfferRequiredDataDefinitionObjectV2], indexToRead: Int? = nil) -> NSMutableAttributedString {
        
        let textToReturn = NSMutableAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.font: UIFont.openSans(ofSize: 13)])
        
        for requiredData in requiredDataDefinition {
            
            let dictionary = requiredData.bundle

            if indexToRead == nil {
                
                for dict in dictionary {
                    
                    let endpoints = dict.value.endpoints
                    
                    for endpoint in endpoints {
                        
                        let tempString = NSMutableAttributedString(
                            string: "\(endpoint.endpoint)\n",
                            attributes: [NSAttributedString.Key.font: UIFont.openSansExtrabold(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.mainColor])
                        textToReturn.append(tempString)
                        
                        if endpoint.mapping != nil {
                            
                            for item in endpoint.mapping! {
                                
                                let tempString2 = NSMutableAttributedString(
                                    string: "\t\(item.key)\n",
                                    attributes: [NSAttributedString.Key.font: UIFont.openSans(ofSize: 13)])
                                
                                textToReturn.append(tempString2)
                            }
                        }
                    }
                }
            } else {
                
                for (index, dict) in dictionary.enumerated() where index == indexToRead! {
                    
                    let endpoints = dict.value.endpoints
                    
                    for endpoint in endpoints {
                        
                        let tempString = NSMutableAttributedString(
                            string: "Fields required        \n\n",
                            attributes: [NSAttributedString.Key.font: UIFont.openSansExtrabold(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.sectionTextColor])
                        textToReturn.append(tempString)
                        
                        if endpoint.mapping != nil {
                            
                            for item in endpoint.mapping! {
                                
                                let tempString2 = NSMutableAttributedString(
                                    string: "\t\(item.key)\n",
                                    attributes: [NSAttributedString.Key.font: UIFont.openSans(ofSize: 13)])
                                
                                textToReturn.append(tempString2)
                            }
                        }
                    }
                }
            }
        }

        return textToReturn
    }
}

