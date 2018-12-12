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

import RealmSwift

// MARK: Class

// swiftlint:disable force_try
/// Static Realm Helper methods
internal class RealmManager: NSObject {

    // MARK: - Get realm
    
    /**
     Get the default Realm DB representation
     
     - returns: The default Realm object
     */
    class func getRealm() -> Realm? {
        
        // Get the default Realm
        do {
            
            return try Realm()
        } catch {
            
            return nil
        }
    }
    
    /**
     Get in memory Realm DB representation
     
     - returns: The in memory Realm object
     */
    class func getInMemoryRealm() -> Realm? {
        
        // Get the default Realm
        do {
            
            return try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
        } catch {
            
            return nil
        }
    }
    
    // MARK: - Add data
    
    /**
     Adds data in form of lat/lng
     
     - parameter latitude: The latitude value of the point
     - parameter longitude: The longitude value of the point
     - parameter accuracy: The accuracy of the point
     
     - returns: current item count
     */
    class func addData<T: Object>(type: [T]) {
        
        // Get the default Realm
        if let realm = self.getRealm() {
            
            // Persist your data easily
            do {
                try realm.write {
                    
                    realm.add(type)
                }
            } catch {
                
                print(error)
            }
        }
    }
    
    /**
     Adds data in form of lat/lng
     
     - parameter latitude: The latitude value of the point
     - parameter longitude: The longitude value of the point
     - parameter accuracy: The accuracy of the point
     
     - returns: current item count
     */
    class func addDataToInMemoryRealm<T: Object>(type: [T]) {
        
        // Get the default Realm
        if let realm = self.getInMemoryRealm() {
            
            // Persist your data easily
            do {
                try realm.write {
                    
                    realm.add(type)
                }
            } catch {
                
                print(error)
            }
        }
    }
    
    class func removeObject<T: Object>(_ object: T) {
        
        // Get the default Realm
        if let realm = self.getRealm(), !object.isInvalidated {
            
            do {
                
                try realm.write {
                    
                    realm.delete(object)
                }
            } catch {
                
                print(error)
            }
        }
    }
    
    class func removeObjects<T: Object>(_ objects: [T]) {
        
        // Get the default Realm
        if let realm: Realm = self.getRealm() {
            
            do {
                
                try realm.write {
                    
                    for object: T in objects where !object.isInvalidated {
                        
                        print("deleting from realm: \(object)")
                        realm.delete(object)
                    }
                }
            } catch {
                
                print(error)
            }
        }
    }
    
    // MARK: - Get results from realm
    
    /**
     Gets a list of results from the current Realm DB object and filters by the predicate
     
     - parameter predicate: The predicate used to filter the data
     
     - returns: list of datapoints
     */
    class func getResults<T: Object>(orderBy: String, ascending: Bool) -> Results<T>? {
        
        // Get the default Realm
        if let realm: Realm = self.getRealm() {
            
            let sortProperties = [SortDescriptor(keyPath: orderBy, ascending: ascending)]
            
            return realm.objects(T.self).sorted(by: sortProperties)
        }
        
        return nil
    }
    
    /**
     Gets the most recent DataPoint
     
     - returns: A DataPoint object
     */
    class func getLastObject<T: Object>(type: T.Type) -> T? {
        
        // Get the default Realm
        if let realm: Realm = self.getRealm() {
            
            return realm.objects(type.self).last
        }
        
        return nil
    }
    
    class func migrateDB() {
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion == 0) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                    migration.enumerateObjects(ofType: LocationObject.className()) { oldObject, newObject in
                        // combine name fields into a single field
                        newObject!["dateSynced"] = -1
                        newObject!["syncStatus"] = "synced"
                        newObject!["dateSyncStatusChanged"] = -1
                    }
                } else if (oldSchemaVersion == 1) {
                    
                    migration.enumerateObjects(ofType: LocationObject.className()) { oldObject, newObject in
                        // combine name fields into a single field
                        newObject!["syncStatus"] = "synced"
                        newObject!["dateSyncStatusChanged"] = -1
                    }
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let _ = try! Realm()
    }
    // swiftlint:enable force_try
}
