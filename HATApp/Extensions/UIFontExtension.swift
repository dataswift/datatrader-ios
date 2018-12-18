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
     *     Oswald-Light
     */
    static let oswaldLight: String = "Oswald-Light"
    
    /**
     * Font name in system:
     *
     *     Open Sans
     */
    static let oswaldRegular: String = "Oswald-Regular"
    
    /**
     * Font name in system:
     *
     *     Oswald-Semibold
     */
    static let oswaldSemibold: String = "Oswald-Semibold"
    
    /**
     * Font name in system:
     *
     *     Oswald-Bold
     */
    static let oswaldBold: String = "Oswald-Bold"
    
    /**
     * Font name in system:
     *
     *     Oswald-Extrabold
     */
    static let oswaldExtrabold: String = "Oswald-Extrabold"
    
    /**
     * Font name in system:
     *
     *     Oswald-Italic
     */
    static let oswaldItalic: String = "Oswald-Italic"
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
    static func oswaldLight(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.oswaldLight, ofSize: ofSize)
    }
    
    /**
     Tries to get the open sans font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func oswald(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.oswaldRegular, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansItalic font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func oswaldItalic(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.oswaldItalic, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansSemibold font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func oswaldSemibold(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.oswaldSemibold, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansBold font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func oswaldBold(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.oswaldBold, ofSize: ofSize)
    }
    
    /**
     Tries to get the openSansExtrabold font with the specified size, if it fails it returns the system font of the specified size
     
     - parameter ofSize: A CGFloat representing the size of the font
     
     - returns: The requested by name UIFont or the systemFont if the requested font wasn't found
     */
    static func oswaldExtrabold(ofSize: CGFloat) -> UIFont {
        
        return UIFont.getFont(fontName: FontConstants.oswaldExtrabold, ofSize: ofSize)
    }
}
