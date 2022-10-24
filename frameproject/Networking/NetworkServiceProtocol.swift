//
//  NetworkServiceProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 20/08/2022.
//

import Foundation
typealias NetworkCompletionHandler = (_ error: ErrorData?, _ response: ResponseData?)->()
protocol NetworkServiceProtocol: AnyObject {
    
    var config: NetworkServiceConfigProtocol {get set}
    
    
    func get(url: String,
             headers: [String: String],
             queryParam: [String: Any],
             forAuthenticate: Bool,
             completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo
    func post(url: String,
              headers: [String: String],
              requestBody: [String: Any],
              forAuthenticate: Bool,
              completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo
    func put(url: String,
             headers: [String: String],
             requestBody: [String: Any],
             forAuthenticate: Bool,
             completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo
    func delete(url: String,
                headers:[String: String],
                completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo
    func download(url: String,
                  headers: [String: String],
                  params: [String: AnyObject],
                  dataType: DataType,
                  completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo
    func upload(url: String,
                headers: [String: String],
                data: Data,
                imagePathInfos: ImagePathInfo,
                completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo
}


