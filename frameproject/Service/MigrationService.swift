//
//  MigrationService.swift
//  frameproject
//
//  Created by Quang Trinh on 20/08/2023.
//

import Foundation
import RealmSwift

class MigrationService {
    static let sharedInstance: MigrationService = {
        var manager = MigrationService()
        return manager
    }()
    
    let expiredDate = Date().addingTimeInterval(-(90*86400)) //90 days
    func migrate() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    migration.enumerateObjects(ofType: SampleObject.className()) { oldObject, newObject in
                        newObject!["addedAt"] = Date()
                    }
                }
            }
        )
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        _ = try! Realm()
    }
    
    func deleteExpiredObjects() {
        let realm = try! Realm()
        let configuration = realm.configuration
        realm.safeWrite {
            configuration.objectTypes?.filter{ type in
                return type is ExpirePolicyRealmObject
            }.forEach{ objectType in
                if let objectType = objectType as? Object.Type{
                    let list = realm.objects(objectType.self).filter("addedAt < %@", expiredDate)
                }
            }
        }
    }
}
