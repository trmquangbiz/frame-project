//
//  SmartObservable.swift
//  frameproject
//
//  Created by Quang Trinh on 28/07/2023.
//

import Foundation
import ObjectMapper

class SmartObservable<T: Mappable>: SmartObservableProtocol {
    
    
    private final var _primaryKeyValue: Any?
    internal final var _obj: T? {
        didSet {
            didSetObj()
        }
    }
    
    final var obj: T? {
        get {
            return _obj
        }
    }
    
    final var primaryKeyValue: Any? {
        get {
            return _primaryKeyValue
        }
    }
    
    var preprocessObject: ((T)->(T))? = nil
    
    internal final var subscribeBlock: ((T?)->())?
    
    internal final var _remotePath: APIPath?
    
    final var remotePath: APIPath? {
        get {
            return _remotePath
        }
    }
    
    init(initObj: T? = nil, primaryKeyValue: Any? = nil) {
        self._obj = initObj
        self._primaryKeyValue = primaryKeyValue
    }
    private func didSetObj() {
        triggerSubscribeBlock()
    }
    
    final func set(obj: T) {
        self._obj = obj
    }
    func set(remotePath: APIPath) -> Self {
        _remotePath = remotePath
        return self
    }
    func set(preprocessObject: ((T)->(T))?) -> Self {
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
    
    private func triggerSubscribeBlock() {
        if let block = subscribeBlock {
            block(self._obj)
        }
    }
    
    func fetchLocal() {
    }
    
    func fetchRemote(queryParams: [String: Any]? = nil, onSuccess successCompletion: (()->())? = nil, onFail failCompletion: ((_ errorCode: Int, _ errorMsg: Any?)->())? = nil) {
        if let remotePath = remotePath {
            APIServiceManager.shared.getObject(endPoint: remotePath.path,
                                               queryParams: queryParams,
                                               objectType: T.self) {[weak self] isSuccess, statusCode, responseObject, errorMsg in
                guard isSuccess else {
                    if statusCode == 404 {
                        if let weakSelf = self {
                            weakSelf._obj = nil
                        }
                    }
                    if let completion = failCompletion {
                        completion(statusCode, errorMsg)
                    }
                    return
                }
                if var responseObject = responseObject {
                    if let weakSelf = self, let process = weakSelf.preprocessObject {
                        responseObject = process(responseObject)
                    }
                    if let weakSelf = self {
                        weakSelf.set(obj: responseObject)
                    }
                }
                if let completion = successCompletion {
                    completion()
                }
            }
        }
    }
}
