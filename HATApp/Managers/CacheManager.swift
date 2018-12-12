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

import Cache
import Alamofire
import HatForIOS
import SwiftyJSON

// MARK: Struct

struct CacheManager<T: HATObject>: UserCredentialsProtocol {
    
    // MARK: - Get cache

    /**
     Gets the cache with the parameters specified
     
     - parameter name: The name of the cache to load
     - parameter memoryConfig: The memory configuration. It defaults to daily expiry
     
     - returns: A Storage object for the specified generic type
     */
    static func getCache<S: Any & Codable>(named name: String, memoryConfig: MemoryConfig = MemoryConfig(expiry: .seconds(3600), countLimit: 0, totalCostLimit: 0)) -> Storage<S>? {
        
        do {
            
            let userDomain = CacheManager().userDomain
            let diskConfig = DiskConfig(name: "\(userDomain)\(name)")
            
            return try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: S.self))
        } catch {
            
            return nil
        }
    }
    
    // MARK: - Retrieve objects
    
    /**
     Gets the objects from the cache
     
     - parameter cache: The name of the cache to load
     - parameter key: The key to search the objects with
     
     - returns: A double array of the type specified
     */
    static func retrieveObjects(fromCache cache: String, forKey key: String, networkRequest: (() -> Void)? = nil) -> [[T]]? {
        
        if let storage: Storage<[[T]]> = CacheManager.getCache(named: cache) {
            
            do {
                
                let results = try storage.object(forKey: key)
                return CacheManager.checkExpiryDateOfObjects(objects: results, fromCache: cache, forKey: key, networkRequest: networkRequest)
            } catch {
                
                networkRequest?()
                return nil
            }
        }
        
        networkRequest?()
        return nil
    }
    
    /**
     Gets the objects from the cache
     
     - parameter cache: The name of the cache to load
     - parameter key: The key to search the objects with
     
     - returns: An array of the type specified
     */
    static func retrieveObjects(fromCache cache: String, forKey key: String, networkRequest: (() -> Void)? = nil) -> [T]? {
        
        if let storage: Storage<[T]> = CacheManager.getCache(named: cache) {
            
            do {
                
                let results = try storage.object(forKey: key)
                return CacheManager.checkExpiryDateOfObjects(objects: results, fromCache: cache, forKey: key, networkRequest: networkRequest)
            } catch {
                
                networkRequest?()
                return nil
            }
        }
        
        networkRequest?()
        return nil
    }
    
    // MARK: - Retrieve images
    
    /**
     Gets the image from the cache
     
     - parameter cache: The name of the cache to load
     - parameter key: The key to search the objects with
     - parameter networkRequest: A network request to execute if it fails to delete the expired cache
     
     - returns: An UIImage
     */
    static func retrieveImage(fromCache cache: String, forKey key: String, networkRequest: (() -> Void)? = nil) -> UIImage? {
        
        if let storage: Storage<ImageWrapper> = CacheManager.getCache(named: cache) {
            
            do {
                
                try storage.removeExpiredObjects()
                
                return try storage.object(forKey: key).image
            } catch {
                
                networkRequest?()
                return nil
            }
        }
        
        networkRequest?()
        return nil
    }
    
    // MARK: - Check expiry date
    
    /**
     Checks the expiry date of the objects
     
     - parameter objects: The objects to check if they have expired
     - parameter cache: The cache to look for
     - parameter key: The key that they were saved normally with
     - parameter networkRequest: A function to execute if it fails of if the cache is empty
     
     - returns: An array of the specified object
     */
    static func checkExpiryDateOfObjects(objects: [T] = [], fromCache cache: String, forKey key: String, networkRequest: (() -> Void)? = nil) -> [T]? {
        
        if let storage: Storage<[T]> = CacheManager.getCache(named: cache) {
            
            let networkStatus = NetworkManager()
            if networkStatus.state == .online {
                
                do {
                    
                    try storage.removeExpiredObjects()
                    let results = try storage.object(forKey: key)
                    
                    if results.isEmpty {
                        
                        networkRequest?()
                    } else {
                        
                        return results
                    }
                } catch {
                    
                    networkRequest?()
                    return nil
                }
            } else {
                
                return objects
            }
        }
        
        networkRequest?()
        return nil
    }
    
    /**
     Checks the expiry date of the objects
     
     - parameter objects: The objects to check if they have expired
     - parameter cache: The cache to look for
     - parameter key: The key that they were saved normally with
     - parameter networkRequest: A function to execute if it fails of if the cache is empty
     
     - returns: A double array of the specified object
     */
    static func checkExpiryDateOfObjects(objects: [[T]] = [], fromCache cache: String, forKey key: String, networkRequest: (() -> Void)? = nil) -> [[T]]? {
        
        if let storage: Storage<[[T]]> = CacheManager.getCache(named: cache) {
            
            let networkStatus = NetworkManager()
            if networkStatus.state == .online {
                
                do {
                    
                    try storage.removeExpiredObjects()
                    let results = try storage.object(forKey: key)
                    
                    if results.isEmpty {
                        
                        networkRequest?()
                    } else {
                        
                        return results
                    }
                } catch {
                    
                    networkRequest?()
                    return nil
                }
            } else {
                
                return objects
            }
        }
        
        networkRequest?()
        return nil
    }
    
    // MARK: - Save objects
    
    /**
     Saves the objects into the cache
     
     - parameter objects: The objects to save in the cache
     - parameter cache: The cache to save the objects to
     - parameter key: The key to save the objects with
     */
    static func saveObjects(objects: [T], inCache cache: String, key: String) {
        
        if let storage: Storage<[T]> = CacheManager.getCache(named: cache) {
            
            do {
                
                try storage.setObject(objects, forKey: key)
            } catch {
                
            }
        }
    }
    
    /**
     Saves the objects into the cache
     
     - parameter objects: The objects to save in the cache
     - parameter cache: The cache to save the objects to
     - parameter key: The key to save the objects with
     */
    static func saveObjects(objects: [[T]], inCache cache: String, key: String) {
        
        if let storage: Storage<[[T]]> = CacheManager.getCache(named: cache) {
            
            do {
                
                try storage.setObject(objects, forKey: key)
            } catch {
                
            }
        }
    }
    
    // MARK: - Save images
    
    /**
     Saves the image into the cache
     
     - parameter image: The image to save in the cache
     - parameter cache: The cache to save the objects to
     - parameter key: The key to save the objects with
     */
    static func saveImages(image: UIImage, inCache cache: String, key: String) {
        
        if let storage: Storage<ImageWrapper> = CacheManager.getCache(named: cache) {
            
            do {
                
                let wrapper = ImageWrapper(image: image)
                try storage.setObject(wrapper, forKey: key)
            } catch {
                
            }
        }
    }
    
    // MARK: - Sync objects
    
    /**
     Syncs the objects into the cache
     
     - parameter objects: The objects to sync
     - parameter cache: The cache to search
     - parameter key: The key to look with
     */
    static func syncObjects(objects: [HATSyncObject<T>], inCache cache: String = "sync", key: String) {
        
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 0, totalCostLimit: 0)
        if let storage: Storage<[HATSyncObject<T>]> = CacheManager.getCache(named: cache, memoryConfig: memoryConfig) {
            
            do {
                
                try storage.setObject(objects, forKey: key)
            } catch {
                
                print("error adding image to cache")
            }
        }
    }
    
    // MARK: - Sync images
    
    /**
     Syncs the image into the cache
     
     - parameter image: The image to sync
     - parameter cache: The cache to search
     - parameter key: The key to look with
     */
    static func syncImage(image: UIImage, inCache cache: String = "sync", key: String) {
        
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 0, totalCostLimit: 0)
        if let storage: Storage<ImageWrapper> = CacheManager.getCache(named: cache, memoryConfig: memoryConfig) {
            
            do {
                
                let wrapper = ImageWrapper(image: image)
                try storage.setObject(wrapper, forKey: key)
            } catch {
                
            }
        }
    }
    
    // MARK: - Check for unsynced objects
    
    /**
     Check if any unsynced objects exist in the cache
     
     - parameter cache: The cache to search
     - parameter key: The key to look with
     - parameter userToken: The user's domain
     - parameter completion: A function to execute upon completion
     */
    static func checkForUnsyncedObjects(inCache cache: String = "sync", forKey key: String, userToken: String, completion: (() -> Void)? = nil) {
        
        if let storage: Storage<[HATSyncObject<T>]> = CacheManager.getCache(named: cache) {
            
            let networkStatus = NetworkManager()
            if networkStatus.state == .online {
                
                do {
                    
                    let object = try storage.object(forKey: key)
                    
                    if object[0].object != nil {
                        
                        let data: Data? = T.encode(from: [object[0].object!])

                        NetworkManager.createRequest(url: object[0].url, userToken: userToken, data: data, completion: {
                            
                            do {
                                
                                try storage.removeObject(forKey: key)
                                completion?()
                            } catch {
                                
                            }
                        })
                    } else {
                        
                        let rawDict: Dictionary<String, Any>
                        if object[0].data != nil {
                            
                            rawDict = NSKeyedUnarchiver.unarchiveObject(with: object[0].data!) as! Dictionary<String, Any>
                        } else {
                            
                            rawDict = JSON(object[0].dictionary!).dictionaryObject!
                        }

                        let url: URLConvertible = URL(string: object[0].url)!
                        
                        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
                        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
                        let manager = Alamofire.SessionManager(configuration: configuration)
                        
                        manager.request(url, method: .post, parameters: rawDict, encoding: Alamofire.JSONEncoding.default, headers: ["x-auth-token": userToken]).response(completionHandler: { response in
                            
                            do {
                                
                                try storage.removeObject(forKey: key)
                                completion?()
                            } catch {
                                
                            }
                        }).session.finishTasksAndInvalidate()
                    }
                    
                } catch {
                   
                    print("error uploading")
                }
            } else {
                
                completion?()
            }
        }
    }
    
    // MARK: - Check for unsynced images
    
    /**
     Check if any unsynced images exist in the cache
     
     - parameter cache: The cache to search
     - parameter key: The key to look with
     - parameter userToken: The user's domain
     - parameter completion: A function to execute upon completion
     */
    static func checkForUnsyncedImages(inCache cache: String = "sync", forKey key: String, userToken: String, userDomain: String, completion: ((String?) -> Void)? = nil) {
        
        if let storage: Storage<ImageWrapper> = CacheManager.getCache(named: cache) {
            
            let networkStatus = NetworkManager()
            if networkStatus.state == .online {
                
                if let image = CacheManager.retrieveImage(fromCache: cache, forKey: key) {
                    
                    HATFileService.uploadFileToHATWrapper(
                        token: userToken,
                        userDomain: userDomain,
                        fileToUpload: image,
                        tags: ["iphone", "profile"],
                        progressUpdater: nil,
                        completion: { file, token in
                            
                            HATFileService.makeFilePublic(
                                fileID: file.fileID,
                                token: userToken,
                                userDomain: userDomain,
                                successCallback: { _ in return },
                                errorCallBack: { _ in return })
                            
                            do {
                                
                                try storage.removeObject(forKey: key)
                                completion?(file.fileID)
                            } catch {
                                
                            }
                        },
                        errorCallBack: nil)
                } else {
                    
                    completion?(nil)
                }
            } else {
                
                completion?(nil)
            }
        } else {
            
            completion?(nil)
        }
    }
    
    // MARK: - Remove objects
    
    /**
     Remove all objects from the cache specified
     
     - parameter cache: The cache to delete
     */
    static func removeAllObjects(fromCache cache: String) {
        
        if let storage: Storage<[T]> = CacheManager.getCache(named: cache) {
            
            do {
                
                try storage.removeAll()
            } catch {
                
            }
        }
        if let storage: Storage<[[T]]> = CacheManager.getCache(named: cache) {
            
            do {
                
                try storage.removeAll()
            } catch {
                
            }
        }
        if let storage: Storage<[HATSyncObject<T>]> = CacheManager.getCache(named: cache) {
            
            do {
                
                try storage.removeAll()
            } catch {
                
            }
        }
        if let storage: Storage<ImageWrapper> = CacheManager.getCache(named: cache) {
            
            do {
                
                try storage.removeAll()
            } catch {
                
            }
        }
    }
}
