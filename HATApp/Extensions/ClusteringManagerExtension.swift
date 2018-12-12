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
import CoreLocation
import MapKit

// MARK: Extension

extension ClusterManager {

    // MARK: - Create annotations for the locations
    
    /**
     Converts the LocationsObjects to pins to add in the map later
     
     - parameter locations: The LocationsObjects to convert to FBAnnotation, pins
     
     - returns: An array of Annotation, pins
     */
    func createAnnotationsFrom(locations: [CLLocation]) -> [Annotation] {
        
        var arrayToReturn: [Annotation] = []
        
        for item: CLLocation in locations {
            
            let pin: Annotation = Annotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude)
            pin.style = .color(.green, radius: 25)
            arrayToReturn.append(pin)
        }
        
        return arrayToReturn
    }
    
    // MARK: - Create annotations for the locations
    
    /**
     Converts the LocationsObjects to pins to add in thvarap later
     
     - parameter objects: The LocationsObjects to convert to FBAnnotation, pins
     
     - returns: An array of FBAnnotation, pins
     */
    func createAnnotationsFrom(objects: [MapLocation], image: UIImage? = nil, color: UIColor? = nil) -> [CustomAnnotation] {
        
        var arrayToReturn: [CustomAnnotation] = []
        
        for item: MapLocation in objects {
            
            let pin: CustomAnnotation = CustomAnnotation()
            let noise: Double = (Double(arc4random()) / Double(UINT32_MAX) * 2 - 1) / 10000
            
            pin.coordinate = CLLocationCoordinate2D(latitude: item.location.data.latitude + noise, longitude: item.location.data.longitude + noise)
            pin.mapLocation = item
            
            if image != nil {
                
                pin.style = .image(image!)
            } else {
                
                pin.style = .color(color ?? .green, radius: 25)
            }
            
            arrayToReturn.append(pin)
        }
        
        return arrayToReturn
    }
    
    // MARK: - Reposition map to fit the new points
    
    /**
     Updates map view with the annotations provided
     
     - parameter annotations: The annotations to add on the map in an array of FBAnnotation
     - parameter mapView: The mapView to show the cluster points to
     */
    func fitMapViewToAnnotationList(_ annotations: [Annotation], mapView: MKMapView) {
        
        // calculate map padding and zoom
        let mapEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        var zoomRect: MKMapRect = MKMapRect.null
        
        // create a point for each annotation
        for index: Int in 0..<annotations.count {
            
            let annotation: Annotation = annotations[index]
            let aPoint: MKMapPoint = MKMapPoint(annotation.coordinate)
            let rect: MKMapRect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 1000, height: 1000)
            
            if zoomRect.isNull {
                
                zoomRect = rect
            } else {
                
                zoomRect = zoomRect.union(rect)
            }
        }
        
        // focus map on the added points
        mapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
        if annotations.count == 1 {
            
            mapView.setCamera(.init(lookingAtCenter: annotations[0].coordinate, fromEyeCoordinate: annotations[0].coordinate, eyeAltitude: 1000), animated: true)
            //mapView.setCenter(annotations[0].coordinate, animated: true)
        }
    }
}
