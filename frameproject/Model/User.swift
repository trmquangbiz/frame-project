//
//  User.swift
//  frameproject
//
//  Created by Quang Trinh on 06/09/2023.
//

import Foundation
import ObjectMapper
import RealmSwift

class User: Object, Mappable {
    
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String = ""
    
    required convenience init?(map: ObjectMapperMap) {
        self.init()
        guard let _ = map.JSON["id"] as? Int else {
            return nil
        }
    }
    
    func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

extension User {
    static var current: User? {
        get {
            if let userId = AuthenticationService.shared.currentUserId {
                let realm = try! Realm()
                return realm.object(ofType: User.self, forPrimaryKey: userId)
            }
            return nil
        }
    }
    
    
}
