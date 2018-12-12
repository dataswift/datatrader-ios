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

extension HATFitbitService {

    // MARK: - Fitbit Info
    
    /**
     Gets the static fitbit info as PlugDetails array
     
     - parameter userToken: The user's token
     - parameter userDomain: The user's hat domain
     - parameter success: A function to execute on success returning the PlugDetails array
     */
    static func loadFitbitInfo(userToken: String, userDomain: String, success: @escaping([PlugDetails]) -> Void) {
        
        func gotAllFitBitData(profile: [HATFitbitProfileObject], newToken: String?) {
            
            guard let firstObject: HATFitbitProfileObject = profile.first else {
                
                return
            }
            
            let plugDetailsArray: [PlugDetails] = HATFitbitService.parseFitbitData(profile: firstObject)
            success(plugDetailsArray)
        }
        
        func tableNotFound(error: HATTableError) {
            
        }
        
        HATFitbitService.getProfile(
            userDomain: userDomain,
            userToken: userToken,
            parameters: ["take": "1", "orderBy": "dateCreated", "ordering": "descending"],
            successCallback: gotAllFitBitData,
            errorCallback: tableNotFound)
    }
    
    // MARK: - Parse fitbit
    
    /**
     Parses the fitbit profile as PlugDetails object
     
     - parameter profile: The fitbit profile object to parse as PlugDetails object
     
     - returns: An array of PlugDetails objects
     */
    static func parseFitbitData(profile: HATFitbitProfileObject) -> [PlugDetails] {
        
        var arrayToAdd: [PlugDetails] = []
        var object: PlugDetails = PlugDetails()
        
        object.name = "First name"
        object.value = profile.firstName
        arrayToAdd.append(object)
        
        object.name = "Last name"
        object.value = profile.lastName
        arrayToAdd.append(object)
        
        object.name = "Timezone"
        object.value = profile.timezone
        arrayToAdd.append(object)
        
        object.name = "Distance unit"
        if profile.distanceUnit == "METRIC" {
            
            object.value = "Km"
        } else {
            
            object.value = "Miles"
        }
        arrayToAdd.append(object)
        
        object.name = "Date of Birth"
        object.value = profile.dateOfBirth
        arrayToAdd.append(object)
        
        object.name = "Weight"
        if profile.weightUnit == "METRIC" {
            
            object.value = "\(String(describing: profile.weight)) Kg"
        } else {
            
            object.value = "\(String(describing: profile.weight)) lbs"
        }
        arrayToAdd.append(object)
        
        object.name = "Height"
        if profile.heightUnit == "METRIC" {
            
            object.value = "\(String(describing: profile.height)) cm"
        } else {
            
            object.value = "\(String(describing: profile.weight)) ft"
        }
        arrayToAdd.append(object)
        
        object.name = "Member since"
        object.value = profile.memberSince
        arrayToAdd.append(object)
        
        object.name = "Locale"
        object.value = profile.locale
        arrayToAdd.append(object)
        
        object.name = "Gender"
        object.value = profile.gender
        arrayToAdd.append(object)
        
        return arrayToAdd
    }
    
    // MARK: - Create JSON for data bundle
    
    /**
     Constructs the JSON, as [String: Any] format, to pass in Alamofire request
     
     - returns: A [String: Any] array, suitable to pass in Alamofire request
     */
    static private func fitbitFeedJSON() -> [String: Any] {
        
        return [
            "weight": [
                "endpoints": [
                    [
                        "endpoint": "fitbit/weight"
                    ]
                ],
                "orderBy": "date",
                "ordering": "descending"
            ],
            "sleep": [
                "endpoints": [
                    [
                        "endpoint": "fitbit/sleep"
                    ]
                ],
                "orderBy": "startTime",
                "ordering": "descending"
            ],
            "activity": [
                "endpoints": [
                    [
                        "endpoint": "fitbit/activity"
                    ]
                ],
                "orderBy": "createdTime",
                "ordering": "descending"
            ]
        ]
    }
    
    // MARK: - Create Data bundle for fitbit feed
    
    /**
     Creates data bundle with all the data needed for fitbit feed
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter success: A function to execute on success returning true or false depending the result of the call
     - parameter fail: A function to execute on error returing the error occured
     */
    public static func createBundleWithFeed(userDomain: String, userToken: String, success: @escaping (Bool) -> Void, fail: @escaping (HATTableError) -> Void) {
        
        if let url: URLConvertible = URL(string: "https://\(userDomain)/api/v2.6/data-bundle/fitbitfeed") {
            
            let parameters: Parameters = HATFitbitService.fitbitFeedJSON()
            
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            let manager: SessionManager = Alamofire.SessionManager(configuration: configuration)
            
            manager.request(
                url,
                method: .post,
                parameters: parameters,
                encoding: Alamofire.JSONEncoding.default,
                headers: ["x-auth-token": userToken]).responseJSON(completionHandler: { response in
                    
                    switch response.result {
                    case .success:
                        
                        if response.response?.statusCode == 201 || response.response?.statusCode == 200 {
                            
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
    
    // MARK: - Get fitbit data bundle
    
    /**
     Fetches the data bundle for fitbit feed
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter success: A function to execute on success returning the JSON fetched from HAT
     - parameter fail: A function to execute on error returing the error occured
     */
    static func getFitbitData(userDomain: String, userToken: String, parameters: Dictionary<String, Any> = [:], success: @escaping (Dictionary<String, JSON>) -> Void, fail: @escaping (HATTableError) -> Void) {
        
        if let url: URLConvertible = URL(string: "https://\(userDomain)/api/v2.6/data-bundle/fitbitfeed") {
            
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
                        
                        if let value: Any = response.result.value {
                            
                            let json = JSON(value)
                            success(json.dictionaryValue)
                        } else {
                            
                            fail(HATTableError.generalError("json creation failed", nil, nil))
                        }
                    case .failure(let error):
                        
                        fail(HATTableError.generalError("", nil, error))
                    }
                }
            ).session.finishTasksAndInvalidate()
        }
    }
    
    /**
     Parses fitbit feed in away I can easily work with
     
     - parameter dictionary: The JSON received from HAT
     
     - returns: The static feed data for fitbit
     */
    static func gotFitbitData(dictionary: Dictionary<String, JSON>) -> [FitbitFeedObject] {
        
        var tempFeedArray: [FitbitFeedObject] = []
        for dict in dictionary where !dict.value.arrayValue.isEmpty {
            
            if dict.key == "sleep" {
                
                for item in dict.value.arrayValue {
                    
                    let tempSleep = item["data"].dictionaryValue
                    
                    guard let sleep: HATFitbitSleepObject = HATFitbitSleepObject.decode(from: tempSleep) else {
                        
                        break
                    }
                    
                    let timeInterval = TimeInterval(sleep.duration / 1000)
                    
                    var object = FitbitFeedObject()
                    
                    object.name = "Sleep"
                    
                    let duration = timeInterval.stringTime
                    guard let sleepStartTime = HATFormatterHelper.formatStringToDate(string: sleep.startTime)?.getTimeOfDay(),
                        let wakeUpTime = HATFormatterHelper.formatStringToDate(string: sleep.endTime) else { continue }
                    let timesAwake = String(describing: sleep.levels.summary.awake.count)
                    let timesRestless = String(describing: sleep.levels.summary.awake.count)
                    let minutesAwakeRestless = String(describing: sleep.levels.summary.restless.minutes + sleep.levels.summary.awake.minutes)
                    
                    let attributedString = NSAttributedString(string: "- Sleep Duration: \(duration)\n- Start Time: \(sleepStartTime)\n- Wake Up Time: \(wakeUpTime)\n- Times Awake: \(timesAwake)\n- Times Restless: \(timesRestless)\n- Minutes Awake/Restless: \(minutesAwakeRestless)")
                    object.value = attributedString.string
                    object.category = "Sleep"
                    object.date = HATFormatterHelper.formatStringToDate(string: sleep.dateOfSleep)!
                    tempFeedArray.append(object)
                }
            } else if dict.key == "weight" {
                
                for item in dict.value.arrayValue {
                    
                    let tempWeight = item["data"].dictionaryValue
                    
                    guard let weight: HATFitbitWeightObject = HATFitbitWeightObject.decode(from: tempWeight) else {
                        
                        break
                    }
                    
                    var object = FitbitFeedObject()
                    object.name = "Weight"
                    object.value = "- Weight: \(weight.weight)"//" \(weightUnit)"
                    object.category = "Weight"
                    object.date = HATFormatterHelper.formatStringToDate(string: weight.date)!
                    tempFeedArray.append(object)
                }
            } else if dict.key == "activity" {
                
                for item in dict.value.arrayValue {
                    
                    let tempDailyActivity = item["data"].dictionaryValue
                    
                    guard let activity: HATFitbitActivityObject = HATFitbitActivityObject.decode(from: tempDailyActivity) else {
                        
                        break
                    }
                    
                    var object = FitbitFeedObject()
                    
                    let timeInterval = TimeInterval(activity.duration / 1000)
                    let date = HATFormatterHelper.formatStringToDate(string: activity.originalStartTime)
                    let steps = String(describing: activity.steps ?? 0)
                    let calories = String(describing: activity.calories)
                    let duration = timeInterval.stringTime
                    let value = NSAttributedString(string: "- Steps: \(steps)\n- Calories: \(calories)\n- Duration: \(duration)")
                    
                    object.name = "Steps"
                    object.category = activity.activityName
                    object.addedCategoryID = activity.activityName
                    object.date = date!
                    object.value = value.string

                    tempFeedArray.append(object)
                }
            }
        }
        
        return HATFitbitService.sortFeed(tempFeedArray)
    }
    
    // MARK: - Sort fitbit
    
    /**
     Sorts the feed received from hat
     
     - parameter array: The array to sort
     
     - returns: The array passed as parameter but sorted by date and category
     */
    static func sortFeed(_ array: [FitbitFeedObject]) -> [FitbitFeedObject] {
        
        var array: [FitbitFeedObject] = array
        guard !array.isEmpty else {
            
            return array
        }
        
        array = array.sorted(by: { (obj1, obj2) -> Bool in
            
            if obj1.date == obj2.date {
                
                if obj1.category > obj2.category {
                    
                    return true
                } else {
                    
                    return false
                }
            } else if obj1.date > obj2.date {
                
                return true
            } else {
                
                return false
            }
        })
        
        return array
    }
}
