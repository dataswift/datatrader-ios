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

extension UIColor {
    
    // MARK: - Staticly defined colors
    
    // swiftlint:disable object_literal
    
    /// The main HAT APP selection color
    static let classicHATSelectionColor: UIColor = UIColor(red: 98 / 255, green: 151 / 255, blue: 177 / 255, alpha: 1)
    /// The main HAT App color
    static let classicHATColor: UIColor = UIColor(red: 74 / 255, green: 85 / 255, blue: 107 / 255, alpha: 1)

    /// The main color of the App
    static let mainColor: UIColor = UIColor(red: 75 / 255, green: 85 / 255, blue: 106 / 255, alpha: 1)
    /// The main color of the App
    static let appBlackColor: UIColor = UIColor(red: 71 / 255, green: 71 / 255, blue: 71 / 255, alpha: 1)
    /// The color that is being used in buttons or selectable views in general
    static let selectionColor: UIColor = UIColor(red: 239 / 255, green: 196 / 255, blue: 46 / 255, alpha: 1)
    /// The color used by labels in the sections of the she feed
    static let sectionTextColor: UIColor = UIColor(red: 154 / 255, green: 154 / 255, blue: 154 / 255, alpha: 1)
    /// The color used in placeholder text
    static let textFieldPlaceHolder: UIColor = UIColor(red: 206 / 255, green: 206 / 255, blue: 211 / 255, alpha: 1)
    /// The color used as a background gray color for many views accross the app
    static let hatGrayBackground: UIColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
    /// The color used for a shadow in the profile buttons
    static let shadowColor: UIColor = UIColor(red: 55 / 255, green: 70 / 255, blue: 90 / 255, alpha: 1)
    /// the color used in calendar to indicate the date range selection
    static let calendarSelectedRangeSelectionColor: UIColor = UIColor(red: 240 / 255, green: 196 / 255, blue: 0 / 255, alpha: 1)
    /// The deselected gray for items that aren't user selectable
    static let hatDisabled: UIColor = UIColor(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 1)
    /// The color used in the password strength meter for bad passwords
    static let hatPasswordRed: UIColor = UIColor(red: 227 / 255, green: 102 / 255, blue: 130 / 255, alpha: 1)
    /// The color used in the password strength meter for mediocre passwords
    static let hatPasswordOrange: UIColor = UIColor(red: 240 / 255, green: 196 / 255, blue: 0 / 255, alpha: 1)
    /// The color used in the password strength meter for good or very good passwords
    static let hatPasswordGreen: UIColor = UIColor(red: 138 / 255, green: 187 / 255, blue: 156 / 255, alpha: 1)
    /// The color used in the password strength meter for the background color
    static let hatPasswordGray: UIColor = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1)
    /// The color for the cluster in maps when there are more than one source
    static let clusterRed: UIColor = UIColor(red: 239 / 255, green: 83 / 255, blue: 80 / 255, alpha: 1)
    
    static let pageControlSelectedColor: UIColor = UIColor(red: 96/255, green: 114/255, blue: 213/255, alpha: 1)
    static let pageControlColor: UIColor = UIColor(red: 223/255, green: 225/255, blue: 240/255, alpha: 1)
    static let navigationBarColor: UIColor = UIColor(red: 75/255, green: 85/255, blue: 106/255, alpha: 1)

    // swiftlint:enable object_literal
}
