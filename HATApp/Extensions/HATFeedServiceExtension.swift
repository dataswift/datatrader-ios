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

import HatForIOS

// MARK: Extension

extension HATFeedService {
    
    // MARK: - Construct Parameters
    
    /**
     Constructs the parameters of a request with since and until
     
     - parameter filterFromDate: The date to use in the upper limit of the filtering
     - parameter filterToDate: The date to use in the lower limit of the filtering
     - parameter lastFeedItemDateISO: The last feed
     
     - returns: A Key value pair of strings in the form of ["since": "432423532"]
     */
    static func constructParameters(filterFromDate: Date?, filterToDate: Date?, lastFeedItemDateISO: String?, noValuesFound: Bool = false) -> [String: String] {
        
        if noValuesFound && filterFromDate != nil {
                        
            return ["since" : String(describing: Int(filterFromDate!.timeIntervalSince1970))]
        } else {
            
            if  let fromDate: Date = filterFromDate,
                let toDate: Date = filterToDate {
                
                let startOfDay: Int = Date.startOfDateInUnixTimeStamp(date: fromDate)
                let endOfDay: Int? = Date.endOfDateInUnixTimeStamp(date: toDate)
                
                return ["since" : String(describing: startOfDay),
                        "until": String(describing: endOfDay!)]
            } else if lastFeedItemDateISO != nil {
                
                let date: Date = FormatterManager.formatStringToDate(string: lastFeedItemDateISO!)!
                var dateComponents: DateComponents = DateComponents()
                dateComponents.month = -1
                
                let pastDate: Date = Calendar.current.date(byAdding: dateComponents, to: date)!
                
                return ["since" : String(describing: Int(pastDate.timeIntervalSince1970)),
                        "until": String(describing: Int(date.timeIntervalSince1970) - 1)]
            }
            
            let dateNow: Date = Date()
            var dateComponents: DateComponents = DateComponents()
            dateComponents.month = -1
            
            let pastDate: Date = Calendar.current.date(byAdding: dateComponents, to: dateNow)!
            
            return ["since" : String(describing: Int(pastDate.timeIntervalSince1970))]
        }
    }
    
    // MARK: - Create and group sections
    
    /**
     Creates sections from the receivedArray and the items already in the collectionView. The section are by date.
     
     - parameter receivedArray: The array to create sections from
     - parameter feedItemsInCollectionView: The item in the collectionView, can be empty array
     
     - returns: The received array combined with the items already in the collectionView, in sections seperated by day
     */
    static func createSections(receivedArray: [HATFeedObject], feedItemsInCollectionView: inout [[HATFeedObject]]) -> [[HATFeedObject]] {
        
        var feedItemsInCollectionView: [[HATFeedObject]] = feedItemsInCollectionView
        var tempFeedArray: [[HATFeedObject]] = []
        
        var tempArray: [HATFeedObject] = []
        
        var flag: Bool = false
        
        for item: HATFeedObject in receivedArray {
            
            if !feedItemsInCollectionView.isEmpty && !flag {
                
                let lastSection: Int = feedItemsInCollectionView.count - 1
                let lastRow: Int = feedItemsInCollectionView[lastSection].count - 1
                
                let lastItem: HATFeedObject = feedItemsInCollectionView[lastSection][lastRow]
                
                let date1: Date = Date.startOfDate(date: FormatterManager.formatStringToDate(string: item.date.iso)!)
                let date2: Date = Date.startOfDate(date: FormatterManager.formatStringToDate(string: lastItem.date.iso)!)
                if date1 != date2 {
                    
                    tempArray.append(item)
                    
                    flag = true
                    continue
                } else {
                    
                    feedItemsInCollectionView[lastSection].append(item)
                }
            } else {
                
                if !tempArray.isEmpty {
                    
                    let date1: Date = Date.startOfDate(date: FormatterManager.formatStringToDate(string: item.date.iso)!)
                    let date2: Date = Date.startOfDate(date: FormatterManager.formatStringToDate(string: tempArray.last!.date.iso)!)
                    if date1 != date2 {
                        
                        tempFeedArray.append(tempArray)
                        tempArray.removeAll()
                    }
                }
                
                tempArray.append(item)
            }
        }
        
        if !tempArray.isEmpty {
            
            tempFeedArray.append(tempArray)
            tempArray.removeAll()
        }
        
        return tempFeedArray
    }
    
    /**
     Groups an array of HATFeedObjects already seperated to sections.
     
     - parameter fromItems: The items to group
     - parameter groupIfMoreThan: The number to start groupping from
     
     - returns: An array containing groupped sections of feed objects. You know when an item is groupped when you see in the source grouped \(source) \(number of items groupped)
     */
    static func createGrouppedSections(fromItems: [[HATFeedObject]], groupIfMoreThan: Int) -> [[HATFeedObject]] {
        
        guard !fromItems.isEmpty else { return fromItems }
        
        var tempFeedArray: [[HATFeedObject]] = []
        var lastItemSource: String = ""
        var sameSourceItemsCounter: Int = 0
        var indexWhenSourceDetected: Int = 0
        
        for section in fromItems.indices {
            
            var feedItemsToAdd: [HATFeedObject] = []

            for (index, item) in fromItems[section].enumerated() {
                
                if item.source == lastItemSource || lastItemSource == "" {
                    
                    sameSourceItemsCounter = sameSourceItemsCounter + 1
                    if lastItemSource == "" {
                        
                        lastItemSource = item.source
                    }
                } else {
                    
                    indexWhenSourceDetected = feedItemsToAdd.endIndex
                    lastItemSource = item.source
                    sameSourceItemsCounter = 1
                }

                if sameSourceItemsCounter > groupIfMoreThan && fromItems[section].count > index && (sameSourceItemsCounter - groupIfMoreThan - 1) > 0 {
                    
                    // group items
                    let index = indexWhenSourceDetected + groupIfMoreThan
                    if (feedItemsToAdd.count - 1) < index {
                        
                        feedItemsToAdd.append(item)
                    }
                    feedItemsToAdd[index].source = "grouped \(lastItemSource) \(String(describing: (sameSourceItemsCounter - groupIfMoreThan - 1)))"
                } else {
                    
                    feedItemsToAdd.append(item)
                }
            }
            
            tempFeedArray.append(feedItemsToAdd)
            sameSourceItemsCounter = 0
            indexWhenSourceDetected = 0
            lastItemSource = ""
        }
        
        return tempFeedArray
    }
}
