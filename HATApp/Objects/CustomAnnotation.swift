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

import Cluster
import MapKit

public class CustomAnnotation: Annotation {
    
    var mapLocation: MapLocation?
    
    public func setUpCluster(mapView: MKMapView) -> MKAnnotationView? {
        
        let identifier = "Pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if let view = view {
            
            view.annotation = self
        } else {
            
            view = MKAnnotationView(annotation: self, reuseIdentifier: identifier)
            view?.canShowCallout = false
            view?.backgroundColor = .clear
        }
        
        if let source = self.mapLocation?.dataForAnnotationInfo?.source {
            
            if source == "google" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.googlePin)
            } else if source == "facebook" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.facebookPin)
            } else if source == "location" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.locationPin)
            } else if source == "twitter" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.twitterPin)
            } else if source == "spotify" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.spotifyPin)
            } else if source == "fitbit" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.fitbitPin)
            } else if source == "notables" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.notablesPin)
            } else if source == "monzo" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.monzoPin)
            } else if source == "starling" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.starlingPin)
            } else if source == "instagram" {
                
                view?.tintColor = .clear
                view?.image = UIImage(named: ImageNamesConstants.instagramPin)
            }
        } else {
            
            switch self.style! {
            case .color(let color, _):
                
                let pin = view as? MKPinAnnotationView
                pin?.annotation = self
                pin?.pinTintColor = color
                view = pin
            case .image(let image):
                
                view?.image = image
            }
        }
        
        return view
    }
}
