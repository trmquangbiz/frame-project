//
//  RxSampleObject.swift
//  frameproject
//
//  Created by Quang Trinh on 19/09/2023.
//

import Foundation
import RxSwift
import ObjectMapper

class RxSampleObject: Mappable {
    var id: Int = 0
    var name: String = ""
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    required init?(map: Map) {
        guard let _ = map.JSON["id"] as? Int else {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
