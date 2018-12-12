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
import JWTDecode
import SwiftyRSA

// MARK: Struct

/// The login service class
public struct HATLoginService {
    
    /**
     Verify userDomain that it can log on to the HAT
     
     - parameter userHATDomain: The user's domain
     - parameter verifiedDomains: The allowed domains to login to the HAT
     - parameter successfulVerification: The function to execute on successful verification
     - parameter failedVerification: The function to execute on failed verification
     */
    public static func formatAndVerifyDomain(userHATDomain: String, verifiedDomains: [String], successfulVerification: @escaping (String) -> Void, failedVerification: @escaping (String) -> Void) {
        
        // trim values
        let hatDomain: String = userHATDomain.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let result: Bool = hatDomain.hasSuffixes(verifiedDomains)
        
        // verify if the domain is what we want
        if result {
            
            // domain accepted
            successfulVerification(userHATDomain)
        } else {
            
            // domain is incorrect
            let message: String = NSLocalizedString("The domain you entered is incorrect. Accepted domains are 'hubofallthings.net, savy.io and hubat.net. Please correct any typos and try again", comment: "")
            failedVerification(message)
        }
    }
    
    /**
     Gets the public key from HAT
     
     - parameter userDomain: The user's domain
     - parameter completion: The function to execute on successful verification, returning the puvlic key
     - parameter failed: The function to execute on failed verification
     */
    public static func getPublicKey(userDomain: String, completion: @escaping (String) -> Void, failed: @escaping (HATError) -> Void) {
        
        let url: String? = HATAccountService.theUserHATDomainPublicKeyURL(userDomain)
        
        HATNetworkHelper.asynchronousStringRequest(
            url!,
            method: .get,
            encoding: Alamofire.JSONEncoding.default,
            contentType: ContentType.json,
            parameters: [:],
            headers: [:],
            completion: {response in
                
                switch response {
                case .isSuccess(let isSuccess, let statusCode, let result, _):
                    
                    if isSuccess && statusCode == 200 {
                        
                        completion(result)
                    } else {
                        
                        let message: String = "Error"
                        failed(.generalError(message, statusCode, nil))
                    }
                case .error(let error, let statusCode):
                    
                    if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                        
                        failed(.noInternetConnection)
                    } else {
                        
                        let message: String = NSLocalizedString("Server responded with error", comment: "")
                        failed(.generalError(message, statusCode, error))
                    }
                }
        })
    }
    
    /**
     Log in authorization process
     
     - parameter userDomain: The user's domain
     - parameter url: The url to connect
     - parameter success: A function to execute after finishing, returing the userToken
     - parameter failed: A function to execute after finishing, returning AuthenicationError
     */
    public static func loginToHATAuthorization(applicationName: String, url: NSURL, success: ((String?, String?) -> Void)?, failed: ((AuthenicationError) -> Void)?) {
        
        // get token out
        if let token: String = HATNetworkHelper.getQueryStringParameter(url: url.absoluteString, param: RequestHeaders.tokenParamName) {
            
            let decodedToken: JWT? = try? decode(jwt: token)
            let userDomain: String? = decodedToken?.claim(name: "iss").string
            // make asynchronous call
            // parameters..
            let parameters: Dictionary<String, String> = [:]
            // auth header
            let headers: [String: String] = ["Accept": ContentType.text, "Content-Type": ContentType.text]
            
            if let url: String = HATAccountService.theUserHATDomainPublicKeyURL(userDomain!) {
                
                //. application/json
                HATNetworkHelper.asynchronousStringRequest(url, method: HTTPMethod.get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.text, parameters: parameters as Dictionary<String, AnyObject>, headers: headers) { (response: HATNetworkHelper.ResultTypeString) -> Void in
                    
                    switch response {
                    case .isSuccess(let isSuccess, let statusCode, let result, _):
                        
                        if isSuccess {
                            
                            // decode the token and get the iss out
                            guard let jwt: JWT = try? decode(jwt: token) else {
                                
                                failed?(.cannotDecodeToken(token))
                                return
                            }
                            
                            // guard for the issuer check, “iss” (Issuer)
                            guard jwt.issuer != nil else {
                                
                                failed?(.noIssuerDetectedError(jwt.string))
                                return
                            }
                            
                            let appName: String? = jwt.claim(name: "application").string
                            let scope: String? = jwt.claim(name: "accessScope").string
                            
                            if appName != applicationName && scope == nil {
                                
                                failed?(.cannotDecodeToken(token))
                                return
                            } else if scope != "owner" && appName == nil {
                                
                                failed?(.cannotDecodeToken(token))
                                return
                            }
                            
                            /*
                             The token will consist of header.payload.signature
                             To verify the token we use header.payload hashed with signature in base64 format
                             The public PEM string is used to verify also
                             */
                            let tokenAttr: [String] = token.components(separatedBy: ".")
                            
                            // guard for the attr length. Should be 3 [header, payload, signature]
                            guard tokenAttr.count == 3 else {
                                
                                failed?(.cannotSplitToken(tokenAttr))
                                return
                            }
                            
                            // And then to access the individual parts of token
                            let header: String = tokenAttr[0]
                            let payload: String = tokenAttr[1]
                            let signature: String = tokenAttr[2]
                            
                            // decode signature from baseUrl64 to base64
                            let decodedSig: String = HATFormatterHelper.fromBase64URLToBase64(stringToConvert: signature)
                            
                            // data to be verified header.payload
                            let headerAndPayload: String = "\(header).\(payload)"
                            
                            do {
                                
                                let signature: Signature = try Signature(base64Encoded: decodedSig)
                                let privateKey: PublicKey = try PublicKey(pemEncoded: result)
                                let clear: ClearMessage = try ClearMessage(string: headerAndPayload, using: .utf8)
                                let isSuccessful: Bool = try clear.verify(with: privateKey, signature: signature, digestType: .sha256)
                                
                                if isSuccessful {
                                    
                                    success?(userDomain, token)
                                } else {
                                    
                                    failed?(.tokenValidationFailed(isSuccessful.description))
                                }
                                
                            } catch {
                                
                                let message: String = NSLocalizedString("Proccessing of token failed", comment: "")
                                failed?(.tokenValidationFailed(message))
                            }
                            
                        } else {
                            
                            failed?(.generalError(isSuccess.description, statusCode, nil))
                        }
                        
                    case .error(let error, let statusCode):
                        
                        if error.localizedDescription == "The request timed out." || error.localizedDescription == "The Internet connection appears to be offline." {
                            
                            failed?(.noInternetConnection)
                        } else {
                            
                            let message: String = NSLocalizedString("Server responded with error", comment: "")
                            failed?(.generalError(message, statusCode, error))
                        }
                    }
                }
            }
        } else {
            
            failed?(.noTokenDetectedError)
        }
    }
}
