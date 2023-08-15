//
//  SmartObservableProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 29/07/2023.
//

import Foundation

protocol SmartObservableProtocol<T>: AnyObject {
    associatedtype T
    var _obj: T? {get set}
    var obj: T? {get}
    var _remotePath: APIPath? {get set}
    var subscribeBlock: ((T?)->())? {get set}
    func fetchLocal()
    func fetchRemote(queryParams: [String: Any]?,
                     onSuccess successCompletion: (()->())?,
                     onFail failCompletion: ((_ errorCode: Int, _ errorMsg: Any?)->())?)
    func set(remotePath: APIPath) -> Self
    func subscribe(_ block: @escaping ((T?)->())) -> Self
    func change(remotePath path: APIPath?)
    func change(subscribeBlock block: @escaping ((T?)->()))
}
