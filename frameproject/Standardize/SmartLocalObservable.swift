//
//  SmartLocalObservable.swift
//  frameproject
//
//  Created by Quang Trinh on 29/07/2023.
//

import Foundation
import ObjectMapper
import RealmSwift
import Realm

class SmartLocalObservable<T: Mappable & Object>: SmartObservableProtocol {
    let realm = try! Realm()
    internal final var _obj: T? {
        didSet {
            
        }
    }
    var obj: T? {
        get {
            return _obj
        }
    }
    
    var preprocessObject: ((T) -> (T))?
    
    internal final var _primaryKeyValue: Any
    
    private var notificationToken: NotificationToken?
    
    var networkDataAPIManager: APIServiceManagerProtocol = APIServiceManager.shared
    
    deinit {
        if let notificationToken = notificationToken {
            notificationToken.invalidate()
        }
    }
    internal final var _remotePath: APIPath?
    final var remotePath: APIPath? {
        get {
            return _remotePath
        }
    }
    internal var subscribeBlock: ((T?) -> ())?
    
    init(primaryKeyValue: Any, obj: T? = nil) {
        self._primaryKeyValue = primaryKeyValue
        self._obj = obj
    }
    
    func fetchLocal() {
        _obj = realm.object(ofType: T.self, forPrimaryKey: _primaryKeyValue)
        registerChange()
        if let block = subscribeBlock {
            block(_obj)
        }
    }
    
    func registerChange() {
        if let obj = _obj {
            obj.safeObserve {[weak self] _ in
                if let weakSelf = self {
                    weakSelf.triggerSubscribeBlock()
                }
            } token: { [weak self] token in
                if let weakSelf = self {
                    weakSelf.notificationToken = token
                }
            }

        }
    }
    
    func fetchRemote(queryParams: [String : Any]?, forAuthenticate: Bool = false, onSuccess successCompletion: (() -> ())?, onFail failCompletion: ((Int, Any?) -> ())?) {
        if let remotePath = remotePath {
            networkDataAPIManager.getObject(endPoint: remotePath.path,
                                            queryParams: queryParams,
                                            extraHeaders: nil,
                                            forAuthenticate: forAuthenticate,
                                            objectType: T.self,
                                            completion: {[weak self] response in
                switch response {
                case .success(statusCode: _, responseObject: let responseObject):
                    if var responseObject = responseObject {
                        if let weakSelf = self, let process = weakSelf.preprocessObject {
                            responseObject = process(responseObject)
                        }
                        let realm = try! Realm()
                        realm.safeWrite {
                            realm.add(responseObject, update: .all)
                        }
                        if let weakSelf = self {
                            if weakSelf._obj == nil {
                                weakSelf.fetchLocal()
                            }
                        }
                    }
                    if let completion = successCompletion {
                        completion()
                    }
                case .fail(statusCode: let statusCode, errorMsg: let errorMsg):
                    if statusCode == 404 {
                        if let weakSelf = self, let obj = weakSelf._obj {
                            weakSelf._obj = nil
                            let realm = try! Realm()
                            realm.safeWrite {
                                realm.delete(obj)
                            }
                        }
                    }
                    if let completion = failCompletion {
                        completion(statusCode, errorMsg)
                    }
                    return
                }
            },
                                            functionName: #function,
                                            file: #file,
                                            fileID: #fileID,
                                            line: #line)
        }
    }
    
    func set(remotePath: APIPath) -> Self {
        _remotePath = remotePath
        return self
    }
    
    func set(preprocessObject: ((T) -> (T))?) -> Self {
        self.preprocessObject = preprocessObject
        return self
    }
    
    func subscribe(_ block: @escaping ((T?) -> ())) -> Self {
        subscribeBlock = block
        return self
    }
    
    func change(remotePath path: APIPath?) {
        _remotePath = path
    }
    
    func change(subscribeBlock block: @escaping ((T?) -> ())) {
        subscribeBlock = block
    }
    
    private func didSetObj() {
        triggerSubscribeBlock()
    }
    
    func setNetworkDataAPIManager(_ value: APIServiceManagerProtocol) {
        #if DEBUG
        self.networkDataAPIManager = value
        #endif
    }
    
    private func triggerSubscribeBlock() {
        if let block = subscribeBlock {
            block(self._obj)
        }
    }
    final func set(obj: T) {
        self._obj = obj
    }
}
