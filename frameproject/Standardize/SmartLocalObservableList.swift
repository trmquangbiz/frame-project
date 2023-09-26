//
//  SmartLocalObservableList.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2023.
//

import Foundation
import ObjectMapper
import RealmSwift
import Realm

class SmartLocalObservableList<T: RealmCollection> where T.Element: RealmSwiftObject & Mappable  {
    typealias E = T.Element
    
    public internal(set) final var obj: T?
    public internal(set) final var remotePath: APIPath?
    
    var predicate: String?
    var sortConditions: [RealmSwift.SortDescriptor] = []
    var subscribeBlock: ((RealmCollectionChange<T>) -> ())?
    var currentPagination: [String: Any]?
    var preprocessReloadedObject: (([E]) -> [E])?
    var preprocessLoadMoreObject: (([E], Int) -> [E])?
    var networkDataAPIManager: APIServiceManagerProtocol = APIServiceManager.shared
    private var notificationToken: NotificationToken?
    
    init(predicate: String?, sortConditions: [RealmSwift.SortDescriptor]) {
        self.predicate = predicate
        self.sortConditions = sortConditions
    }
    
    
    init(initialObj: T) {
        self.obj = initialObj
    }
    
    deinit {
        if let notificationToken = notificationToken {
            notificationToken.invalidate()
        }
    }
    
    
    
    func fetchLocal() {
        let realm = try! Realm()
        if let predicate = predicate {
            obj = realm.objects(E.self).filter(predicate).sorted(by: sortConditions) as? T
            
        }
        else {
            obj = realm.objects(E.self).sorted(by: sortConditions) as? T
        }
        if let obj = obj {
            obj.safeObserve {[weak self] changes in
                if let weakSelf = self, let block = weakSelf.subscribeBlock {
                    block(changes)
                }
            } token: {[weak self] token in
                if let weakSelf = self {
                    weakSelf.notificationToken = token
                }
            }
        }
       
    }
    
    func fetchRemote(queryParams: [String : Any]?, onSuccess successCompletion: (() -> ())?, onFail failCompletion: ((Int, Any?) -> ())?, onEmpty emptyCompletion: (()->())?) {
        guard let remotePath = remotePath else {
            if let completion = failCompletion {
                completion(9999, "Remote path is not set")
            }
            return
        }
        currentPagination = nil
        networkDataAPIManager.getListObject(endPoint: remotePath.path,
                                            queryParams: queryParams,
                                            extraHeaders: nil,
                                            forAuthenticate: false,
                                            objectType: E.self,
                                            completion: {[weak self] response  in
            switch response {
            case .success(statusCode: _, responseObject: let responseObject, pagination: let pagination):
                if let weakSelf = self {
                    weakSelf.currentPagination = pagination
                }
                if var list = responseObject {
                    if let weakSelf = self, let preprocessObject = weakSelf.preprocessReloadedObject {
                        list = preprocessObject(list)
                    }
                    if let primaryProperty = E.primaryKey() {
                        let key = primaryProperty
                        var listExistedId: [Any] = []
                        list.forEach { node in
                            if let value = node.value(forKey: key) {
                                listExistedId.append(value)
                            }
                        }
                        let realm = try! Realm()
                        var notExistedList: Results<E> = realm.objects(E.self).filter("NOT (\(key) IN %@)", listExistedId)
                        if let weakSelf = self, let predicate = weakSelf.predicate {
                            notExistedList = realm.objects(E.self).filter(predicate).filter("NOT (\(key) IN %@)", listExistedId)
                        }
                        realm.safeWrite {
                            realm.add(list, update: .all)
                            realm.delete(notExistedList)
                        }
                    }
                    else {
                        let realm = try! Realm()
                        realm.safeWrite {
                            realm.add(list)
                        }
                    }
                    if let completion = successCompletion {
                        completion()
                    }
                }
                else {
                    if let weakSelf = self, let list = weakSelf.obj{
                        let realm = try! Realm()
                        realm.safeWrite {
                            realm.delete(list)
                        }
                    }
                    if let completion = emptyCompletion {
                        completion()
                    }
                }
            case .fail(statusCode: let statusCode, errorMsg: let errorMsg):
                if statusCode == 404 {
                    if let weakSelf = self, let list = weakSelf.obj{
                        let realm = try! Realm()
                        realm.safeWrite {
                            realm.delete(list)
                        }
                    }
                    if let completion = emptyCompletion {
                        completion()
                    }
                }
                else {
                    if let completion = failCompletion {
                        completion(statusCode, errorMsg)
                    }
                }
            }
        })
    }
    
    func loadMore(queryParams: [String : Any]?, onSuccess successCompletion: (() -> ())?, onFail failCompletion: ((Int, Any?) -> ())?, onEmpty emptyCompletion: (()->())?) {
        guard let remotePath = remotePath else {
            if let completion = failCompletion {
                completion(9999, "Remote path is not set")
            }
            return
        }
        var newQueryParams: [String: Any] = [:]
        if let queryParams = queryParams {
            newQueryParams = queryParams
        }
        guard let currentPagination = currentPagination else {
            if let completion = failCompletion {
                completion(9999, "Pagination is null")
            }
            return
        }
        // set pagination query param here
        networkDataAPIManager.getListObject(endPoint: remotePath.path,
                                            queryParams: newQueryParams,
                                            extraHeaders: nil,
                                            forAuthenticate: false,
                                            objectType: E.self,
                                            completion: {[weak self] response in
            switch response {
            case .success(statusCode: _, responseObject: let responseObject, pagination: let pagination):
                if let weakSelf = self {
                    weakSelf.currentPagination = pagination
                }
                if var list = responseObject {
                    let realm = try! Realm()
                    if let weakSelf = self, let preprocessObject = weakSelf.preprocessLoadMoreObject {
                        var listCount = 0
                        if let predicate = weakSelf.predicate {
                            listCount = realm.objects(E.self).filter(predicate).count
                        }
                        else {
                            listCount = realm.objects(E.self).count
                        }
                        list = preprocessObject(list, listCount)
                    }
                    if let _ = E.primaryKey() {
                        realm.safeWrite {
                            realm.add(list, update: .all)
                        }
                    }
                    else {
                        realm.safeWrite {
                            realm.add(list)
                        }
                    }
                    if let completion = successCompletion {
                        completion()
                    }
                }
                else {
                    if let completion = emptyCompletion {
                        completion()
                    }
                }
            case .fail(statusCode: let statusCode, errorMsg: let errorMsg):
                if statusCode == 404 {
                    if let completion = emptyCompletion {
                        completion()
                    }
                }
                else {
                    if let completion = failCompletion {
                        completion(statusCode, errorMsg)
                    }
                }
                
            }
            
        })
    }
    
    func set(remotePath: APIPath) -> Self {
        self.remotePath = remotePath
        return self
    }
    
    func set(predicate: String) -> Self {
        self.predicate = predicate
        return self
    }
    
    func set(preprocessReloadedObject: (([E]) -> [E])?) -> Self {
        self.preprocessReloadedObject = preprocessReloadedObject
        return self
    }
    
    func set(preprocessLoadMoreObject: (([E], Int) -> [E])?) -> Self {
        self.preprocessLoadMoreObject = preprocessLoadMoreObject
        return self
    }

    func subscribe(_ block: @escaping ((RealmCollectionChange<T>) -> ())) -> Self {
        self.subscribeBlock = block
        if let obj = obj {
            obj.safeObserve {[weak self] changes in
                if let weakSelf = self, let block = weakSelf.subscribeBlock {
                    block(changes)
                }
            } token: {[weak self] token in
                if let weakSelf = self {
                    weakSelf.notificationToken = token
                }
            }

        }
        return self
    }
    
    func change(remotePath path: APIPath?) {
        self.remotePath = path
    }
    
    func change(subscribeBlock block: @escaping ((T?) -> ())) {
        if let notificationToken = notificationToken {
            notificationToken.invalidate()
            self.notificationToken = nil
        }
        if let obj = obj {
            obj.safeObserve {[weak self] changes in
                if let weakSelf = self, let block = weakSelf.subscribeBlock {
                    block(changes)
                }
            } token: {[weak self] token in
                if let weakSelf = self {
                    weakSelf.notificationToken = token
                }
            }

        }
    }
    
    
    func setNetworkDataAPIManager(_ value: APIServiceManagerProtocol) -> Self {
        #if DEBUG
        self.networkDataAPIManager = value
        #endif
        return self
    }
    
}
