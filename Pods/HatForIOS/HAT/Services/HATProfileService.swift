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
import SwiftyJSON

// MARK: Struct

public struct HATProfileService {
    
    // MARK: Get Generic
    
    /**
     Gets the nationality of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter nameSpace: The namespace to read from
     - parameter scope: The scope to read from
     - parameter parameters: The parameters to§ pass on to the request, defaults are ["orderBy": "dateCreated", "ordering": "descending", "take": "1"]
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    private static func getFromHATGeneric<T: HatApiType>(userDomain: String, userToken: String, nameSpace: String, scope: String, parameters: [String: String] = ["orderBy": "dateCreated", "ordering": "descending", "take": "1"], successCallback: @escaping (T) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        func profileEntries(json: [JSON], renewedToken: String?) {
            
            // if we have values return them
            if !json.isEmpty {
                
                let object: T = T(fromCache: json.last!.dictionaryValue)
                successCallback(object)
            } else {
                
                failCallback(.noValuesFound)
            }
        }
        
        HATAccountService.getHatTableValues(
            token: userToken,
            userDomain: userDomain,
            namespace: nameSpace,
            scope: scope,
            parameters: parameters,
            successCallback: profileEntries,
            errorCallback: failCallback)
    }
    
    /**
     Gets the nationality of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter object: The object to post to the HAT
     - parameter nameSpace: The namespace to write to
     - parameter scope: The scope to write to
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    private static func postToHATGeneric<T: HatApiType>(userDomain: String, userToken: String, object: T, nameSpace: String, scope: String, successCallback: @escaping (T) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        let json: [String: Any] = object.toJSON()
        
        HATAccountService.createTableValue(
            userToken: userToken,
            userDomain: userDomain,
            namespace: nameSpace,
            scope: scope,
            parameters: json,
            successCallback: { (json, _) in
                
                successCallback(T(fromCache: json.dictionaryValue))
        },
            errorCallback: failCallback)
    }
    
    // MARK: - Get profile nationality
    
    /**
     Gets the nationality of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func getNationalityFromHAT(userDomain: String, userToken: String, successCallback: @escaping (HATNationalityObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        HATProfileService.getFromHATGeneric(
            userDomain: userDomain,
            userToken: userToken,
            nameSpace: "rumpel",
            scope: "nationality",
            successCallback: successCallback,
            failCallback: failCallback)
    }
    
    // MARK: - Post profile nationality
    
    /**
     Posts user's nationality to the hat
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter nationality: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func postNationalityToHAT(userDomain: String, userToken: String, nationality: HATNationalityObject, successCallback: @escaping (HATNationalityObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        HATProfileService.postToHATGeneric(
            userDomain: userDomain,
            userToken: userToken,
            object: nationality,
            nameSpace: "rumpel",
            scope: "nationality",
            successCallback: successCallback,
            failCallback: failCallback)
    }
    
    // MARK: - Get profile relationship and household
    
    /**
     Gets the profile relationship and household of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func getRelationshipAndHouseholdFromHAT(userDomain: String, userToken: String, successCallback: @escaping (HATProfileRelationshipAndHouseholdObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        HATProfileService.getFromHATGeneric(
            userDomain: userDomain,
            userToken: userToken,
            nameSpace: "rumpel",
            scope: "relationshipAndHousehold",
            successCallback: successCallback,
            failCallback: failCallback)
    }
    
    // MARK: - Post profile relationship and household
    
    /**
     Posts user's profile relationship and household to the hat
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter relationshipAndHouseholdObject: The user's relationship and household data
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func postRelationshipAndHouseholdToHAT(userDomain: String, userToken: String, relationshipAndHouseholdObject: HATProfileRelationshipAndHouseholdObject, successCallback: @escaping (HATProfileRelationshipAndHouseholdObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        HATProfileService.postToHATGeneric(
            userDomain: userDomain,
            userToken: userToken,
            object: relationshipAndHouseholdObject,
            nameSpace: "rumpel",
            scope: "relationshipAndHousehold",
            successCallback: successCallback,
            failCallback: failCallback)
    }
    
    // MARK: - Get profile education
    
    /**
     Gets the profile education of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func getEducationFromHAT(userDomain: String, userToken: String, successCallback: @escaping (HATProfileEducationObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        HATProfileService.getFromHATGeneric(
            userDomain: userDomain,
            userToken: userToken,
            nameSpace: "rumpel",
            scope: "education",
            parameters: ["orderBy": "unixTimeStamp", "ordering": "descending", "take": "1"],
            successCallback: successCallback,
            failCallback: failCallback)
    }
    
    // MARK: - Post profile education
    
    /**
     Posts user's profile education to the hat
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter education: The user's education
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func postEducationToHAT(userDomain: String, userToken: String, education: HATProfileEducationObject, successCallback: @escaping (HATProfileEducationObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        HATProfileService.postToHATGeneric(
            userDomain: userDomain,
            userToken: userToken,
            object: education,
            nameSpace: "rumpel",
            scope: "education",
            successCallback: successCallback,
            failCallback: failCallback)
    }
    
    // MARK: - Get Profile
    
    /**
     Gets the profile of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func getProfile(userDomain: String, userToken: String, successCallback: @escaping (HATProfileObject, String?) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        func profileEntries(json: [JSON], renewedToken: String?) {
            
            // if we have values return them
            if !json.isEmpty {
                
                if let profile: HATProfileObject = HATProfileObject.decode(from: json[0].dictionaryValue) {
                    
                    successCallback(profile, renewedToken)
                } else {
                    
                    failCallback(.noValuesFound)
                }
            } else {
                
                failCallback(.noValuesFound)
            }
        }
        
        HATAccountService.getHatTableValues(
            token: userToken,
            userDomain: userDomain,
            namespace: "rumpel",
            scope: "profile",
            parameters: ["ordering": "descending", "orderBy": "dateCreated", "take": "1"],
            successCallback: profileEntries,
            errorCallback: failCallback)
    }
    
    // MARK: - Post Profile
    
    /**
     Gets the profile of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter profile: The profile object to post
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func postProfile(userToken: String, userDomain: String, profile: HATProfileObject, successCallback: @escaping (HATProfileObject, String?) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        guard let profileJSON: Dictionary<String, Any> = HATProfileDataObject.encode(from: profile.data) else {
            
            return
        }
        
        HATAccountService.createTableValue(
            userToken: userToken,
            userDomain: userDomain,
            namespace: "rumpel",
            scope: "profile",
            parameters: profileJSON,
            successCallback: { (json, newToken) in
                
                guard let profile: HATProfileObject = HATProfileObject.decode(from: json.dictionaryValue) else {
                    
                    failCallback(.noValuesFound)
                    return
                }
                
                successCallback(profile, newToken)
        },
            errorCallback: failCallback)
    }
    
    // MARK: - Get Profile Image
    
    /**
     Gets the profile image of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func getProfileImageFromHAT(userDomain: String, userToken: String, successCallback: @escaping (FileUploadObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        HATProfileService.getFromHATGeneric(
            userDomain: userDomain,
            userToken: userToken,
            nameSpace: "rumpel",
            scope: "profileImage",
            successCallback: successCallback,
            failCallback: failCallback)
    }
    
    // MARK: - Post profile Image
    
    /**
     Posts user's profile image to the hat
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter education: The user's education
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func postProfileImageToHAT(userDomain: String, userToken: String, image: FileUploadObject, successCallback: @escaping (FileUploadObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        HATProfileService.postToHATGeneric(
            userDomain: userDomain,
            userToken: userToken,
            object: image,
            nameSpace: "rumpel",
            scope: "profileImage",
            successCallback: successCallback,
            failCallback: failCallback)
    }
    
    // MARK: - Get Stuff To Remember
    
    /**
     Gets the stuff to remember of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func getStuffToRememberFromHAT(userDomain: String, userToken: String, successCallback: @escaping ([StuffToRememberObject], String?) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        func stuffToRemember(json: [JSON], renewedToken: String?) {
            
            // if we have values return them
            if !json.isEmpty {
                
                var arrayToReturn: [StuffToRememberObject] = []
                
                for item: JSON in json {
                    
                    arrayToReturn.append(StuffToRememberObject(dictionary: item.dictionaryValue))
                }
                
                successCallback(arrayToReturn, renewedToken)
            } else {
                
                failCallback(.noValuesFound)
            }
        }
        
        HATAccountService.getHatTableValues(
            token: userToken,
            userDomain: userDomain,
            namespace: "rumpel",
            scope: "stufftoremember",
            parameters: ["starttime": "0"],
            successCallback: stuffToRemember,
            errorCallback: failCallback)
    }
    
    // MARK: - Post Stuff To Remember
    
    /**
     Posts user's stuff to remember
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter stuffToRemember: The user's stuff to remember
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public static func postStuffToRememberToHAT(userDomain: String, userToken: String, stuffToRemember: StuffToRememberObject, successCallback: @escaping (StuffToRememberObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        HATProfileService.postToHATGeneric(
            userDomain: userDomain,
            userToken: userToken,
            object: stuffToRemember,
            nameSpace: "rumpel",
            scope: "stufftoremember",
            successCallback: successCallback,
            failCallback: failCallback)
    }
    
    // MARK: - Get PHATA bundle structure
    
    /**
     Gets the PHATA bundle structure
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters to pass on to the request, default = [:]
     - parameter success: A function to call on success
     - parameter fail: A fuction to call on fail
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
                            
                            if let value: Any = response.result.value {
                                
                                let json: JSON = JSON(value)
                                let message: String = json["message"].stringValue
                                
                                if message != "Bundle Not Found" {
                                    
                                    fail(HATTableError.generalError("json creation failed", nil, nil))
                                }
                            }
                        } else if response.response?.statusCode == 200 {
                            
                            if let value: Any = response.result.value {
                                
                                let json: JSON = JSON(value)
                                let dict: [String: JSON]? = json["bundle"]["profile"]["endpoints"][0]["mapping"].dictionary
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
    
    // MARK: - Notables structure
    
    /// This is the default notables structure that goes in the phata structure bundle
    public static let notablesStructure: [String: Any] = [
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
                            ]
                        ],
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
                                "updated_time": "updated_time",
                                "photo": "photov1"
                        ],
                        "endpoint": "rumpel/notablesv1"
                    ]
                ],
                "orderBy": "updated_time",
                "ordering": "descending"
        ]
    ]
    
    // MARK: - Construct Bundle's Dictionary
    
    /**
     Constructs the dictionary for tha PHATA bundle
     
     - parameter mutableDictionary: The mutable dictionary with the options we want to add to the bundle
     
     - returns: The bundle dictionary as Dictionary<String, Any>?
     */
    public static func constructDictionaryForBundle(mutableDictionary: NSMutableDictionary) -> Dictionary<String, Any>? {
        
        if let dict: [String: String] = mutableDictionary as? Dictionary<String, String> {
            
            let profileStructure: [String: Any] = ["profile":
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
            
            let notablesStructure: [String: Any] = HATProfileService.notablesStructure
            
            let temp: NSMutableDictionary = NSMutableDictionary()
            temp.addEntries(from: profileStructure)
            temp.addEntries(from: notablesStructure)
            
            if let dictionaryToReturn: [String: Any]? = temp as? Dictionary<String, Any> {
                
                return dictionaryToReturn
            }
        }
        
        return nil
    }
    
    // MARK: - Creates the PHATA bundle
    
    /**
     Creates the PHATA bundle structure
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters to pass on to the request, default = [:]
     - parameter success: A function to call on success
     - parameter fail: A fuction to call on fail
     */
    public static func createPhataStructureBundle(userDomain: String, userToken: String, parameters: Dictionary<String, Any>? = nil, success: @escaping (Bool) -> Void, fail: @escaping (HATTableError) -> Void) {
        
        if let url: URLConvertible = URL(string: "https://\(userDomain)/api/v2.6/data-bundle/phata") {
            
            let parametersToSend: Dictionary<String, Any>
            
            if parameters == nil {
                
                parametersToSend = HATProfileService.notablesStructure
            } else {
                
                let mutableDictionary: NSMutableDictionary = NSMutableDictionary()
                mutableDictionary.addEntries(from: HATProfileService.notablesStructure)
                mutableDictionary.addEntries(from: parameters!)
                guard let tempDict: Dictionary<String, Any> = mutableDictionary as? Dictionary<String, Any> else {
                    
                    parametersToSend = [:]
                    return
                }
                parametersToSend = tempDict
            }
            
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let manager: SessionManager = Alamofire.SessionManager(configuration: configuration)
            
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
    
    // MARK: - Create and get Bundle
    
    /**
     Creates and gets the PHATA bundle structure
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter parameters: The parameters to pass on to the request, default = [:]
     - parameter success: A function to call on success
     - parameter fail: A fuction to call on fail
     */
    public static func createAndGetProfileBundle(userDomain: String, userToken: String, parameters: Dictionary<String, Any>? = nil, success: @escaping (Dictionary<String, JSON>) -> Void, fail: @escaping (HATTableError) -> Void) {
        
        func bundleCreated(isBundleCreated: Bool) {
            
            if isBundleCreated {
                
                HATProfileService.getPhataStructureBundle(
                    userDomain: userDomain,
                    userToken: userToken,
                    parameters: [:],
                    success: success,
                    fail: fail)
            }
        }
        
        HATProfileService.createPhataStructureBundle(
            userDomain: userDomain,
            userToken: userToken,
            parameters: parameters,
            success: bundleCreated,
            fail: fail)
    }
}
