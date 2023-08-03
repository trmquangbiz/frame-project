//
//  Realm.swift
//  frameproject
//
//  Created by Quang Trinh on 29/07/2023.
//

import Foundation
import RealmSwift
extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) {
        if isInWriteTransaction == true {
            try! block()
        } else {
            try! write(block)
        }
    }
    
    func deleteAll(except types: Object.Type...) {
        safeWrite {
            self.configuration.objectTypes?.filter{ type in types.contains{ $0 == type } == false}.forEach{ objectType in
                if let objectType = objectType as? Object.Type {
                    let list = objects(objectType)
                    delete(list)
                }
            }
        }
    }
    
    public func safeAsyncWrite(block: @escaping (()->()), completionBlock: ((Swift.Error?)->())?) {
        writeAsync(block, onComplete: completionBlock)
    }
}

//extension Results where Element: RealmCollectionValue {
//    func safeObserve(_ block: @escaping (RealmSwift.RealmCollectionChange<RealmSwift.Results<Element>>) -> Void, token: @escaping ((NotificationToken) ->())) {
//        if let realm = realm, realm.isInWriteTransaction {
//            DispatchQueue.main.async {
//                let notificationToken = observe { (changes) in
//                    DispatchQueue.main.async {
//                        block(changes)
//                    }
//
//                }
//                token(notificationToken)
//            }
//        }
//        else {
//            let notificationToken = observe { (changes) in
//                DispatchQueue.main.async {
//                    block(changes)
//                }
//            }
//            token(notificationToken)
//        }
//    }
//}

extension RealmCollection where Element: RealmCollectionValue {
    func safeObserve(_ block: @escaping (RealmSwift.RealmCollectionChange<Self>) -> Void, token: @escaping ((NotificationToken) ->())) {
        if let realm = realm, realm.isInWriteTransaction {
            DispatchQueue.main.async {
                let notificationToken = observe { (changes) in
                    DispatchQueue.main.async {
                        block(changes)
                    }
                    
                }
                token(notificationToken)
            }
        }
        else {
            let notificationToken = observe { (changes) in
                DispatchQueue.main.async {
                    block(changes)
                }
            }
            token(notificationToken)
        }
    }
}

extension Object {
    func safeObserve(_ block: @escaping (RLMObjectChange) -> Void, token: @escaping ((NotificationToken) ->())) {
        if let realm = realm, realm.isInWriteTransaction {
            DispatchQueue.main.async { [weak self ]in
                if let weakSelf = self {
                    let notificationToken = weakSelf.observe { (changes) in
                        DispatchQueue.main.async {
                            block(changes)
                        }
                    }
                    token(notificationToken)
                }
            }
        }
        else {
            let notificationToken = observe { (changes) in
                DispatchQueue.main.async {
                    block(changes)
                }
            }
            token(notificationToken)
        }
    }
}

extension List {
    func copyObject(_ copyMethod: (_ object: Element) -> Element) -> List<Element> {
        let list = List<Element>()
        self.forEach { value in
            list.append(copyMethod(value))
        }
        return list
    }
}
