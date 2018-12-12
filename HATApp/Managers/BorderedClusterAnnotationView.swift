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

// MARK: Class

public class BorderedClusterAnnotationView: ClusterAnnotationView {
    
    // MARK: - Variables
    
    /// The color of the border
    let borderColor: UIColor
    
    // MARK: - Initialisers
    
    /**
     Initialise a cluster
     
     - parameter annotation: The annotation to customise
     - parameter reuseIdentifier: A reuse identifier for the cluster
     - parameter style: The style of the clucter
     - parameter borderColor: The color of the border
     - parameter clusterIsBeingMadeOfDifferentLocationSources: A flag to know if the cluster is formed of multiple sources pins
     */
    public init(annotation: MKAnnotation?, reuseIdentifier: String?, style: ClusterAnnotationStyle, borderColor: UIColor, clusterIsBeingMadeOfDifferentLocationSources: Bool) {
        
        self.borderColor = borderColor
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier, style: style)
        
        self.configure(with: style, clusterIsBeingMadeOfDifferentLocationSources: clusterIsBeingMadeOfDifferentLocationSources)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        self.borderColor = .clear
        super.init(coder: aDecoder)
    }
    
    // MARK: - Set up
    
    /**
     Set up a cluster to a specific style
     
     - parameter style: The style of the cluster
     */
    public override func configure(with style: ClusterAnnotationStyle) {
        
        super.configure(with: style)
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 5
    }
    
    /**
     Set up a cluster to a specific style
     
     - parameter style: The style of the cluster
     - parameter clusterIsBeingMadeOfDifferentLocationSources: A flag to know if the cluster is formed of multiple sources pins
     */
    public func configure(with style: ClusterAnnotationStyle, clusterIsBeingMadeOfDifferentLocationSources: Bool) {
        
        super.configure(with: style)
        
        if clusterIsBeingMadeOfDifferentLocationSources {
            
            self.backgroundColor = .clusterRed
        } else {
            
            self.backgroundColor = .mainColor
        }
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 5
    }
}
