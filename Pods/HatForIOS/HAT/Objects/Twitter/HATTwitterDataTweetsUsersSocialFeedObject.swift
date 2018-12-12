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

/// A class representing the user's info of a tweet
public struct HATTwitterDataTweetsUsersSocialFeedObject: HatApiType, Comparable {
    
    // MARK: - Fields
    
    /// The possible Fields of the JSON struct
    public struct Fields {
        
        static let friendsCount: String = "friends_count"
        static let userID: String = "id"
        static let language: String = "lang"
        static let favoritesCount: String = "favorites_count"
        static let statusesCount: String = "statuses_count"
        static let listedCount: String = "listed_count"
        static let screenName: String = "screen_name"
        static let name: String = "name"
        static let url: String = "url"
        static let followersCount: String = "followers_count"
        static let location: String = "location"
        static let verified: String = "verified"
        static let following: String = "following"
        static let protected: String = "protected"
        static let timeZone: String = "time_zone"
        static let createdAt: String = "created_at"
        static let utcOffset: String = "utc_offset"
        static let description: String = "description"
        static let geoEnabled: String = "geo_enabled"
        static let isTranslator: String = "is_translator"
        static let notifications: String = "notifications"
        static let defaultProfile: String = "default_profile"
        static let translatorType: String = "translator_type"
        static let profileImageUrl: String = "profile_image_url"
        static let profileLinkColor: String = "profile_link_color"
        static let profileTextColor: String = "profile_text_color"
        static let followRequestSent: String = "follow_request_sent"
        static let contributorsEnabled: String = "contributors_enabled"
        static let hasExtendedProfile: String = "has_extended_profile"
        static let defaultProfileImage: String = "default_profile_image"
        static let isTranslationEnabled: String = "is_translation_enabled"
        static let profileBackgroundTile: String = "profile_background_tile"
        static let profileImageUrlHttps: String = "profile_image_url_https"
        static let profileBackgroundColor: String = "profile_background_color"
        static let profileSidebarFillColor: String = "profile_sidebar_fill_color"
        static let profileBackgroundImageUrl: String = "profile_background_image_url"
        static let profileSidebarBorderColor: String = "profile_sidebar_border_color"
        static let profileUseBackgroundImage: String = "profile_use_background_image"
        static let profileBackgroundImageUrlHttps: String = "profile_background_image_url_https"
    }
    
    // MARK: - Comparable protocol
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATTwitterDataTweetsUsersSocialFeedObject, rhs: HATTwitterDataTweetsUsersSocialFeedObject) -> Bool {
        
        return (lhs.friendsCount == rhs.friendsCount && lhs.userID == rhs.userID && lhs.lang == rhs.lang && lhs.listedCount == rhs.listedCount && lhs.favouritesCount == rhs.favouritesCount && lhs.statusesCount == rhs.statusesCount && lhs.screenName == rhs.screenName && lhs.name == rhs.name && lhs.followersCount == rhs.followersCount)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (lhs: HATTwitterDataTweetsUsersSocialFeedObject, rhs: HATTwitterDataTweetsUsersSocialFeedObject) -> Bool {
        
        return lhs.name < rhs.name
    }
    
    // MARK: - Variables
    
    /// The user's friend count
    public var friendsCount: Int = 0
    /// The user's id
    public var userID: Int = 0
    /// The user's language
    public var lang: String = ""
    /// The user's listed count
    public var listedCount: Int = 0
    /// The user's favourites count
    public var favouritesCount: Int = 0
    /// The user's statuses count
    public var statusesCount: Int = 0
    /// The user's screen name
    public var screenName: String = ""
    /// The user's name
    public var name: String = ""
    /// The user's followers count
    public var followersCount: String = ""
    public var url: String = ""
    public var location: String = ""
    public var verified: Bool = false
    public var following: Bool = false
    public var protected: Bool = false
    public var timeZone: String?
    public var createdAt: String = ""
    public var utcOffset: String?
    public var description: String = ""
    public var geoEnabled: Bool = false
    public var isTranslator: Bool = false
    public var notifications: Bool = false
    public var defaultProfile: Bool = false
    public var translatorType: String = ""
    public var profileImageUrl: String = ""
    public var profileLinkColor: String = ""
    public var profileTextColor: String = ""
    public var followRequestSent: Bool = false
    public var contributorsEnabled: Bool = false
    public var hasExtendedProfile: Bool = false
    public var defaultProfileImage: Bool = false
    public var isTranslationEnabled: Bool = false
    public var profileBackgroundTile: Bool = false
    public var profileImageUrlHttps: String = ""
    public var profileBackgroundColor: String = ""
    public var profileSidebarFillColor: String = ""
    public var profileBackgroundImageUrl: String = ""
    public var profileSidebarBorderColor: String = ""
    public var profileUseBackgroundImage: Bool = false
    public var profileBackgroundImageUrlHttps: String = ""
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        friendsCount = 0
        userID = 0
        lang = ""
        listedCount = 0
        favouritesCount = 0
        statusesCount = 0
        screenName = ""
        name = ""
        followersCount = ""
        url = ""
        location = ""
        verified = false
        following = false
        protected = false
        timeZone = nil
        createdAt = ""
        utcOffset = nil
        description = ""
        geoEnabled = false
        isTranslator = false
        notifications = false
        defaultProfile = false
        translatorType = ""
        profileImageUrl = ""
        profileLinkColor = ""
        profileTextColor = ""
        followRequestSent = false
        contributorsEnabled = false
        hasExtendedProfile = false
        defaultProfileImage = false
        isTranslationEnabled = false
        profileBackgroundTile = false
        profileImageUrlHttps = ""
        profileBackgroundColor = ""
        profileSidebarFillColor = ""
        profileBackgroundImageUrl = ""
        profileSidebarBorderColor = ""
        profileUseBackgroundImage = false
        profileBackgroundImageUrlHttps = ""
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dictionary: The JSON file received from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {
        
        self.init()
        
        if let tempFriendsCount: Int = dictionary[Fields.friendsCount]?.intValue {
            
            friendsCount = tempFriendsCount
        }
        if let tempID: Int = dictionary[Fields.userID]?.intValue {
            
            userID = tempID
        }
        if let tempLang: String = dictionary[Fields.language]?.stringValue {
            
            lang = tempLang
        }
        if let tempListedCount: Int = dictionary[Fields.listedCount]?.intValue {
            
            listedCount = tempListedCount
        }
        if let tempFavouritesCount: Int = dictionary[Fields.favoritesCount]?.intValue {
            
            favouritesCount = tempFavouritesCount
        }
        if let tempStatusesCount: Int = dictionary[Fields.statusesCount]?.intValue {
            
            statusesCount = tempStatusesCount
        }
        if let tempScreenName: String = dictionary[Fields.screenName]?.stringValue {
            
            screenName = tempScreenName
        }
        if let tempName: String = dictionary[Fields.name]?.stringValue {
            
            name = tempName
        }
        if let tempFollowersCount: String = dictionary[Fields.followersCount]?.stringValue {
            
            followersCount = tempFollowersCount
        }
        if let tempURL: String = dictionary[Fields.url]?.stringValue {
            
            url = tempURL
        }
        if let tempLocation: String = dictionary[Fields.location]?.stringValue {
            
            location = tempLocation
        }
        if let tempVerified: Bool = dictionary[Fields.verified]?.boolValue {
            
            verified = tempVerified
        }
        if let tempFollowing: Bool = dictionary[Fields.following]?.boolValue {
            
            following = tempFollowing
        }
        if let tempProtected: Bool = dictionary[Fields.protected]?.boolValue {
            
            protected = tempProtected
        }
        if let tempTimeZone: String = dictionary[Fields.timeZone]?.stringValue {
            
            timeZone = tempTimeZone
        }
        if let tempCreatedAt: String = dictionary[Fields.createdAt]?.stringValue {
            
            createdAt = tempCreatedAt
        }
        if let tempUtcOffset: String = dictionary[Fields.utcOffset]?.stringValue {
            
            utcOffset = tempUtcOffset
        }
        if let tempDescription: String = dictionary[Fields.description]?.stringValue {
            
            description = tempDescription
        }
        if let tempGeoEnabled: Bool = dictionary[Fields.geoEnabled]?.boolValue {
            
            geoEnabled = tempGeoEnabled
        }
        if let tempIsTranslator: Bool = dictionary[Fields.isTranslator]?.boolValue {
            
            isTranslator = tempIsTranslator
        }
        if let tempNotifications: Bool = dictionary[Fields.notifications]?.boolValue {
            
            notifications = tempNotifications
        }
        if let tempDefaultProfile: Bool = dictionary[Fields.defaultProfile]?.boolValue {
            
            defaultProfile = tempDefaultProfile
        }
        if let tempTranslatorType: String = dictionary[Fields.translatorType]?.stringValue {
            
            translatorType = tempTranslatorType
        }
        if let tempProfileImageUrl: String = dictionary[Fields.profileImageUrl]?.stringValue {
            
            profileImageUrl = tempProfileImageUrl
        }
        if let tempProfileLinkColor: String = dictionary[Fields.profileLinkColor]?.stringValue {
            
            profileLinkColor = tempProfileLinkColor
        }
        if let tempProfileTextColor: String = dictionary[Fields.profileTextColor]?.stringValue {
            
            profileTextColor = tempProfileTextColor
        }
        if let tempFollowRequestSent: Bool = dictionary[Fields.followRequestSent]?.boolValue {
            
            followRequestSent = tempFollowRequestSent
        }
        if let tempContributorsEnabled: Bool = dictionary[Fields.contributorsEnabled]?.boolValue {
            
            contributorsEnabled = tempContributorsEnabled
        }
        if let tempHasExtendedProfile: Bool = dictionary[Fields.hasExtendedProfile]?.boolValue {
            
            hasExtendedProfile = tempHasExtendedProfile
        }
        if let tempDefaultProfileImage: Bool = dictionary[Fields.defaultProfileImage]?.boolValue {
            
            defaultProfileImage = tempDefaultProfileImage
        }
        if let tempIsTranslationEnabled: Bool = dictionary[Fields.isTranslationEnabled]?.boolValue {
            
            isTranslationEnabled = tempIsTranslationEnabled
        }
        if let tempProfileBackgroundTile: Bool = dictionary[Fields.profileBackgroundTile]?.boolValue {
            
            profileBackgroundTile = tempProfileBackgroundTile
        }
        if let tempProfileImageUrlHttps: String = dictionary[Fields.profileImageUrlHttps]?.stringValue {
            
            profileImageUrlHttps = tempProfileImageUrlHttps
        }
        if let tempProfileBackgroundColor: String = dictionary[Fields.profileBackgroundColor]?.stringValue {
            
            profileBackgroundColor = tempProfileBackgroundColor
        }
        if let temppPofileSidebarFillColor: String = dictionary[Fields.profileSidebarFillColor]?.stringValue {
            
            profileSidebarFillColor = temppPofileSidebarFillColor
        }
        if let tempProfileBackgroundImageUrl: String = dictionary[Fields.profileBackgroundImageUrl]?.stringValue {
            
            profileBackgroundImageUrl = tempProfileBackgroundImageUrl
        }
        if let tempProfileSidebarBorderColor: String = dictionary[Fields.profileSidebarBorderColor]?.stringValue {
            
            profileSidebarBorderColor = tempProfileSidebarBorderColor
        }
        if let temppPofileUseBackgroundImage: Bool = dictionary[Fields.profileUseBackgroundImage]?.boolValue {
            
            profileUseBackgroundImage = temppPofileUseBackgroundImage
        }
        if let tempProfileBackgroundImageUrlHttps: String = dictionary[Fields.profileBackgroundImageUrlHttps]?.stringValue {
            
            profileBackgroundImageUrlHttps = tempProfileBackgroundImageUrlHttps
        }
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     
     - dict: The JSON file received from the HAT
     */
    public mutating func inititialize(dict: Dictionary<String, JSON>) {
        
        if let tempFriendsCount: Int = dict[Fields.friendsCount]?.intValue {
            
            friendsCount = tempFriendsCount
        }
        if let tempID: Int = dict[Fields.userID]?.intValue {
            
            userID = tempID
        }
        if let tempLang: String = dict[Fields.language]?.stringValue {
            
            lang = tempLang
        }
        if let tempListedCount: Int = dict[Fields.listedCount]?.intValue {
            
            listedCount = tempListedCount
        }
        if let tempFavouritesCount: Int = dict[Fields.favoritesCount]?.intValue {
            
            favouritesCount = tempFavouritesCount
        }
        if let tempStatusesCount: Int = dict[Fields.statusesCount]?.intValue {
            
            statusesCount = tempStatusesCount
        }
        if let tempScreenName: String = dict[Fields.screenName]?.stringValue {
            
            screenName = tempScreenName
        }
        if let tempName: String = dict[Fields.name]?.stringValue {
            
            name = tempName
        }
        if let tempFollowersCount: String = dict[Fields.followersCount]?.stringValue {
            
            followersCount = tempFollowersCount
        }
        if let tempURL: String = dict[Fields.url]?.stringValue {
            
            url = tempURL
        }
        if let tempLocation: String = dict[Fields.location]?.stringValue {
            
            location = tempLocation
        }
        if let tempVerified: Bool = dict[Fields.verified]?.boolValue {
            
            verified = tempVerified
        }
        if let tempFollowing: Bool = dict[Fields.following]?.boolValue {
            
            following = tempFollowing
        }
        if let tempProtected: Bool = dict[Fields.protected]?.boolValue {
            
            protected = tempProtected
        }
        if let tempTimeZone: String = dict[Fields.timeZone]?.stringValue {
            
            timeZone = tempTimeZone
        }
        if let tempCreatedAt: String = dict[Fields.createdAt]?.stringValue {
            
            createdAt = tempCreatedAt
        }
        if let tempUtcOffset: String = dict[Fields.utcOffset]?.stringValue {
            
            utcOffset = tempUtcOffset
        }
        if let tempDescription: String = dict[Fields.description]?.stringValue {
            
            description = tempDescription
        }
        if let tempGeoEnabled: Bool = dict[Fields.geoEnabled]?.boolValue {
            
            geoEnabled = tempGeoEnabled
        }
        if let tempIsTranslator: Bool = dict[Fields.isTranslator]?.boolValue {
            
            isTranslator = tempIsTranslator
        }
        if let tempNotifications: Bool = dict[Fields.notifications]?.boolValue {
            
            notifications = tempNotifications
        }
        if let tempDefaultProfile: Bool = dict[Fields.defaultProfile]?.boolValue {
            
            defaultProfile = tempDefaultProfile
        }
        if let tempTranslatorType: String = dict[Fields.translatorType]?.stringValue {
            
            translatorType = tempTranslatorType
        }
        if let tempProfileImageUrl: String = dict[Fields.profileImageUrl]?.stringValue {
            
            profileImageUrl = tempProfileImageUrl
        }
        if let tempProfileLinkColor: String = dict[Fields.profileLinkColor]?.stringValue {
            
            profileLinkColor = tempProfileLinkColor
        }
        if let tempProfileTextColor: String = dict[Fields.profileTextColor]?.stringValue {
            
            profileTextColor = tempProfileTextColor
        }
        if let tempFollowRequestSent: Bool = dict[Fields.followRequestSent]?.boolValue {
            
            followRequestSent = tempFollowRequestSent
        }
        if let tempContributorsEnabled: Bool = dict[Fields.contributorsEnabled]?.boolValue {
            
            contributorsEnabled = tempContributorsEnabled
        }
        if let tempHasExtendedProfile: Bool = dict[Fields.hasExtendedProfile]?.boolValue {
            
            hasExtendedProfile = tempHasExtendedProfile
        }
        if let tempDefaultProfileImage: Bool = dict[Fields.defaultProfileImage]?.boolValue {
            
            defaultProfileImage = tempDefaultProfileImage
        }
        if let tempIsTranslationEnabled: Bool = dict[Fields.isTranslationEnabled]?.boolValue {
            
            isTranslationEnabled = tempIsTranslationEnabled
        }
        if let tempProfileBackgroundTile: Bool = dict[Fields.profileBackgroundTile]?.boolValue {
            
            profileBackgroundTile = tempProfileBackgroundTile
        }
        if let tempProfileImageUrlHttps: String = dict[Fields.profileImageUrlHttps]?.stringValue {
            
            profileImageUrlHttps = tempProfileImageUrlHttps
        }
        if let tempProfileBackgroundColor: String = dict[Fields.profileBackgroundColor]?.stringValue {
            
            profileBackgroundColor = tempProfileBackgroundColor
        }
        if let temppPofileSidebarFillColor: String = dict[Fields.profileSidebarFillColor]?.stringValue {
            
            profileSidebarFillColor = temppPofileSidebarFillColor
        }
        if let tempProfileBackgroundImageUrl: String = dict[Fields.profileBackgroundImageUrl]?.stringValue {
            
            profileBackgroundImageUrl = tempProfileBackgroundImageUrl
        }
        if let tempProfileSidebarBorderColor: String = dict[Fields.profileSidebarBorderColor]?.stringValue {
            
            profileSidebarBorderColor = tempProfileSidebarBorderColor
        }
        if let temppPofileUseBackgroundImage: Bool = dict[Fields.profileUseBackgroundImage]?.boolValue {
            
            profileUseBackgroundImage = temppPofileUseBackgroundImage
        }
        if let tempProfileBackgroundImageUrlHttps: String = dict[Fields.profileBackgroundImageUrlHttps]?.stringValue {
            
            profileBackgroundImageUrlHttps = tempProfileBackgroundImageUrlHttps
        }
    }
    
    public mutating func initialize(fromCache: Dictionary<String, Any>) {
        
        let dictionary: JSON = JSON(fromCache)
        self.inititialize(dict: dictionary.dictionaryValue)
    }
    
    // MARK: - JSON Mapper
    
    /**
     Returns the object as Dictionary, JSON
     
     - returns: Dictionary<String, String>
     */
    public func toJSON() -> Dictionary<String, Any> {
        
        return [
            
            Fields.friendsCount: self.friendsCount,
            Fields.userID: self.userID,
            Fields.language: self.lang,
            Fields.favoritesCount: self.favouritesCount,
            Fields.statusesCount: self.statusesCount,
            Fields.listedCount: self.listedCount,
            Fields.screenName: self.screenName,
            Fields.name: self.name,
            Fields.followersCount: self.followersCount,
            Fields.location: self.location,
            Fields.verified: self.verified,
            Fields.following: self.following,
            Fields.protected: self.protected,
            Fields.timeZone: self.timeZone ?? "",
            Fields.createdAt: self.createdAt,
            Fields.utcOffset: self.utcOffset ?? "",
            Fields.description: self.description,
            Fields.geoEnabled: self.geoEnabled,
            Fields.isTranslator: self.isTranslator,
            Fields.notifications: self.notifications,
            Fields.defaultProfile: self.defaultProfile,
            Fields.translatorType: self.translatorType,
            Fields.profileImageUrl: self.profileImageUrl,
            Fields.profileLinkColor: self.profileLinkColor,
            Fields.profileTextColor: self.profileTextColor,
            Fields.followRequestSent: self.followRequestSent,
            Fields.contributorsEnabled: self.contributorsEnabled,
            Fields.hasExtendedProfile: self.hasExtendedProfile,
            Fields.defaultProfileImage: self.defaultProfileImage,
            Fields.isTranslationEnabled: self.isTranslationEnabled,
            Fields.profileBackgroundTile: self.profileBackgroundTile,
            Fields.profileImageUrlHttps: self.profileImageUrlHttps,
            Fields.profileBackgroundColor: self.profileBackgroundColor,
            Fields.profileSidebarFillColor: self.profileSidebarFillColor,
            Fields.profileBackgroundImageUrl: self.profileBackgroundImageUrl,
            Fields.profileSidebarBorderColor: self.profileSidebarBorderColor,
            Fields.profileUseBackgroundImage: self.profileUseBackgroundImage,
            Fields.profileBackgroundImageUrlHttps: self.profileBackgroundImageUrlHttps
        ]
    }
}
