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

class SheFeedLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    
    weak var delegate: CustomFeedLayoutDelegate!
    
    fileprivate var numberOfColumns = 1
    fileprivate var cellPadding: CGFloat = 20
    
    // This is an array to cache the calculated attributes. When you call prepare(), you’ll calculate the attributes for all items and add them to the cache. When the collection view later requests the layout attributes, you can be efficient and query the cache instead of recalculating them every time.
    var cache = [[UICollectionViewLayoutAttributes]]()
    private var frames: [[CGRect]] = []
    
    // This declares two properties to store the content size. contentHeight is incremented as photos are added, and contentWidth is calculated based on the collection view width and its content inset.
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        
        guard let collectionView = collectionView else {
            
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // 5
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: - Prepare
    
    // Note: As prepare() is called whenever the collection view's layout is invalidated, there are many situations in a typical implementation where you might need to recalculate attributes here. For example, the bounds of the UICollectionView might change - such as when the orientation changes - or items may be added or removed from the collection. These cases are out of scope for this tutorial, but it's important to be aware of them in a non-trivial implementation.
    override func prepare() {
        
        self.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 30)

        // 1
        guard let collectionView = collectionView else { return }
        guard collectionView.numberOfSections > 0 else { return }
        
        // 2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        // 3
        for section in 0 ..< (collectionView.numberOfSections) {
            
            for row in 0 ..< (collectionView.numberOfItems(inSection: section) + 1) {
                
                if row == 0 {
                    
                    let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: row, section: section))
                    headerAttributes.frame = CGRect(x: xOffset[column], y: yOffset[column], width: UIScreen.main.bounds.width, height: 30)
                    if cache.count > section {
                        
                        cache[section].insert(headerAttributes, at: row)
                        frames[section].insert(headerAttributes.frame, at: row)
                    } else {
                        
                        cache.insert([headerAttributes], at: section)
                        frames.insert([headerAttributes.frame], at: section)
                    }
                    
                    contentHeight = max(contentHeight, headerAttributes.frame.maxY)
                    yOffset[column] = yOffset[column] + headerAttributes.frame.height
                    
                    column = column < (numberOfColumns - 1) ? (column + 1) : 0
                } else {
                    
                    let indexPath = IndexPath(item: row - 1, section: section)
                    
                    // 4 This is where you perform the frame calculation. width is the previously calculated cellWidth, with the padding between cells removed. You ask the delegate for the height of the photo and calculate the frame height based on this height and the predefined cellPadding for the top and bottom. You then combine this with the x and y offsets of the current column to create the insetFrame used by the attribute.
                    let photoHeight = delegate.collectionView(collectionView, heightForSheFeedItemAtIndexPath: indexPath)
                    let height = cellPadding * 2 + photoHeight
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                    let insetFrame = frame.insetBy(dx: cellPadding / 2, dy: 0)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    if cache.count > section {
                        
                        cache[section].insert(attributes, at: row)
                        frames[section].insert(attributes.frame, at: row)
                    } else {
                        
                        cache.insert([attributes], at: section)
                        frames.insert([attributes.frame], at: section)
                    }
                    
                    // 6
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffset[column] = yOffset[column] + height
                    
                    column = column < (numberOfColumns - 1) ? (column + 1) : 0
                }
            }
        }
        
        contentHeight += CGFloat(collectionView.numberOfItems(inSection: 0) * 10)
    }
    
    // MARK: - Layout
    
    override func invalidateLayout() {

        super.invalidateLayout()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard !cache.isEmpty else { return nil }
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
                
        // Loop through the cache and look for items in the rect
        for section in cache.indices {
            
            for attributes in cache[section] where attributes.frame.intersects(rect) {
                
                if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                    
                    guard let tempAttributes = self.layoutAttributesForSupplementaryView(ofKind: attributes.representedElementKind ?? UICollectionView.elementKindSectionHeader, at: attributes.indexPath) else { continue }
                    
                    visibleLayoutAttributes.append(tempAttributes)
                } else {
                    
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }
    
    // Adjusts layout attributes of section headers
    private func adjustLayoutAttributes(forSectionAttributes sectionHeadersLayoutAttributes: UICollectionViewLayoutAttributes) -> (CGRect, Int) {
        
        guard let collectionView = collectionView else { return (CGRect.zero, 0) }
        
        let section = sectionHeadersLayoutAttributes.indexPath.section
        var sectionFrame = sectionHeadersLayoutAttributes.frame

        sectionFrame.origin.y = collectionView.contentOffset.y
        
        return (sectionFrame, zIndexForSection(section))
    }
    
    fileprivate func zIndexForSection(_ section: Int) -> Int {
        
        return section + 10
    }
    
    fileprivate func boundaryMetrics(forSectionAttributes sectionHeadersLayoutAttributes: UICollectionViewLayoutAttributes) -> (CGFloat, CGFloat) {
        
        // get attributes for first and last items in section
        guard let collectionView = collectionView,
            !self.cache.isEmpty else { return (0, 0) }
        let section = (sectionHeadersLayoutAttributes.indexPath as NSIndexPath).section
        
        // Trying to use layoutAttributesForItemAtIndexPath for empty section would
        // cause EXC_ARITHMETIC in simulator (division by zero items)
        let lastInSectionIdx = collectionView.numberOfItems(inSection: section) - 1
        if lastInSectionIdx < 0 { return (0, 0) }
        
        guard let attributesForFirstItemInSection = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
            let attributesForLastItemInSection = layoutAttributesForItem(at: IndexPath(item: lastInSectionIdx, section: section))
            else {return (0, 0)}
        
        let sectionFrame = sectionHeadersLayoutAttributes.frame
        
        // Section Boundaries:
        //   The section should not be higher than the top of its first cell
        let minY = attributesForFirstItemInSection.frame.minY - sectionFrame.height
        //   The section should not be lower than the bottom of its last cell
        let maxY = attributesForLastItemInSection.frame.maxY - sectionFrame.height
        return (minY, maxY)
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard !cache.isEmpty, !frames.isEmpty, self.cache.count > indexPath.section, self.cache[indexPath.section].count > indexPath.row, self.frames.count > indexPath.section, self.frames[indexPath.section].count > indexPath.row else { return nil }
        
        let attributes = self.cache[indexPath.section][indexPath.row]
        let frame = self.frames[indexPath.section][indexPath.row]

        var visibleSections: [Int] = self.collectionView!.indexPathsForVisibleItems.map({ $0.section })
        visibleSections.append(indexPath.section)
        var filtered: [Int] = Array(Set(visibleSections))

        filtered = filtered.sorted()
        
        let cell = self.collectionView!.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: indexPath.section))

        if filtered.first == indexPath.section {
            
            (attributes.frame, attributes.zIndex) = adjustLayoutAttributes(forSectionAttributes: attributes)
            
            cell?.backgroundColor = .hatGrayBackground
            cell?.addShadow(color: .lightGray, shadowRadius: 1, shadowOpacity: 0.5, width: 0, height: 1)
        } else {
            
            attributes.frame = frame
            attributes.zIndex = 0
            cell?.backgroundColor = .hatGrayBackground
            cell?.addShadow(color: nil, shadowRadius: 0, shadowOpacity: 0, width: 0, height: 0)
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard !cache.isEmpty else { return nil }
        
        return cache[indexPath.section][indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        // if you don't want to re-calculate everything on scroll
        //return !newBounds.size.equalTo(self.collectionView!.frame.size)
        return true
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
            
            // Origin changes?
            if oldBounds.origin != newBounds.origin {
                
                // find and invalidate the sections that would fall into the new bounds
                guard let sectionIdxPaths = sectionsHeadersIDxs(forRect: newBounds) else { return invalidationContext }
                
                // then invalidate
                let invalidatedIdxPaths = sectionIdxPaths.map { IndexPath(item: 0, section: $0) }
                invalidationContext.invalidateSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader, at: invalidatedIdxPaths )
            }
        
            return invalidationContext
    }
    
    // MARK: - Headers
    
    /**
     Given a rect, calculates indexes of all confined section headers
     
     - parameter rect: The rect to calculate the indexes of the confined sections
     
     - returns: A Set of Ints representing the indexes of the sections
     */
    private func sectionsHeadersIDxs(forRect rect: CGRect) -> Set<Int>? {
        
        guard !cache.isEmpty else { return nil }
        
        var headersIdxs = Set<Int>()
        
        for section in self.cache.indices {
            
            for attributes in self.cache[section] where attributes.frame.intersects(rect) {
                
                headersIdxs.insert(attributes.indexPath.section)
            }
        }
        
        return headersIdxs
    }
    
    // MARK: - Empty cache
    
    /**
     Empty the cache of the collectionView attributes
     */
    func emptyCache() {
        
        self.cache.removeAll()
        self.frames.removeAll()
        contentHeight = 0
    }
}
