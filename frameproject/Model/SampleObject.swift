//
//  SampleObject.swift
//  frameproject
//
//  Created by Quang Trinh on 29/07/2023.
//

import Foundation
import RealmSwift
import ObjectMapper

class SampleObject: Object, Mappable, ExpirePolicyRealmObject {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String?
    @Persisted var orderNumber: Int = 0
    @Persisted var group: String = ""
    
    @Persisted var addedAt: Date = Date()
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
    func makeCompleteData(group: String, orderNumber: Int) -> Self {
        self.group = group
        self.orderNumber = orderNumber
        return self
    }
    
}

extension SampleObject {
    static func makeSampleObject(id: Int) -> SmartLocalObservable<SampleObject> {
        let obj = SmartLocalObservable<SampleObject>.init(primaryKeyValue: id)
            .set(remotePath: .getSampleDetail(sampleId: id))
            .set(preprocessObject: { obj in
                obj.group = "sampleList"
                return obj
            })
        return obj
    }
    static func makeSampleListObservableList() -> SmartLocalObservableList<Results<SampleObject>> {
        let list = SmartLocalObservableList<Results<SampleObject>>.init(predicate: "group = 'sampleList'",
                                                                        sortConditions: [SortDescriptor.init(keyPath: "orderNumber", ascending: true)])
                                           .set(remotePath: .getSampleList)
                                           .set(preprocessReloadedObject: { rawObjectList in
                                               for i in 0..<rawObjectList.count {
                                                   rawObjectList[i].orderNumber = i
                                                   rawObjectList[i].group = "sampleList"
                                               }
                                               return rawObjectList
                                           })
                                           .set(preprocessLoadMoreObject: { rawObjectList, listCount in
                                               let fromNumber = listCount
                                               for i in 0..<rawObjectList.count {
                                                   rawObjectList[i].orderNumber = fromNumber + i
                                                   rawObjectList[i].group = "sampleList"
                                               }
                                               return rawObjectList
                                           })
        return list
    }
}
