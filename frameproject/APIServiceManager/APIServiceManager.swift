//
//  APIServiceManager.swift
//  frameproject
//
//  Created by Quang Trinh on 28/10/2022.
//

import Foundation
import ObjectMapper
import RealmSwift


class APIServiceManager: APIServiceManagerProtocol {
    
    let config = Configuration.shared
    
    static let shared: APIServiceManager = {
        let instance = APIServiceManager()
        return instance
    }()
    
    init() {
        networkManager.taskDelegate = self
    }
    var networkManager: NetworkManager = NetworkManager()
    
    private func getBaseRequestURL() -> String {
        return config.baseRequestURL
    }
    
    /**
     currentRequestURLString
     
     - parameter endPoint: <#endPoint description#>
     
     - returns: <#return value description#>
     */
    func currentRequestURLString(fromEndPoint endPoint: String) -> String {
        let trimmedEndpoint = endPoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return self.getBaseRequestURL() + (trimmedEndpoint.count > 0 ? "/\(trimmedEndpoint)" : trimmedEndpoint)
    }
    
    
    func createParameters(_ parameters: [String: Any]?) -> [String: Any] {
        var newParamters: [String: Any] = [:]
        if let parameters = parameters {
            let keys = parameters.keys
            for key in keys {
                newParamters.updateValue(parameters[key]!, forKey: key)
            }
        }
        return newParamters
    }
    
    func currentHeaderForRequest(extraHeaders: [String:String]?) -> [String: String] {
        var header: [String:String] = [:]
        if let authorizationToken = getAuthorizationToken() {
            header[Constant.kHeaderAccessToken] = authorizationToken
        }
        header["Content-Type"] = "application/json"
        if let extraHeaders = extraHeaders {
            for key in extraHeaders.keys {
                if let value = extraHeaders[key] {
                    header[key] = value
                }
            }
        }
        return header
    }
    /// get current authorization token
    ///
    ///
    func getAuthorizationToken() -> String? {
        return AuthenticationService.shared.accessToken
    }
    
    func get(url: String,
             queryParams: [String: Any]?,
             extraHeaders: [String: String]? = nil,
             forAuthenticate: Bool = false,
             completionHandler: @escaping NetworkCompletionHandler,
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        let requestStr = url
        let params = createParameters(queryParams)
        let headers = currentHeaderForRequest(extraHeaders: extraHeaders)
        networkManager.get(url: requestStr,
                           headers: headers,
                           queryParam: params,
                           forAuthenticate: forAuthenticate,
                           completionHandler: completionHandler,
                           functionName: functionName,
                           file: file,
                           fileID: fileID,
                           line: line)
    }
    
    func post(url: String,
              requestBody: [String: Any]?,
              extraHeaders: [String: String]? = nil,
              forAuthenticate: Bool = false,
              completionHandler: @escaping NetworkCompletionHandler,
              functionName: String = #function,
              file: String = #file,
              fileID: String = #fileID,
              line: Int = #line) {
        let requestStr = url
        let body = createParameters(requestBody)
        let headers = currentHeaderForRequest(extraHeaders: extraHeaders)
        networkManager.post(url: requestStr,
                            headers: headers,
                            requestBody: body,
                            forAuthenticate: forAuthenticate,
                            completionHandler: completionHandler,
                            functionName: functionName,
                            file: file,
                            fileID: fileID,
                            line: line)
        
    }
    
    func put(url: String,
             requestBody: [String: Any]?,
             extraHeaders: [String: String]? = nil,
             forAuthenticate: Bool = false,
             completionHandler: @escaping NetworkCompletionHandler,
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        let requestStr = url
        let body = createParameters(requestBody)
        let headers = currentHeaderForRequest(extraHeaders: extraHeaders)
        networkManager.put(url: requestStr,
                            headers: headers,
                            requestBody: body,
                            forAuthenticate: forAuthenticate,
                            completionHandler: completionHandler,
                            functionName: functionName,
                            file: file,
                            fileID: fileID,
                            line: line)
        
    }
    
    func delete(url: String,
             extraHeaders: [String: String]? = nil,
             forAuthenticate: Bool = false,
             completionHandler: @escaping NetworkCompletionHandler,
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        let requestStr = url
        let headers = currentHeaderForRequest(extraHeaders: extraHeaders)
        networkManager.delete(url: requestStr,
                            headers: headers,
                            completionHandler: completionHandler,
                            functionName: functionName,
                            file: file,
                            fileID: fileID,
                            line: line)
        
    }
    
    func getObject<T: Mappable>(endPoint: String,
                                queryParams: [String: Any]?,
                                extraHeaders: [String: String]? = nil,
                                forAuthenticate: Bool = false,
                                objectType: T.Type,
                                completion: @escaping ((Response<T>) -> ())) {
        get(url: currentRequestURLString(fromEndPoint: endPoint),
            queryParams: queryParams,
            extraHeaders: extraHeaders,
            forAuthenticate: forAuthenticate,
            completionHandler: {[weak self] errorPackage, responsePackage in
            if let weakSelf = self {
                weakSelf.handleNetworkCompletionHandler(responsePackage: responsePackage, errorPackage: errorPackage, objectType: objectType, completion: completion)
            }
        })
    }
    
    
    func getListObject<T: Mappable>(endPoint: String,
                                    queryParams: [String: Any]?,
                                    extraHeaders: [String: String]? = nil,
                                    forAuthenticate: Bool = false,
                                    objectType: T.Type,
                                    completion: @escaping ((ResponseList<T>)->())) {
        get(url: currentRequestURLString(fromEndPoint: endPoint),
            queryParams: queryParams,
            extraHeaders: extraHeaders,
            forAuthenticate: forAuthenticate,
            completionHandler: {[weak self] errorPackage, responsePackage in
            if let weakSelf = self {
                weakSelf.handleNetworkCompletionHandler(responsePackage: responsePackage, errorPackage: errorPackage, objectType: objectType, completion: completion)
            }
        })
    }
    
    func postAndResponseObject<T: Mappable>(endPoint: String,
                                            requestBody: [String: Any]?,
                                            extraHeaders: [String: String]? = nil,
                                            forAuthenticate: Bool = false,
                                            objectType: T.Type,
                                            completion: @escaping ((Response<T>)->())) {
        post(url: currentRequestURLString(fromEndPoint: endPoint),
             requestBody: requestBody,
             extraHeaders: extraHeaders,
             forAuthenticate: forAuthenticate,
             completionHandler: {[weak self] errorPackage, responsePackage in
            if let weakSelf = self {
                weakSelf.handleNetworkCompletionHandler(responsePackage: responsePackage, errorPackage: errorPackage, objectType: objectType, completion: completion)
            }
        })
        
    }
    
    func postAndResponseListObject<T: Mappable>(endPoint: String,
                                                requestBody: [String: Any]?,
                                                extraHeaders: [String: String]? = nil,
                                                forAuthenticate: Bool = false,
                                                objectType: T.Type,
                                                completion: @escaping ((ResponseList<T>)->())) {
        post(url: currentRequestURLString(fromEndPoint: endPoint),
             requestBody: requestBody,
             extraHeaders: extraHeaders,
             forAuthenticate: forAuthenticate,
             completionHandler: {[weak self] errorPackage, responsePackage in
            if let weakSelf = self {
                weakSelf.handleNetworkCompletionHandler(responsePackage: responsePackage, errorPackage: errorPackage, objectType: objectType, completion: completion)
            }
        })
        
    }
    
    func putAndResponseObject<T: Mappable>(endPoint: String,
                                           requestBody: [String: Any]?,
                                           extraHeaders: [String: String]? = nil,
                                           forAuthenticate: Bool = false,
                                           objectType: T.Type,
                                           completion: @escaping ((Response<T>)->())) {
        put(url: currentRequestURLString(fromEndPoint: endPoint),
             requestBody: requestBody,
             extraHeaders: extraHeaders,
             forAuthenticate: forAuthenticate,
             completionHandler: {[weak self] errorPackage, responsePackage in
            if let weakSelf = self {
                weakSelf.handleNetworkCompletionHandler(responsePackage: responsePackage, errorPackage: errorPackage, objectType: objectType, completion: completion)
            }
        })
        
    }
    
    func putAndResponseListObject<T: Mappable>(endPoint: String,
                                               requestBody: [String: Any]?,
                                               extraHeaders: [String: String]? = nil,
                                               forAuthenticate: Bool = false,
                                               objectType: T.Type,
                                               completion: @escaping ((ResponseList<T>)->())) {
        put(url: currentRequestURLString(fromEndPoint: endPoint),
             requestBody: requestBody,
             extraHeaders: extraHeaders,
             forAuthenticate: forAuthenticate,
             completionHandler: {[weak self] errorPackage, responsePackage in
            if let weakSelf = self {
                weakSelf.handleNetworkCompletionHandler(responsePackage: responsePackage, errorPackage: errorPackage, objectType: objectType, completion: completion)
            }
        })
        
    }
    
    func delete(endPoint: String,
             extraHeaders: [String: String]? = nil,
             forAuthenticate: Bool = false,
             completion: @escaping ((ResponseNoMapping)->())) {
        delete(url: currentRequestURLString(fromEndPoint: endPoint),
               extraHeaders: extraHeaders,
               forAuthenticate: forAuthenticate,
               completionHandler: {[weak self] errorPackage, responsePackage in
            if let weakSelf = self {
                weakSelf.handleNetworkCompletionHandler(responsePackage: responsePackage, errorPackage: errorPackage, completion: completion)
            }
        })
        
    }
    
}


extension APIServiceManager: NetworkManagerDelegate {
    func prehandleResponseData(_ manager: NetworkManager, response: ResponseData, forAuthenticate: Bool) {
        if let responseData = response.value as? [String: Any] {
            if forAuthenticate == true {
                // get authorization token here
                setAuthorizationTokenFrom(json: responseData)
            }
            
        }
    }
    
    func prehandleErrorData(_ manager: NetworkManager, error: ErrorData) {
        
    }
    
}
