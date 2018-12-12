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

import Alamofire
import HatForIOS
import SwiftyJSON

class ShapeProfileObject: HATObject {
    
    var highestAcademicQualification: String = ""
    var dateOfBirth: String = ""
    var gender: String = ""
    var incomeGroup: String = ""
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var employmentStatus: String = ""
    var relationshipStatus: String = ""
    var typeOfAccomodation: String = ""
    var livingSituation: String = ""
    var numberOfPeopleInHousehold: String = ""
    var numberOfChildren: String = ""
    var additionalDependets: String = ""
    var dateCreated: Int = Int(Date().timeIntervalSince1970)
}

struct ShapeNetworkManager {

    static func getProfile(userDomain: String, userToken: String, successCallback: @escaping (ShapeProfileObject, String?) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        let headers = ["x-auth-token": userToken]
        let url: String = "https://\(userDomain)/api/v2.6/data/datatrader/profile"
        let parameters = ["sorting": "descending",
                          "sortBy": "dateCreated",
                          "take": "1"]
        
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .get,
            encoding: Alamofire.JSONEncoding.default,
            contentType: ContentType.json,
            parameters: parameters,
            headers: headers,
            completion: { result in
                
                switch result {
                    
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        failCallback(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        failCallback(.generalError(message, statusCode, error))
                    }
                case .isSuccess(let isSuccess, let statusCode, let result, let token):
                    
                    if statusCode != nil && (statusCode! == 401 || statusCode! == 403) {
                        
                        let message: String = NSLocalizedString("Token expired", comment: "")
                        failCallback(.generalError(message, statusCode, nil))
                    }
                    if isSuccess {
                        
                        let dictionary = result.arrayValue.first
                        guard let dict = dictionary?["data"].dictionaryValue else { return }
                        guard let profile: ShapeProfileObject = ShapeProfileObject.decode(from: dict) else {
                            
                            let message: String = NSLocalizedString("Failed decoding object", comment: "")
                            failCallback(.generalError(message, statusCode, nil))
                            return
                        }
                        
                        successCallback(profile, token)
                    }
                }
        })
    }
    
    static func postProfile(userDomain: String, userToken: String, profile: ShapeProfileObject, successCallback: @escaping (Bool, String?) -> Void, failCallback: @escaping (HATTableError) -> Void) {
        
        let headers = ["x-auth-token": userToken]
        let url: String = "https://\(userDomain)/api/v2.6/data/datatrader/profile"
        guard let temp: [String: Any] = ShapeProfileObject.encode(from: profile) else { return }
        print(temp)
        HATNetworkHelper.asynchronousRequest(
            url,
            method: .post,
            encoding: Alamofire.JSONEncoding.default,
            contentType: ContentType.json,
            parameters: temp,
            headers: headers,
            completion: { result in
                
                switch result {
                    
                case .error(let error, let statusCode, _):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        failCallback(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        failCallback(.generalError(message, statusCode, error))
                    }
                case .isSuccess(let isSuccess, let statusCode, _, let token):
                    
                    if statusCode != nil && (statusCode! == 401 || statusCode! == 403) {
                        
                        let message: String = NSLocalizedString("Token expired", comment: "")
                        failCallback(.generalError(message, statusCode, nil))
                    }
                    if isSuccess {
                        
                        successCallback(true, token)
                    }
                }
        })
    }
}
