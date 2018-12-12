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

extension HATProfileObject {
    
    // MARK: - Struct

    /// A struct holding info usefull to mapping to PHATA structure
    struct FieldInfo {
        
        // MARK: - Variables
        
        /// The key-value path
        var string: WritableKeyPath<HATProfileObject, String> = \HATProfileObject.data.personal.firstName
        // The tag of the field, used to identify some "special" fields
        var tag: Int = 0
        // The placeholder to show on the textField/textView
        var placeholder = ""
        
        // MARK: - Initialisers
        
        /**
         Initialises the field based on the parameters passed on
         
         - parameter string: The key-value path to the field
         - parameter tag: The tag of the field
         - parameter placeholder: The placeholder of the textField/textView
         */
        init(string: WritableKeyPath<HATProfileObject, String>, tag: Int, placeholder: String) {
            
            self.string = string
            self.tag = tag
            self.placeholder = placeholder
        }
    }
    
    //MARK: - Key-value mapping
    
    static let mapping = [
        "(1, 1)": FieldInfo(string: \HATProfileObject.data.personal.firstName, tag: 0, placeholder: "First name"),
        "(1, 2)": FieldInfo(string: \HATProfileObject.data.personal.lastName, tag: 0, placeholder: "Last name"),
        "(1, 3)": FieldInfo(string: \HATProfileObject.data.personal.gender, tag: 50, placeholder: "Gender"),
        "(1, 4)": FieldInfo(string: \HATProfileObject.data.personal.birthDate, tag: 55, placeholder: "Birthday"),
        "(1, 5)": FieldInfo(string: \HATProfileObject.data.contact.primaryEmail, tag: 0, placeholder: "Primary email"),
        "(1, 6)": FieldInfo(string: \HATProfileObject.data.contact.alternativeEmail, tag: 0, placeholder: "Alternative email"),
        "(1, 7)": FieldInfo(string: \HATProfileObject.data.contact.mobile, tag: 0, placeholder: "Mobile phone number"),
        "(1, 8)": FieldInfo(string: \HATProfileObject.data.contact.landline, tag: 0, placeholder: "Home phone number"),
        "(2, 1)": FieldInfo(string: \HATProfileObject.data.online.facebook, tag: 0, placeholder: "Facebook profile"),
        "(2, 2)": FieldInfo(string: \HATProfileObject.data.online.twitter, tag: 0, placeholder: "Twitter profile"),
        "(2, 3)": FieldInfo(string: \HATProfileObject.data.online.linkedin, tag: 0, placeholder: "Linkedin"),
        "(2, 4)": FieldInfo(string: \HATProfileObject.data.online.youtube, tag: 0, placeholder: "Youtube"),
        "(2, 5)": FieldInfo(string: \HATProfileObject.data.online.website, tag: 0, placeholder: "Website"),
        "(2, 6)": FieldInfo(string: \HATProfileObject.data.online.blog, tag: 0, placeholder: "Blog"),
        "(2, 7)": FieldInfo(string: \HATProfileObject.data.online.google, tag: 0, placeholder: "Google"),
        "(3, 1)": FieldInfo(string: \HATProfileObject.data.about.title, tag: 0, placeholder: "Title"),
        "(3, 2)": FieldInfo(string: \HATProfileObject.data.about.body, tag: 0, placeholder: "Say something nice about yourself for the world to see"),
        ]
}
