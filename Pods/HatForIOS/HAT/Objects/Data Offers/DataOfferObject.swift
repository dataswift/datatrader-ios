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

import SwiftyJSON

// MARK: Struct

public struct DataOfferObject {
    
    // MARK: - JSON Fields
    
    /// The JSON fields used by the hat
    public struct Fields {
        
        static let dataOfferID: String = "id"
        static let createdDate: String = "created"
        static let offerTitle: String = "title"
        static let shortDescription: String = "shortDescription"
        static let longDescription: String = "longDescription"
        static let imageURL: String = "illustrationUrl"
        static let offerStarts: String = "starts"
        static let offerExpires: String = "expires"
        static let collectsDataFor: String = "collectFor"
        static let minimumUsers: String = "requiredMinUser"
        static let maximumUsers: String = "requiredMaxUser"
        static let usersClaimedOffer: String = "totalUserClaims"
        static let requiredDataDefinitions: String = "requiredDataDefinition"
        static let dataConditions: String = "dataConditions"
        static let dataRequirements: String = "dataRequirements"
        static let reward: String = "reward"
        static let owner: String = "owner"
        static let claim: String = "claim"
        static let pii: String = "pii"
        static let merchantCode: String = "merchantCode"
    }
    
    // MARK: - Variables
    
    /// The data offer ID
    public var dataOfferID: String = ""
    /// The title of the offer
    public var title: String = ""
    /// The short description of the offer
    public var shortDescription: String = ""
    /// The long description of the offer
    public var longDescription: String = ""
    /// The image URL of the offer
    public var illustrationURL: String = ""
    /// The merchant code of the offer
    public var merchantCode: String = ""
    
    /// the date created as unix time stamp
    public var created: String = ""
    /// the start date of the offer as unix time stamp
    public var offerStarts: String = ""
    /// the expire date of the offer as unix time stamp
    public var offerExpires: String = ""
    /// the duration that the offer collects data for as unix time stamp
    public var collectsDataFor: Int = -1
    /// the minimum users required for the offer to activate
    public var requiredMinUsers: Int = -1
    /// the max users of the offer
    public var requiredMaxUsers: Int = -1
    /// the number of the offer claimed the offer so far
    public var usersClaimedOffer: Int = -1
    
    /// the data definition object of the offer
    public var requiredDataDefinition: DataOfferRequiredDataDefinitionObjectV2?
    
    /// the data conditions object of the offer
    public var dataConditions: DataOfferRequiredDataDefinitionObjectV2?
    
    /// the data requirements object of the offer
    public var dataRequirements: DataOfferRequiredDataDefinitionObjectV2?
    
    /// the rewards of the offer
    public var reward: DataOfferRewardsObject = DataOfferRewardsObject()
    
    /// The owner of the offer
    public var owner: DataOfferOwnerObject = DataOfferOwnerObject()
    
    /// The claim object of the offer
    public var claim: DataOfferClaimObject = DataOfferClaimObject()
    
    /// The downloaded image of the offer
    public var image: UIImage?
    
    /// Is the offer requiring pii
    public var isPΙIRequested: Bool = false
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        dataOfferID  = ""
        title = ""
        shortDescription = ""
        longDescription = ""
        illustrationURL = ""
        merchantCode = ""
        
        created = ""
        offerStarts = ""
        offerExpires = ""
        collectsDataFor = -1
        requiredMinUsers = -1
        requiredMaxUsers = -1
        usersClaimedOffer = -1
        
        requiredDataDefinition = nil
        dataConditions = nil
        dataRequirements = nil
        
        reward = DataOfferRewardsObject()
        
        owner = DataOfferOwnerObject()
        
        claim = DataOfferClaimObject()
        
        image = nil
        
        isPΙIRequested = false
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dictionary: The JSON file received
     */
    public init(dictionary: Dictionary<String, JSON>) {
        
        if let tempID: String = dictionary[DataOfferObject.Fields.dataOfferID]?.string {
            
            dataOfferID = tempID
        }
        
        if let tempCreated: String = dictionary[DataOfferObject.Fields.createdDate]?.string {
            
            created = tempCreated
        }
        
        if let tempTitle: String = dictionary[DataOfferObject.Fields.offerTitle]?.string {
            
            title = tempTitle
        }
        
        if let tempShortDescription: String = dictionary[DataOfferObject.Fields.shortDescription]?.string {
            
            shortDescription = tempShortDescription
        }
        
        if let tempLongDescription: String = dictionary[DataOfferObject.Fields.longDescription]?.string {
            
            longDescription = tempLongDescription
        }
        
        if let tempIllustrationUrl: String = dictionary[DataOfferObject.Fields.imageURL]?.string {
            
            illustrationURL = tempIllustrationUrl
        }
        
        if let tempMerchantCode: String = dictionary[DataOfferObject.Fields.merchantCode]?.string {
            
            merchantCode = tempMerchantCode
        }
        
        if let tempOfferStarts: String = dictionary[DataOfferObject.Fields.offerStarts]?.string {
            
            offerStarts = tempOfferStarts
        }
        
        if let tempOfferExpires: String = dictionary[DataOfferObject.Fields.offerExpires]?.string {
            
            offerExpires = tempOfferExpires
        }
        
        if let tempCollectOfferFor: Int = dictionary[DataOfferObject.Fields.collectsDataFor]?.int {
            
            collectsDataFor = tempCollectOfferFor
        }
        
        if let tempRequiresMinUsers: Int = dictionary[DataOfferObject.Fields.minimumUsers]?.int {
            
            requiredMinUsers = tempRequiresMinUsers
        }
        
        if let tempRequiresMaxUsers: Int = dictionary[DataOfferObject.Fields.maximumUsers]?.int {
            
            requiredMaxUsers = tempRequiresMaxUsers
        }
        
        if let tempUserClaims: Int = dictionary[DataOfferObject.Fields.usersClaimedOffer]?.int {
            
            usersClaimedOffer = tempUserClaims
        }
        
        if let tempPII: Bool = dictionary[DataOfferObject.Fields.pii]?.bool {
            
            isPΙIRequested = tempPII
        }
        
        if let tempRequiredDataDefinition: JSON = dictionary[DataOfferObject.Fields.requiredDataDefinitions] {
            
            let decoder: JSONDecoder = JSONDecoder()
            do {
                
                let data: Data = try tempRequiredDataDefinition.rawData()
                requiredDataDefinition = try decoder.decode(DataOfferRequiredDataDefinitionObjectV2.self, from: data)
            } catch {
                
                print(error)
            }
        }
        
        if let tempDataConditions: JSON = dictionary[DataOfferObject.Fields.dataConditions] {
            
            let decoder: JSONDecoder = JSONDecoder()
            do {
                
                let data: Data = try tempDataConditions.rawData()
                dataConditions = try decoder.decode(DataOfferRequiredDataDefinitionObjectV2.self, from: data)
            } catch {
                
                print(error)
            }
        }
        
        if let tempDataRequirements: JSON = dictionary[DataOfferObject.Fields.dataRequirements] {
            
            let decoder: JSONDecoder = JSONDecoder()
            do {
                
                let data: Data = try tempDataRequirements.rawData()
                dataRequirements = try decoder.decode(DataOfferRequiredDataDefinitionObjectV2.self, from: data)
            } catch {
                
                print(error)
            }
        }
        
        if let tempReward: [String: JSON] = dictionary[DataOfferObject.Fields.reward]?.dictionary {
            
            reward = DataOfferRewardsObject(dictionary: tempReward)
        }
        
        if let tempOwner: [String: JSON] = dictionary[DataOfferObject.Fields.owner]?.dictionary {
            
            owner = DataOfferOwnerObject(dictionary: tempOwner)
        }
        
        if let tempClaim: [String: JSON] = dictionary[DataOfferObject.Fields.claim]?.dictionary {
            
            claim = DataOfferClaimObject(dictionary: tempClaim)
        }
    }
    
}
