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

// MARK: Class

/// All network related methods
public class HATNetworkHelper: NSObject {
    
    // MARK: - Enums
    
    /**
     JSON Result from HTTP requests
     
     - IsSuccess: A tuple containing: isSuccess: Bool, statusCode: Int?, result: JSON, token: String?
     - Error: A tuple containing: error: Error, statusCode: Int?
     */
    public enum ResultType {
        
        /// when the result is success. A tuple containing: isSuccess: Bool, statusCode: Int?, result: JSON
        case isSuccess(isSuccess: Bool, statusCode: Int?, result: JSON, token: String?)
        /// when the result is error. A tuple containing: error: Error, statusCode: Int?, result: JSON
        case error(error: Error, statusCode: Int?, result: JSON?)
    }
    
    /**
     String Result from HTTP requests
     
     - IsSuccess: A tuple containing: isSuccess: Bool, statusCode: Int?, result: String, token: String?
     - Error: A tuple containing: error: Error, statusCode: Int?
     */
    public enum ResultTypeString {
        
        /// when the result is success. A tuple containing: isSuccess: Bool, statusCode: Int?, result: String
        case isSuccess(isSuccess: Bool, statusCode: Int?, result: String, token: String?)
        /// when the result is error. A tuple containing: error: Error, statusCode: Int?
        case error(error: Error, statusCode: Int?)
    }
    
    // MARK: - Request methods
    
    /**
     Makes ansychronous JSON request
     Closure for caller to handle
     
     - parameter url: The URL to connect to
     - parameter method: The method to use in connecting with the URL
     - parameter encoding: The encoding to use in the request
     - parameter contentType: The content type of the request
     - parameter parameters: The parameters in the request
     - parameter headers: The headers in the request
     - parameter completion: The completion handler to execute upon completing the request
     */
    public class func asynchronousRequest(
        
        _ url: String,
        method: HTTPMethod,
        encoding: ParameterEncoding,
        contentType: String,
        parameters: Dictionary<String, Any>,
        headers: Dictionary<String, String>,
        completion: @escaping (_ r: HATNetworkHelper.ResultType) -> Void) {
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager: SessionManager = Alamofire.SessionManager(configuration: configuration)
        
        // do a post
        manager.request(
            url, /* request url */
            method: method, /* GET, POST, etc*/
            parameters: parameters, /* parameters to POST*/
            encoding: encoding, /* encoding type, JSON, URLEncoded, etc*/
            headers: headers /* request header */
            )
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                switch response.result {
                case .success:
                    
                    let header: [AnyHashable: Any]? = response.response?.allHeaderFields
                    
                    if let stringHeaders: [String: String] = header as? [String: String], let url: URL = (response.response?.url!) {
                        
                        let cookies: [HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: stringHeaders, for: url)
                        manager.session.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
                    }
                    
                    let token: String? = header?["x-auth-token"] as? String
                    
                    if response.response?.statusCode == 401 {
                        
                        completion(HATNetworkHelper.ResultType.error(error: AuthenicationError.tokenValidationFailed("expired"), statusCode: response.response?.statusCode, result: nil))
                    } else {
                        
                        // check if we have a value and return it
                        if let value: Any = response.result.value {
                            
                            let json: JSON = JSON(value)
                            if token != nil || 200 ... 299 ~= response.response!.statusCode {
                                
                                completion(HATNetworkHelper.ResultType.isSuccess(isSuccess: true, statusCode: response.response?.statusCode, result: json, token: token))
                            } else {
                                
                                completion(HATNetworkHelper.ResultType.error(error: HATError.generalError("Unexpected Error", response.response?.statusCode, nil), statusCode: response.response?.statusCode, result: json))
                            }
                            
                        // else return isSuccess: false and nil for value
                        } else {
                            
                            if token != nil || 200 ... 299 ~= response.response!.statusCode {
                                
                                completion(HATNetworkHelper.ResultType.isSuccess(isSuccess: false, statusCode: response.response?.statusCode, result: "", token: token))
                            } else {
                                
                                completion(HATNetworkHelper.ResultType.error(error: HATError.generalError("Unexpected Error", response.response?.statusCode, nil), statusCode: response.response?.statusCode, result: nil))
                            }
                        }
                    }
                // in case of failure return the error but check for internet connection or unauthorised status and let the user know
                case .failure(let error):
                    
                    if let value: Any = response.result.value {
                        
                        let json: JSON = JSON(value)
                        completion(HATNetworkHelper.ResultType.error(error: error, statusCode: response.response?.statusCode, result: json))
                    } else {
                        
                        completion(HATNetworkHelper.ResultType.error(error: error, statusCode: response.response?.statusCode, result: nil))
                    }
                }
            }.session.finishTasksAndInvalidate()
    }
    
    /**
     Makes ansychronous string request
     Closure for caller to handle
     
     - parameter url: The URL to connect to
     - parameter method: The method to use in connecting with the URL
     - parameter encoding: The encoding to use in the request
     - parameter contentType: The content type of the request
     - parameter parameters: The parameters in the request
     - parameter headers: The headers in the request
     - parameter completion: The completion handler to execute upon completing the request
     */
    public class func asynchronousStringRequest(
        
        _ url: String,
        method: HTTPMethod,
        encoding: ParameterEncoding,
        contentType: String,
        parameters: Dictionary<String, Any>,
        headers: Dictionary<String, String>,
        completion: @escaping (_ r: HATNetworkHelper.ResultTypeString) -> Void) {
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager: SessionManager = Alamofire.SessionManager(configuration: configuration)
        
        // do a post
        manager.request(
            url, /* request url */
            method: method, /* GET, POST, etc*/
            parameters: parameters, /* parameters to POST*/
            encoding: encoding, /* encoding type, JSON, URLEncoded, etc*/
            headers: headers /* request header */
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: [contentType])
            .responseString { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                switch response.result {
                case .success:
                    
                    let header: [AnyHashable: Any]? = response.response?.allHeaderFields
                    let token: String? = header?["x-auth-token"] as? String
                    
                    // check if we have a value and return it
                    if let value: String = response.result.value {
                        
                        if token != nil {
                            
                            completion(HATNetworkHelper.ResultTypeString.isSuccess(isSuccess: true, statusCode: response.response?.statusCode, result: value, token: token))
                        } else {
                            
                            completion(HATNetworkHelper.ResultTypeString.isSuccess(isSuccess: true, statusCode: response.response?.statusCode, result: value, token: nil))
                        }
                        // else return isSuccess: false and nil for value
                    } else {
                        
                        if token != nil {
                            
                            completion(HATNetworkHelper.ResultTypeString.isSuccess(isSuccess: false, statusCode: response.response?.statusCode, result: "", token: token))
                        } else {
                            
                            completion(HATNetworkHelper.ResultTypeString.isSuccess(isSuccess: false, statusCode: response.response?.statusCode, result: "", token: nil))
                        }
                    }
                // return the error
                case .failure(let error):
                    
                    completion(HATNetworkHelper.ResultTypeString.error(error: error, statusCode: response.response?.statusCode))
                }
            }.session.finishTasksAndInvalidate()
    }
    
    // MARK: - Upload file
    
    /**
     Uploads a specified file to the url provided
     
     - parameter filePath: A String representing the file path
     - parameter url: The url to upload the file to
     - parameter completion: A function to execute if everything is ok
     */
    public class func uploadFile(image: Data, url: String, progressUpdateHandler: ((Double) -> Void)?, completion: @escaping (_ r: HATNetworkHelper.ResultType) -> Void) {
        
        let headers: [String: String] = ["x-amz-server-side-encryption": "AES256"]
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        let manager: SessionManager = Alamofire.SessionManager(configuration: configuration)
        
        manager.upload(image, to: URL(string: url)!, method: .put, headers: headers).uploadProgress(closure: {(progress) -> Void in
            
            if let updateFunc: ((Double) -> Void) = progressUpdateHandler {
                
                updateFunc(progress.fractionCompleted)
            }
        }).responseString(completionHandler: {(response) in
            
            let header: [AnyHashable: Any]? = response.response?.allHeaderFields
            let token: String? = header?["x-auth-token"] as? String
            
            switch response.result {
            case .success:
                
                // check if we have a value and return it
                if let value: String = response.result.value {
                    
                    if token != nil {
                        
                        completion(HATNetworkHelper.ResultType.isSuccess(isSuccess: true, statusCode: response.response?.statusCode, result: JSON(value), token: token))
                    } else {
                        
                        completion(HATNetworkHelper.ResultType.isSuccess(isSuccess: true, statusCode: response.response?.statusCode, result: JSON(value), token: nil))
                    }
                    // else return isSuccess: false and nil for value
                } else {
                    
                    if token != nil {
                        
                        completion(HATNetworkHelper.ResultType.isSuccess(isSuccess: false, statusCode: response.response?.statusCode, result: "", token: token))
                    } else {
                        
                        completion(HATNetworkHelper.ResultType.isSuccess(isSuccess: false, statusCode: response.response?.statusCode, result: "", token: nil))
                    }
                }
            // return the error
            case .failure(let error):
                
                if let value: Any = response.result.value {
                    
                    let json: JSON = JSON(value)
                    completion(HATNetworkHelper.ResultType.error(error: error, statusCode: response.response?.statusCode, result: json))
                } else {
                    
                    completion(HATNetworkHelper.ResultType.error(error: error, statusCode: response.response?.statusCode, result: nil))
                }
            }
        }).session.finishTasksAndInvalidate()
    }
    
    // MARK: - Query from string
    
    /**
     Gets a param value from a url
     
     - parameter url: The url to extract the parameters from
     - parameter param: The parameter
     
     - returns: String or nil if not found
     */
    public class func getQueryStringParameter(url: String?, param: String) -> String? {
        
        if let url: String = url,
            let urlComponents: NSURLComponents = NSURLComponents(string: url),
            let queryItems: [URLQueryItem] = (urlComponents.queryItems) {
            
            let parameter: URLQueryItem? = queryItems.first(where: { item in item.name == param })
            
            return parameter?.value
        }
        
        return nil
    }
}
