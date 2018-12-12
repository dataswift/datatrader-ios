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
import SystemConfiguration

// MARK: Enum State

enum State {
    
    case offline
    case online
    case unknown
    case downloading
    case uploading
}

// MARK: - CLass

internal class NetworkManager: NSObject {
    
    // MARK: - Variables
    
    var state: State = .unknown
    
    // MARK: - Check state
    
    /**
     Checks if the phone has internet connectivity or not
     
     - parameter onlineCompletion: A function to execute if the app is online
     - parameter offlineCompletion: A function to execute if the app is offline
     */
    func checkState(onlineCompletion: (() -> Void)? = nil, offlineCompletion: (() -> Void)? = nil) {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            
            self.state = .offline
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        if (isReachable && !needsConnection) {
            
            self.state = .online
            onlineCompletion?()
        } else {
            
            self.state = .offline
            offlineCompletion?()
        }
    }
    
    // MARK: - Initialise
    
    override init() {
        
        super.init()
        
        self.checkState()
    }
    
    // MARK: - Create a network request

    /**
     Creates a network request
     
     - parameter url: The url to make the request to
     - parameter userToken: The user's token
     - parameter data: The data to put in the request
     - parameter completion: A function to execute upon completion
     */
    static func createRequest(url: String, userToken: String, data: Data?, completion: (() -> Void)? = nil) {
        
        guard let url: URL = URL(string: url) else {
            
            return
        }
        
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue(userToken, forHTTPHeaderField: "x-auth-token")
        urlRequest.networkServiceType = .background
        urlRequest.httpBody = data
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(configuration: configuration)
        
        manager.request(urlRequest).responseJSON(completionHandler: { response in
            
            completion?()
        }).session.finishTasksAndInvalidate()
    }
}
