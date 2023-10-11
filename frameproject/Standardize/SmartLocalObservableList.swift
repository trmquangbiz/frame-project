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
    var localDataAPIManager = RealmLocalListFetcher<T>.init()
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
        do {
            obj = try localDataAPIManager.get(predicate, sortDescriptors: sortConditions)
        }
        catch {
            
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
                if let `self` = self {
                    self.currentPagination = pagination
                }
                if var list = responseObject {
                    if let `self` = self, let preprocessObject = self.preprocessReloadedObject {
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
                        if let `self` = self {
                            do {
                                try self.localDataAPIManager.write(from: list)
                                if let predicate = self.predicate {
                                    try self.localDataAPIManager.delete("(\(predicate)) AND (NOT (\(key) IN %@))", listExistedId)
                                }
                                else {
                                    try self.localDataAPIManager.delete("NOT (\(key) IN %@)", listExistedId)
                                }
                            }
                            catch {
                                
                            }
                            
                        }
                    }
                    else {
                        if let `self` = self {
                            do {
                                try self.localDataAPIManager.write(from: list)
                            }
                            catch {
                                
                            }
                        }
                    }
                    if let completion = successCompletion {
                        completion()
                    }
                }
                else {
                    if let `self` = self, let list = self.obj{
                        do {
                            try self.localDataAPIManager.delete(list)
                        }
                        catch {
                            
                        }
                    }
                    if let completion = emptyCompletion {
                        completion()
                    }
                }
            case .fail(statusCode: let statusCode, errorMsg: let errorMsg):
                if statusCode == 404 {
                    if let `self` = self, let list = self.obj{
                        do {
                            try self.localDataAPIManager.delete(list)
                        } catch {
                            
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
                    if let `self` = self {
                        if let preprocessObject = self.preprocessLoadMoreObject {
                            var listCount = 0
                            do {
                                let existedList = try self.localDataAPIManager.get(self.predicate, sortDescriptors: [])
                                listCount = existedList.count
                            }
                            catch {
                                
                            }
                            list = preprocessObject(list, listCount)
                        }
                        if let _ = E.primaryKey() {
                            do {
                                try self.localDataAPIManager.write(from: list)
                            }
                            catch {
                                
                            }
                        }
                        if let completion = successCompletion {
                            completion()
                        }
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
