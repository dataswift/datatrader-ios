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

// MARK: Struct

public struct HATJSONHelper {
    
    // MARK: - Create JSON for file uploading
    
    /**
     Creates the json file to purchase a HAT
     
     - parameter fileName: The file name of the photo
     - parameter tags: The tags attached to the photo
     - returns: A Dictionary <String, Any>
     */
    static func createFileUploadingJSONFrom(fileName: String, tags: [String]) -> Dictionary <String, Any> {
        
        // the final JSON file to be returned
        return [
            
            "name": fileName,
            "source": "rumpel",
            "tags": tags
            ] as [String : Any]
    }
    
    // MARK: - Create JSON for nationality uploading
    
    /**
     Creates the json file to upload the nationality to  HAT
     
     - parameter nationality: The HATNationalityObject with all the necessary values
     - returns: A Dictionary <String, String>
     */
    static func createFileUploadingJSONFrom(nationality: HATNationalityObject) -> Dictionary <String, String> {
        
        // the final JSON file to be returned
        return [
            
            "nationality": nationality.nationality,
            "passportHeld": nationality.passportHeld,
            "passportNumber": nationality.passportNumber,
            "placeOfBirthe": nationality.placeOfBirth,
            "language": nationality.language
            ] as [String : String]
    }
}
