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

// MARK: Struct

/// A struct holding the name of the most commonly used fonts in app
internal struct FontConstants {
    
    // MARK: - Static variables
    
    /**
     * Font name in system:
     *
     *     OpenSans-Light
     */
    static let openSansLight: String = "OpenSans-Light"
    
    /**
     * Font name in system:
     *
     *     Open Sans
     */
    static let openSans: String = "OpenSans"
    
    /**
     * Font name in system:
     *
     *     OpenSans-Semibold
     */
    static let openSansSemibold: String = "OpenSans-Semibold"
    
    /**
     * Font name in system:
     *
     *     OpenSans-Bold
     */
    static let openSansBold: String = "OpenSans-Bold"
    
    /**
     * Font name in system:
     *
     *     OpenSans-Extrabold
     */
    static let openSansExtrabold: String = "OpenSans-Extrabold"
    
    /**
     * Font name in system:
     *
     *     OpenSans-Italic
     */
    static let openSansItalic: String = "OpenSans-Italic"
    
    /**
     * Font name in system:
     *
     *     OpenSans-Extrabold
     */
    static let openSansCondenstBold: String = "OpenSans-CondensedBold"
    
    /**
     * Font name in system:
     *
     *     OpenSans-Italic
     */
    static let openSansCondenstLight: String = "OpenSans-ExtraboldItalic"
}

// MARK: - Extension

extension UIFont {
    
    // MARK: - Get font
    
    /**
     Tries to get the font with the specified name and size, if it fails it returns the system font of the specified size
     
     - parameter fontName: A String representing the name of the font
     - parameter ofSize: A CGFloat representing the size of the font

     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static private func getFont(fontName: String, ofSize: CGFloat) -> UIFont {
        
        if let font: UIFont = UIFont(name: fontName, size: ofSize) {
            
            return font
        }
        
        return systemFont(ofSize: ofSize)
    }
    
    // MARK: - Get specific fonts
    
    /**
     Tries to get the openSansLight font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func openSansLight(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.openSansLight, ofSize: ofSize)
    }
    
    /**
     Tries to get the open sans font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func openSans(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.openSans, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansItalic font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func openSansItalic(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.openSansItalic, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansSemibold font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func openSansSemibold(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.openSansSemibold, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansBold font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func openSansBold(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.openSansBold, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansExtrabold font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func openSansExtrabold(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.openSansExtrabold, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansCondenstBold font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func openSansCondenstBold(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.openSansCondenstBold, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansCondenstLigh font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func openSansCondenstLigh(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.openSansCondenstLight, ofSize: ofSize)
    }
}
