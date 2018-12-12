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

import Alamofire
import HatForIOS
import SwiftyJSON

// MARK: Extension

extension HATProfileService {
    
    // MARK: - Get profile Image
    
    /**
     Downloads the profile image in the imageView passed in as parameter
     
     - parameter userDomain: The user's hat domain
     - parameter userToken: The user's token
     - parameter imageView: The imageview to download the image to
     */
    static func getProfileImage(userDomain: String, userToken: String, imageView: UIImageView) {
        
        func gotImage(file: FileUploadObject) {
            
            guard let url: URL = URL(string: file.contentURL) else {
                
                return
            }
            
            imageView.downloadedFrom(url: url, userToken: userToken, progressUpdater: nil, completion: nil)
        }
        
        func fetchingImageFailed(error: HATTableError) {
            
            imageView.image = UIImage(named: ImageNamesConstants.profilePlaceholder)
        }
        
        HATProfileService.getProfileImageFromHAT(
            userDomain: userDomain,
            userToken: userToken,
            successCallback: gotImage,
            failCallback: fetchingImageFailed)
    }
    
    // MARK: - Set HAT name
    
    /**
     Splits the hat domain in two parts, name and cluster
     
     - parameter userDomain: The user's hat domain
     - parameter hatNameLabel: The label representing the name part of the hat domain, up to the first dot
     - parameter clusterNameLabel: The label representing the cluster part of the hat domain
     */
    static func setHATName(userDomain: String, hatNameLabel: UILabel, clusterNameLabel: UILabel) {
        
        let array: [Substring] = userDomain.split(separator: ".")
        guard let name: Substring = array.first else {
            
            return
        }
        
        let hatName: String = String(describing: name)
        hatNameLabel.text = hatName
        let cluster: [String] = userDomain.components(separatedBy: hatName)
        guard let unwrappedCluster: String = cluster.last else {
            
            return
        }
        let clusterName: String = String(describing: unwrappedCluster)
        clusterNameLabel.text = clusterName
    }
    
    // MARK: - PHATA structure Bundle
    
    /**
     Gets the phata structure from the HAT
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's token
     - parameter parameters: Parameters to pass on to the network request
     - parameter success: A function to execute on success passing the JSON response from the server
     - parameter fail: A function to execute on failure passing the error that occured
     */
    public static func getPhataStructureBundle(userDomain: String, userToken: String, parameters: Dictionary<String, Any> = [:], success: @escaping (Dictionary<String, JSON>) -> Void, fail: @escaping (HATTableError) -> Void) {
        
        if let url: URLConvertible = URL(string: "https://\(userDomain)/api/v2.6/data-bundle/phata/structure") {
            
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let manager: SessionManager = Alamofire.SessionManager(configuration: configuration)
            
            manager.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: Alamofire.JSONEncoding.default,
                headers: ["x-auth-token": userToken]).responseJSON(completionHandler: { response in
                    
                    switch response.result {
                    case .success:
                        
                        if response.response?.statusCode == 404 {
                            
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                let message = json["message"].stringValue
                                
                                if message != "Bundle Not Found" {
                                    
                                    fail(HATTableError.generalError("json creation failed", nil, nil))
                                }
                            }
                        } else if response.response?.statusCode == 200 {
                            
                            if let value = response.result.value {
                                
                                let json = JSON(value)
                                let dict = json["bundle"]["profile"]["endpoints"][0]["mapping"].dictionary
                                success(dict ?? [:])
                            }
                        }
                    case .failure(let error):
                        
                        fail(HATTableError.generalError("", nil, error))
                    }
                }
            ).session.finishTasksAndInvalidate()
        }
    }
    
    /// the notables default structure
    static let notablesStructure = [
        "notables":
            [
                "endpoints": [
                    [
                        "filters": [
                            [
                                "field": "shared",
                                "operator":
                                    [
                                        "value": true,
                                        "operator": "contains"
                                ]
                            ],
                            [
                                "field": "shared_on",
                                "operator":
                                    [
                                        "value": "phata",
                                        "operator": "contains"
                                ]
                            ]],
                        "mapping":
                            [
                                "kind": "kind",
                                "shared": "shared",
                                "currently_shared": "currently_shared",
                                "message": "message",
                                "author": "authorv1",
                                "location": "locationv1",
                                "shared_on": "shared_on",
                                "created_time": "created_time",
                                "public_until": "public_until",
                                "updated_time": "updated_time"
                        ],
                        "endpoint": "rumpel/notablesv1"
                    ]],
                "orderBy": "updated_time",
                "ordering": "descending"
        ]
    ]
    
    /// The mapping used to map items in profile view controller with the data on hat
    static let profileMapping = [
        "(0, 0)": "photo.avatar",
        "(1, 1)": "personal.firstName",
        "(1, 2)": "personal.lastName",
        "(1, 3)": "personal.gender",
        "(1, 4)": "personal.birthDate",
        "(1, 5)": "contact.primaryEmail",
        "(1, 6)": "contact.alternativeEmail",
        "(1, 7)": "contact.mobile",
        "(1, 8)": "contact.landline",
        "(2, 1)": "online.facebook",
        "(2, 2)": "online.twitter",
        "(2, 3)": "online.linkedin",
        "(2, 4)": "online.youtube",
        "(2, 5)": "online.website",
        "(2, 6)": "online.blog",
        "(2, 7)": "online.google",
        "(3, 1)": "about.title",
        "(3, 2)": "about.body"
    ]
    
    /**
     Maps profile structure
     
     - parameter returnedDictionary: The dictionary returned from hat
     
     - returns: A mapped dictionary
     */
    public static func mapProfileStructure(returnedDictionary: Dictionary<String, String>) -> Dictionary<String, String> {
        
        let filtered = HATProfileService.profileMapping.filter({ item1 in
            
            for item2 in returnedDictionary {
                
                if item1.value == item2.value {
                    
                    return true
                }
            }
            
            return false
        })
        
        return filtered
    }
    
    /**
     Updates the PHATA structure dictionary
     
     - parameter mutableDictionary: The existing PHATA structure dictionary
     
     - returns: An updated version of the PHATA structure dictionary
     */
    public static func constructDictionaryForBundle(mutableDictionary: NSMutableDictionary) -> Dictionary<String, Any>? {
        
        if let dict = mutableDictionary as? Dictionary<String, String> {
            
            let profileStructure = ["profile":
                [
                    "endpoints": [
                    [
                        "endpoint": "rumpel/profile",
                        "mapping": dict
                    ]
                ],
                "orderBy": "dateCreated",
                "ordering": "descending",
                "limit": 1
                ]
            ]
            
            let notablesStructure = HATProfileService.notablesStructure
            
            let temp = NSMutableDictionary()
            temp.addEntries(from: profileStructure)
            temp.addEntries(from: notablesStructure)
            
            if let dictionaryToReturn = temp as? Dictionary<String, Any> {
                
                return dictionaryToReturn
            }
        }
        
        return nil
    }
    
    /**
     Creates the PHATA structure in the HAT
     
     - parameter userDomain: User's domain
     - parameter userToken: User's token
     - parameter parameters: The parameters to send to HAT
     - parameter success: A completion handler returning true if the structure has been constructed
     - parameter fail: A completion handler to pass on any errors
     */
    public static func createPhataStructureBundle(userDomain: String, userToken: String, parameters: Dictionary<String, Any>? = nil, success: @escaping (Bool) -> Void, fail: @escaping (HATTableError) -> Void) {
        
        if let url: URLConvertible = URL(string: "https://\(userDomain)/api/v2.6/data-bundle/phata") {
            
            let parametersToSend: Dictionary<String, Any>
            
            if parameters == nil {
                
                parametersToSend = HATProfileService.notablesStructure
            } else {
                
                let mutableDictionary = NSMutableDictionary()
                mutableDictionary.addEntries(from: HATProfileService.notablesStructure)
                mutableDictionary.addEntries(from: parameters!)
                parametersToSend = mutableDictionary as! Dictionary<String, Any>
            }
            
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let manager = Alamofire.SessionManager(configuration: configuration)
            
            manager.request(
                url,
                method: .post,
                parameters: parametersToSend,
                encoding: Alamofire.JSONEncoding.default,
                headers: ["x-auth-token": userToken]).responseJSON(completionHandler: { response in
                    
                    switch response.result {
                    case .success:
                        
                        if response.response?.statusCode == 201 {
                            
                            success(true)
                        } else {
                            
                            success(false)
                        }
                    case .failure(let error):
                        
                        fail(HATTableError.generalError("", nil, error))
                    }
                }
            ).session.finishTasksAndInvalidate()
        }
    }
    
    /**
     Updates the PHATA structure with the new shared fields
     
     - parameter sharedFields: The fields that have been enabled as "shared"
     - parameter userDomain: User's domain
     - parameter userToken: User's Token
     */
    static func updateStructure(sharedFields: Dictionary<String, String?>?, userDomain: String, userToken: String) {
        
        let dict: Dictionary<String, Any>?
        
        if sharedFields != nil {
            
            let mutableDictionary = NSMutableDictionary()
            
            for item in sharedFields! where item.value != nil {
                
                mutableDictionary.addEntries(from: [item.value!: item.value!])
            }
            
            dict = HATProfileService.constructDictionaryForBundle(mutableDictionary: mutableDictionary)
        } else {
            
            dict = HATProfileService.notablesStructure
        }
        
        if sharedFields != nil {
            
            let hatDictionary = HATDictionary(hatDictionary: sharedFields!)
            CacheManager<HATDictionary>.saveObjects(objects: [hatDictionary], inCache: "profile", key: "structure")
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: dict!)
        let structObject = HATSyncObject<HATProfileBundleDataObject>.init(url: "https://\(userDomain)/api/v2.6/data-bundle/phata", object: nil, data: data, dictionary: nil)
        
        CacheManager<HATProfileBundleDataObject>.syncObjects(objects: [structObject], key: "structure")
        CacheManager<HATProfileBundleDataObject>.checkForUnsyncedObjects(forKey: "structure", userToken: userToken, completion: nil)
    }

}
