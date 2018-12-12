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

// MARK: Class

class DataPreviewsFeedLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    
    /// A delegate to notify for any changes
    weak var delegate: CustomFeedLayoutDelegate!
    
    /// The number of columns
    fileprivate var numberOfColumns = 1
    /// The padding of the cells
    fileprivate var cellPadding: CGFloat = 0
    
    // This is an array to cache the calculated attributes. When you call prepare(), you’ll calculate the attributes for all items and add them to the cache. When the collection view later requests the layout attributes, you can be efficient and query the cache instead of recalculating them every time.
    /// An array to store the layoutattributes for easy access
    var cache = [UICollectionViewLayoutAttributes]()
    /// The frames of the cells
    private var frames: [CGRect] = []
    
    // This declares two properties to store the content size. contentHeight is incremented as photos are added, and contentWidth is calculated based on the collection view width and its content inset.
    /// The content height of the collectionVIew
    fileprivate var contentHeight: CGFloat = 0
    /// The content width of the collectonView
    fileprivate var contentWidth: CGFloat {
        
        guard let collectionView = collectionView else {
            
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    /// The content size of the collectionView
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: - Prepare collectionView
    
    // Note: As prepare() is called whenever the collection view's layout is invalidated, there are many situations in a typical implementation where you might need to recalculate attributes here. For example, the bounds of the UICollectionView might change - such as when the orientation changes - or items may be added or removed from the collection. These cases are out of scope for this tutorial, but it's important to be aware of them in a non-trivial implementation.
    override func prepare() {
        
        // 1
        guard let collectionView = collectionView else {
            
            return
        }
        
        guard collectionView.numberOfSections > 0 else {
            
            return
        }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for row in 0 ..< (collectionView.numberOfItems(inSection: 0)) {
            
            let indexPath = IndexPath(item: row, section: 0)
            
            // This is where you perform the frame calculation. width is the previously calculated cellWidth, with the padding between cells removed. You ask the delegate for the height of the photo and calculate the frame height based on this height and the predefined cellPadding for the top and bottom. You then combine this with the x and y offsets of the current column to create the insetFrame used by the attribute.
            let photoHeight = delegate.collectionView(collectionView, heightForSheFeedItemAtIndexPath: indexPath)
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding / 2, dy: 0)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.insert(attributes, at: row)
            frames.insert(attributes.frame, at: row)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        
        //contentHeight += CGFloat(collectionView.numberOfItems(inSection: 0) * 10)
    }
    
    // MARK: - Layout
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard !cache.isEmpty else { return nil }
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache where attributes.frame.intersects(rect) {
            
            visibleLayoutAttributes.append(attributes)
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cache[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        // if you don't want to re-calculate everything on scroll
        return !newBounds.size.equalTo(self.collectionView!.frame.size)
    }
    
    /// Custom invalidation
    override public func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        
        guard let invalidationContext = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext,
            let oldBounds = collectionView?.bounds
            else { return super.invalidationContext(forBoundsChange: newBounds) }
        
        // Size changes?
        if oldBounds.size != newBounds.size {
            
            // re-query the collection view delegate for metrics such as size information etc.
            invalidationContext.invalidateFlowLayoutDelegateMetrics = true
        }
        
        return invalidationContext
    }
    
    // MARK: - Empty cache
    
    /**
     Epties the cache of the collectionView attributes
     */
    func emptyCache() {
        
        self.cache.removeAll()
        contentHeight = 0
    }
    
    // MARK: - Add attributes to the cache
    
    /**
     Adds the passed attributes to the cache
     
     - parameter attributes: The attributes to add to the cache
     */
    func addUICollectionViewLayoutAttributes(attributes: UICollectionViewLayoutAttributes) {
        
        self.cache.append(attributes)
    }
}
