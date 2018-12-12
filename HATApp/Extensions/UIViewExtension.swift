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

// MARK: Extension

internal extension UIView {
    
    // MARK: - PeakSide enum
    
    /// An enum to define the side to which we want to add a pike
    internal enum PeakSide: Int {
        
        case Top
        case Left
        case Right
        case Bottom
    }
    
    // MARK: - Add pike
    
    /**
     Adds a pike on the side passed as a parameter with the size of the parameter
     
     - parameter side: The side to add a pike
     - parameter size: The size of the pike to add
     */
    internal func addPikeOnView(side: PeakSide, size: CGFloat = 10.0) {
        
        self.layoutIfNeeded()
        
        let peakLayer: CAShapeLayer = CAShapeLayer()
        peakLayer.cornerRadius = 3
        var path: CGPath?
        
        switch side {
            
        case .Top:
            
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: size, rightSize: 0.0, bottomSize: 0.0, leftSize: 0.0)
        case .Left:
            
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: 0.0, leftSize: size)
        case .Right:
            
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: size, bottomSize: 0.0, leftSize: 0.0)
        case .Bottom:
            
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: size, leftSize: 0.0)
        }
        
        peakLayer.path = path
        
        let color: CGColor? = self.backgroundColor?.cgColor
        peakLayer.fillColor = color
        peakLayer.strokeColor = color
        peakLayer.lineWidth = 1
        peakLayer.position = CGPoint.zero
        
        self.layer.insertSublayer(peakLayer, at: 0)
    }
    
    // MARK: - Create Peak Path
    
    /**
     Add pikes on the specified side
     
     - parameter rect: The frame of the view
     - parameter topSize: The pike to add on the top
     - parameter rightSize: The pike to add on the right
     - parameter bottomSize: The pike to add on the bottom
     - parameter leftSize: The pike to add on the left
     
     - returns: The path of the view, including the pikes
     */
    func makePeakPathWithRect(rect: CGRect, topSize ts: CGFloat, rightSize rs: CGFloat, bottomSize bs: CGFloat, leftSize ls: CGFloat) -> CGPath {
        
        //                      P3
        //                    /    \
        //      P1 -------- P2     P4 -------- P5
        //      |                               |
        //      |                               |
        //      P16                            P6
        //     /                                 \
        //  P15                                   P7
        //     \                                 /
        //      P14                            P8
        //      |                               |
        //      |                               |
        //      P13 ------ P12    P10 -------- P9
        //                    \   /
        //                     P11
        
        let centerX: CGFloat = rect.width / 2
        let centerY: CGFloat = rect.height / 2
        var h: CGFloat = 0
        let path: CGMutablePath = CGMutablePath()
        var points: [CGPoint] = []
        
        // P1
        points.append(CGPoint(x:rect.origin.x,y: rect.origin.y))
        // Points for top side
        if ts > 0 {
            
            h = ts * sqrt(3.0) / 2
            let x: CGFloat = rect.origin.x + centerX
            let y: CGFloat = rect.origin.y
            points.append(CGPoint(x:x - ts,y: y))
            points.append(CGPoint(x:x,y: y - h))
            points.append(CGPoint(x:x + ts,y: y))
        }
        
        // P5
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y))
        // Points for right side
        if rs > 0 {
            
            h = rs * sqrt(3.0) / 2
            let x: CGFloat = rect.origin.x + rect.width
            let y: CGFloat = rect.origin.y + centerY
            points.append(CGPoint(x:x,y: y - rs))
            points.append(CGPoint(x:x + h,y: y))
            points.append(CGPoint(x:x,y: y + rs))
        }
        
        // P9
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y + rect.height))
        // Point for bottom side
        if bs > 0 {
            
            h = bs * sqrt(3.0) / 2
            let x: CGFloat = rect.origin.x + centerX
            let y: CGFloat = rect.origin.y + rect.height
            points.append(CGPoint(x:x + bs,y: y))
            points.append(CGPoint(x:x,y: y + h))
            points.append(CGPoint(x:x - bs,y: y))
        }
        
        // P13
        points.append(CGPoint(x:rect.origin.x, y: rect.origin.y + rect.height))
        // Point for left sidey:
        if ls > 0 {
            
            h = ls * sqrt(3.0) / 2
            let x: CGFloat = rect.origin.x
            let y: CGFloat = rect.origin.y + centerY
            points.append(CGPoint(x:x, y: y + ls))
            points.append(CGPoint(x:x - h, y: y))
            points.append(CGPoint(x:x, y: y - ls))
        }
        
        let startPoint: CGPoint = points.removeFirst()
        self.startPath(path: path, onPoint: startPoint)
        
        for point in points {
            
            self.addPoint(point: point, toPath: path)
        }
        
        self.addPoint(point: startPoint, toPath: path)
        return path
    }
    
    // MARK: - Start path
    
    /**
     Start drawing the path
     
     - parameter path: The path
     - parameter point: The point
     */
    private func startPath(path: CGMutablePath, onPoint point: CGPoint) {
        
        path.move(to: CGPoint(x: point.x, y: point.y))
    }
    
    // MARK: - Add point
    
    /**
     Adds a like with the specified parameters
     
     - parameter point: Adds line to that point
     - parameter path: Adss the line to that path
     */
    private func addPoint(point: CGPoint, toPath path: CGMutablePath) {
        
        path.addLine(to: CGPoint(x: point.x, y: point.y))
    }
    
    // MARK: - Round top corners
    
    /**
     Rounds the 2 top corners
     
     - parameter roundingCorners: The corners to round
     - parameter cornerRadious: Th corner radious to add
     - parameter bounds: The bounds of the view, nil is the default one

     - returns: Returns the UIView with rounded top corners
     */
    @discardableResult
    func roundCorners(roundingCorners: UIRectCorner, cornerRadious: Int, bounds: CGRect? = nil) -> UIView {
        
        var bounds: CGRect? = bounds
        
        if bounds == nil {
            
            bounds = self.bounds
            bounds?.size.width = UIScreen.main.bounds.size.width
            let width: CGFloat = (bounds?.size.width)!
            let height: CGFloat = (bounds?.size.height)!
            bounds?.size = CGSize(width: width, height: height)
        }
        
        self.bounds = bounds!
        
        let path: UIBezierPath = UIBezierPath(
                                    roundedRect: self.bounds,
                                    byRoundingCorners: roundingCorners,
                                    cornerRadii: CGSize(width: cornerRadious, height: cornerRadious))
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
        return self
    }
    
    /**
     Adds the neccesary shadows and rounds the view in order to appear as a floating view
     */
    func makeViewFloating() {
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.selectionColor.cgColor
        self.addShadow(color: .lightGray, shadowRadius: 1, shadowOpacity: 0.5, width: 0, height: 2)
    }
    
    /**
     Adds border to the view
     
     - parameter width: The width of the border
     - parameter color: The colof of the border
     */
    func addBorder(width: CGFloat, color: UIColor?) {
        
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
    }
    
    /**
     Adds shadow to the view
     
     - parameter color: The color of the shadow
     - parameter shadowRadius: The radius of the shadow
     - parameter shadowOpacity: The opacity of the shadow
     - parameter width: The width of the shadow
     - parameter height: The height of the shadow
     */
    func addShadow(color: UIColor?, shadowRadius: CGFloat, shadowOpacity: Float, width: CGFloat, height: CGFloat) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: width, height: height)
    }
}
