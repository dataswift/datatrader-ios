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

// MARK: Extension

extension String {
    
    // MARK: - Generate random string
    
    /**
     Generates a random alphanumeric string
     
     - parameter length: The desired length of the random string
     
     - returns: The random String
     */
    static func random(length: Int = 20) -> String {
        
        let base: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            
            let randomValue: UInt32 = arc4random_uniform(UInt32(base.count))
            let tempIntValue: Int = Int(randomValue)
            let index: String.Index = base.index(base.startIndex, offsetBy: tempIntValue)
            let stringToAppend: String = "\(base[index])"
            randomString += stringToAppend
        }
        
        return randomString
    }
    
    // MARK: - Convert from base64URL to base64
    
    /**
     String extension to convert from base64Url to base64
     
     - parameter stringToConvert: The string to be converted
     
     - returns: A Base64 String
     */
    func fromBase64URLToBase64(stringToConvert: String) -> String {
        
        var convertedString: String = stringToConvert
        if convertedString.count % 4 == 2 {
            
            convertedString += "=="
        } else if convertedString.count % 4 == 3 {
            
            convertedString += "="
        }
        
        convertedString = convertedString.replacingOccurrences(of: "-", with: "+")
        convertedString = convertedString.replacingOccurrences(of: "_", with: "/")
        
        return convertedString
    }
    
    // MARK: - Split a comma separated string to an Array of String
    
    /**
     Transforms a comma seperated string into an array
     
     - returns: An array of String with all the words of the string that called this method
     */
    func stringToArray() -> [String] {
        
        let trimmedString: String = self.replacingOccurrences(of: " ", with: "")
        var array: [String] = trimmedString.components(separatedBy: ",")
        
        if array.last == "" {
            
            array.removeLast()
        }
        
        return array
    }
    
    // MARK: - Trim string
    
    /**
     Trims a given String
     
     - returns: trimmed String
     */
    func trimString() -> String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // MARK: - Text Attributes
    
    /**
     Creates an attributed string from the parameters passed
     
     - parameter foregroundColor: Foreground color of the string
     - parameter strokeColor: stroke color of the string
     - parameter font: the desired font for the string
     
     - returns: An attributed string formatted according to the parameters
     */
    func createTextAttributes(foregroundColor: UIColor, strokeColor: UIColor, font: UIFont) -> NSAttributedString {
        
        //swiftlint:disable force_cast
        let textAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: foregroundColor,
            NSAttributedString.Key.strokeColor: strokeColor,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.strokeWidth: -1.0
        ]
        //swiftlint:enable force_cast
        
        return NSAttributedString(string: self, attributes: textAttributes)
    }
    
    // MARK: - Print font names
    
    /**
     Used in development to check the font names when needed
     */
    func printFonts() {
        
        let fontFamilyNames = UIFont.familyNames
        
        for familyName in fontFamilyNames {
            
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    // MARK: - String to HTML
    
    /**
     Converts a string to HTML formatted NSAttributedString
     
     - returns: An HTML formatted attributed string
     */
    func convertHtml() -> NSAttributedString {
        
        //var att: NSDictionary? = [NSAttributedStringKey.font: UIFont.avenirLight(ofSize: 50)]
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        do {
            
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            
            return NSAttributedString()
        }
    }
    
    // MARK: - Calculate label height
    
    /**
     Calculates and returns the height a label will need to have for the given string
     
     - parameter maxWidth: The maximum allowed width of the label
     - parameter font: The font of the label
     
     - returns: The calculated height of the label with the font specified
     */
    func calculateLabelHeight(maxWidth: CGFloat, font: UIFont) -> CGFloat {
        
        let labelFrame = CGRect(x: 0, y: 0, width: maxWidth, height: 1)
        
        let label = UILabel(frame: labelFrame)
        label.isHidden = true
        label.numberOfLines = 0
        
        label.font = font
        label.text = self.trimString().trimmingCharacters(in: CharacterSet.newlines)
        
        return label.systemLayoutSizeFitting(labelFrame.size, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow).height
    }
}
