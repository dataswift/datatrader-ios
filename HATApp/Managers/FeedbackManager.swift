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

// MARK: Struct

struct FeedbackManager {
    
    // MARK: - Vibrate

    /**
     Vibrates the phone(iPhone 7 and later) based on the type passed on
     
     - parameter type: The type of the impact
     */
    static func vibrateWithHapticIntensity(type: UIImpactFeedbackGenerator.FeedbackStyle) {
        
        let generator = UIImpactFeedbackGenerator(style: type)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /**
     Vibrates the phone(iPhone 7 and later) based on the type passed on
     
     - parameter type: The type of the notification
     */
    static func vibrateWithHapticEvent(type: UINotificationFeedbackGenerator.FeedbackType) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
