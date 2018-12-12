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

import CoreLocation
import HatForIOS

struct MapLocation: HATObject {
    
    var location: HATLocationsObject = HATLocationsObject()
    var dataForAnnotationInfo: HATFeedObject?
    
    init() {
        
    }
    
    init(from post: HATFacebookSocialFeedObject) {
        
        var tempObject = HATFeedObject()
        tempObject.date.iso = HATFormatterHelper.formatDateToISO(date: post.data.posts.createdTime!)
        tempObject.date.unix = Int(post.data.posts.createdTime!.timeIntervalSince1970)
        tempObject.title.text = "You posted"
        tempObject.source = "facebook"
        tempObject.content = HATFeedContentObject()
        tempObject.content?.text = post.data.posts.message
        
        if post.data.posts.picture != "" {
            
            let mediaObject = HATFeedContentMediaObject(url: post.data.posts.picture)
            tempObject.content?.media = []
            tempObject.content?.media?.append(mediaObject)
        }
        self.dataForAnnotationInfo = tempObject
        
        var tempLocation = HATLocationsObject()
        tempLocation.data.latitude = post.data.posts.place!.location.latitude
        tempLocation.data.longitude = post.data.posts.place!.location.longitude
        self.location = tempLocation
    }
    
    init(from event: HATGoogleCalendarObject, completion: @escaping(MapLocation) -> Void) {
        
        var tempSelf = self
        var tempObject = HATFeedObject()
        tempObject.date.iso = event.data.created
        let date = HATFormatterHelper.formatStringToDate(string: event.data.created)
        tempObject.date.unix = Int(HATFormatterHelper.formatDateToEpoch(date: date!)!)!
        tempObject.title.text = "You have an event"
        tempObject.source = "google"
        tempObject.content = HATFeedContentObject()
        tempObject.content?.text = event.data.summary
        
        tempSelf.dataForAnnotationInfo = tempObject
        
        var tempLocation = HATLocationsObject()
        LocationManager.geoCodeUsingAddress(address: event.data.location!, completionLocation: { coordinates in
            
            tempLocation.data.latitude = coordinates.latitude
            tempLocation.data.longitude = coordinates.longitude
            tempSelf.location = tempLocation
            completion(tempSelf)
        })
    }
    
    init(from location: LocationObject) {
        
        var tempLocation = HATLocationsObject()
        tempLocation.data.latitude = location.latitude
        tempLocation.data.longitude = location.longitude
        tempLocation.data.dateCreated = location.dateCreated
        tempLocation.data.dateCreatedLocal = location.dateCreatedLocal
        tempLocation.data.altitude = Float(location.altitude)
        tempLocation.data.course = Float(location.course)
        tempLocation.data.speed = Float(location.speed)
        tempLocation.data.verticalAccuracy = Float(location.verticalAccuracy)
        tempLocation.data.horizontalAccuracy = Float(location.horizontalAccuracy)
        self.location = tempLocation
        
        var tempObject = HATFeedObject()
        let speed: Double
        if location.speed > 0 {
            
            speed = location.speed
        } else {
            
            speed = 0
        }
        let date = Date(timeIntervalSince1970: TimeInterval(location.dateCreated))
        tempObject.date.iso = HATFormatterHelper.formatDateToISO(date: date)
        tempObject.date.unix = location.dateCreated
        tempObject.title.text = "You were here"
        tempObject.source = "location"
        tempObject.content = HATFeedContentObject()
        tempObject.content?.text =
        """
        - Your latitude was: \(FormatterManager.roundToDecimal(number:location.latitude, fractionDigits: 5))
        - Your longitude was: \(FormatterManager.roundToDecimal(number:location.longitude, fractionDigits: 5))
        - Your speed was: \(FormatterManager.formatGPSSpeedToUsersSpeedUnit(speed: speed))
        - Your course was: \(location.course)°
        - Your altitude was: \(FormatterManager.formatGPSAltimeterToUsersDistanceUnit(altimeter: location.altitude))
        - You were here on: \(String(describing: FormatterManager.formatDateStringToUsersDefinedDate(date: date, dateStyle: .short, timeStyle: .long)))
        - Sync status: \(location.syncStatus)
        """
        self.dataForAnnotationInfo = tempObject
    }
    
    init(from feed: HATFeedObject, coordinates: CLLocationCoordinate2D?) {
        
        guard let location = feed.location else { return }
        
        var tempLocation = HATLocationsObject()
        
        tempLocation.data.latitude = coordinates?.latitude ?? Double(location.geo!.latitude)
        tempLocation.data.longitude = coordinates?.longitude ?? Double(location.geo!.longitude)
        tempLocation.data.dateCreated = feed.date.unix
        tempLocation.data.altitude = 0
        tempLocation.data.course = 0
        tempLocation.data.speed = 0
        tempLocation.data.verticalAccuracy = 0
        tempLocation.data.horizontalAccuracy = 0
        self.location = tempLocation
        
        var tempObject = HATFeedObject()
        tempObject = feed
        
        if feed.content?.media != nil {
            
            guard !feed.content!.media!.isEmpty else { return }
            
            let url: String
            if feed.content!.media![0].url != nil {
                
                url = feed.content!.media![0].url!
            } else if feed.content!.media![0].thumbnail != nil {
                
                url = feed.content!.media![0].thumbnail!
            } else {
                
                url = ""
            }
            let mediaObject = HATFeedContentMediaObject(url: url)
            tempObject.content?.media = []
            tempObject.content?.media?.append(mediaObject)
        }
        
        self.dataForAnnotationInfo = tempObject
    }
    
    init(location: HATLocationsObject, object: HATFeedObject?) {
        
        self.location = location
        let speed: Double
        if location.data.speed != nil && location.data.speed! > 0 {
            
            speed = Double(location.data.speed!)
        } else {
            
            speed = 0
        }
        var tempObject = HATFeedObject()
        let date = Date(timeIntervalSince1970: TimeInterval(location.data.dateCreated))
        tempObject.date.iso = HATFormatterHelper.formatDateToISO(date: date)
        tempObject.date.unix = location.data.dateCreated
        tempObject.title.text = "You were here"
        tempObject.source = "location"
        tempObject.content = HATFeedContentObject()
        tempObject.content?.text =
        """
        - Your latitude was: \(FormatterManager.roundToDecimal(number:location.data.latitude, fractionDigits: 5))
        - Your longitude was: \(FormatterManager.roundToDecimal(number:location.data.longitude, fractionDigits: 5))
        - Your speed was: \(FormatterManager.formatGPSSpeedToUsersSpeedUnit(speed: speed))
        - Your course was: \(location.data.course ?? 0)°
        - Your altitude was: \(FormatterManager.formatGPSAltimeterToUsersDistanceUnit(altimeter: Double(location.data.altitude ?? 0)))
        - You were here on: \(String(describing: FormatterManager.formatDateStringToUsersDefinedDate(date: date, dateStyle: .short, timeStyle: .long)))
        - Sync status: synced
        """
        self.dataForAnnotationInfo = tempObject
    }
}
