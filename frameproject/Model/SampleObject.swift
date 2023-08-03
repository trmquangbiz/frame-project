//
//  SampleObject.swift
//  frameproject
//
//  Created by Quang Trinh on 29/07/2023.
//

import Foundation
import RealmSwift
import ObjectMapper

class SampleObject: Object, Mappable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String?
    @Persisted var orderNumber: Int = 0
    @Persisted var group: String = ""
    
    required convenience init?(map: ObjectMapperMap) {
        self.init()
        guard let _ = map.JSON["id"] as? Int else {
            return nil
        }
    }
    
    func mapping(map: ObjectMapperMap) {
        id <- map["id"]
        name <- map["name"]
    }
    
}
