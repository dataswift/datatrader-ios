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

struct LocationObjectForUpload: HATObject {

    var latitude: Double?
    var longitude: Double?
    var horizontalAccuracy: Double?
    var verticalAccuracy: Double?
    var dateCreated: Int?
    var dateCreatedLocal: String?
    var speed: Double?
    var altitude: Double?
    var course: Double?
    
    init(location: LocationObject) {
        
        self.latitude = location.latitude
        self.longitude = location.longitude
        
        if location.horizontalAccuracy != -1 {
            
            self.horizontalAccuracy = location.horizontalAccuracy
        }
        
        if location.verticalAccuracy != -1 {
            
            self.verticalAccuracy = location.verticalAccuracy
        }
        
        if location.dateCreated != -1 {
            
            self.dateCreated = location.dateCreated
        }
        
        if location.dateCreatedLocal != "" {
            
            self.dateCreatedLocal = location.dateCreatedLocal
        }
        
        if location.speed != -1 {
            
            self.speed = location.speed
        }
        
        if location.altitude != -1 {
            
            self.altitude = location.altitude
        }
        
        if location.course != -1 {
            
            self.course = location.course
        }
    }
}
