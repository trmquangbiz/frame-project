//
//  APIServiceManager.swift
//  frameproject
//
//  Created by Quang Trinh on 28/10/2022.
//

import Foundation
import ObjectMapper
import RealmSwift


class APIServiceManager {
    
    let config = Configuration.shared
    
    static let shared: APIServiceManager = {
        let instance = APIServiceManager()
        instance.networkManager.taskDelegate = instance
        return instance
    }()
    
    
    var networkManager: NetworkManager = NetworkManager()
    
    private func setAuthorizationTokenFrom(json: [String:AnyObject]) {
        if let token = json[Constant.kAccessToken] as? String {
            AuthenticationService.shared.setAccessToken(token)
        }
    }
    
    /**
     Method gets the AskTutor base request URL
     - returns: String
     */
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
    private func getAuthorizationToken() -> String? {
        return AuthenticationService.shared.accessToken
    }
    
    func get(endPoint: String,
             queryParams: [String: Any]?,
             extraHeaders: [String: String]? = nil,
             forAuthenticate: Bool = false,
             completionHandler: @escaping NetworkCompletionHandler,
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        let requestStr = currentRequestURLString(fromEndPoint: "")
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
    
    func post(endPoint: String,
              requestBody: [String: Any]?,
              extraHeaders: [String: String]? = nil,
              forAuthenticate: Bool = false,
              completionHandler: @escaping NetworkCompletionHandler,
              functionName: String = #function,
              file: String = #file,
              fileID: String = #fileID,
              line: Int = #line) {
        let requestStr = currentRequestURLString(fromEndPoint: "")
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
    
    func put(endPoint: String,
             requestBody: [String: Any]?,
             extraHeaders: [String: String]? = nil,
             forAuthenticate: Bool = false,
             completionHandler: @escaping NetworkCompletionHandler,
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        let requestStr = currentRequestURLString(fromEndPoint: "")
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
    
    func delete(endPoint: String,
             extraHeaders: [String: String]? = nil,
             forAuthenticate: Bool = false,
             completionHandler: @escaping NetworkCompletionHandler,
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        let requestStr = currentRequestURLString(fromEndPoint: "")
        let headers = currentHeaderForRequest(extraHeaders: extraHeaders)
        networkManager.delete(url: requestStr,
                            headers: headers,
                            completionHandler: completionHandler,
                            functionName: functionName,
                            file: file,
                            fileID: fileID,
                            line: line)
        
    }
    
}


extension APIServiceManager: NetworkManagerDelegate {
    func prehandleResponseData(_ manager: NetworkManager, response: ResponseData, forAuthenticate: Bool) {
        if let responseData = response.value as? [String:AnyObject] {
            if forAuthenticate == true {
                // get authorization token here
                setAuthorizationTokenFrom(json: responseData)
            }
            
        }
    }
    
    func prehandleErrorData(_ manager: NetworkManager, error: ErrorData) {
        
    }
    
}

extension APIServiceManager {
    enum Response<T> {
        case success(statusCode: Int, responseObject: T?)
        case fail(statusCode: Int, errorMsg: Any?)
        
    }
    
    enum ResponseNoMapping {
        case success(statusCode: Int)
        case fail(statusCode: Int, errorMsg: Any?)
    }
    enum ResponseList<T> {
        case success(statusCode: Int, responseObject: [T]?, pagination: [String: Any]?)
        case fail(statusCode: Int, errorMsg: Any?)
    }
    
    func getObject<T: Mappable>(endPoint: String,
                                queryParams: [String: Any]?,
                                extraHeaders: [String: String]? = nil,
                                forAuthenticate: Bool = false,
                                objectType: T.Type?,
                                completion: @escaping ((Response<T>) -> ()),
                                functionName: String = #function,
                                file: String = #file,
                                fileID: String = #fileID,
                                line: Int = #line) {
        get(endPoint: endPoint,
            queryParams: queryParams,
            extraHeaders: extraHeaders,
            forAuthenticate: forAuthenticate,
            completionHandler: { errorPackage, responsePackage in
            if let responsePackage = responsePackage,
               let value = responsePackage.value as? [String: Any],
               let data = value[Constant.kData] as? [String: Any] {
                if let obj = T.init(JSON: data) {
                    completion(.success(statusCode: responsePackage.code, responseObject: obj))
                }
                else {
                    completion(.fail(statusCode: 9999, errorMsg: "Response success (\(responsePackage.code)) but mapping fail"))
                }
            }
            else if let errorPackage = errorPackage {
                completion(.fail(statusCode: errorPackage.code, errorMsg: errorPackage.value))
            }
            else {
                completion(.fail(statusCode: 9999, errorMsg: "No response from both responsePackage and errorPackage"))
            }
        },
            functionName: functionName,
            file: file,
            fileID: fileID,
            line: line
        )
    }
    
    
    func getListObject<T: Mappable>(endPoint: String,
                                    queryParams: [String: Any]?,
                                    extraHeaders: [String: String]? = nil,
                                    forAuthenticate: Bool = false,
                                    objectType: T.Type?,
                                    completion: @escaping ((ResponseList<T>)->()),
                                    functionName: String = #function,
                                    file: String = #file,
                                    fileID: String = #fileID,
                                    line: Int = #line) {
        get(endPoint: endPoint,
            queryParams: queryParams,
            extraHeaders: extraHeaders,
            forAuthenticate: forAuthenticate,
            completionHandler: { errorPackage, responsePackage in
            if let responsePackage = responsePackage,
               let value = responsePackage.value as? [String: Any] {
                var objList: [T] = []
                if let data = value[Constant.kData] as? [[String: Any]] {
                    data.forEach { dataNode in
                        if let obj = T.init(JSON: dataNode) {
                            objList.append(obj)
                        }
                    }
                }
                var paginationDict: [String: Any]?
                if let pagination = value[Constant.kPagination] as? [String: Any] {
                    paginationDict = pagination
                }
                
                completion(.success(statusCode: responsePackage.code, responseObject: objList, pagination: paginationDict))
            }
            else if let errorPackage = errorPackage {
                completion(.fail(statusCode: errorPackage.code, errorMsg: errorPackage.value))
            }
            else {
                completion(.fail(statusCode: 9999, errorMsg: "No response from both responsePackage and errorPackage"))
            }
            
        },
            functionName: functionName,
            file: file,
            fileID: fileID,
            line: line)
    }
    
    func postAndResponseObject<T: Mappable>(endPoint: String,
                                            requestBody: [String: Any]?,
                                            extraHeaders: [String: String]? = nil,
                                            forAuthenticate: Bool = false,
                                            objectType: T.Type,
                                            completion: @escaping ((Response<T>)->()),
                                            functionName: String = #function,
                                            file: String = #file,
                                            fileID: String = #fileID,
                                            line: Int = #line) {
        post(endPoint: endPoint,
             requestBody: requestBody,
             extraHeaders: extraHeaders,
             forAuthenticate: forAuthenticate,
             completionHandler: { errorPackage, responsePackage in
            if let responsePackage = responsePackage,
               let value = responsePackage.value as? [String: Any],
               let data = value[Constant.kData] as? [String: Any] {
                if let obj = T.init(JSON: data) {
                    completion(.success(statusCode: responsePackage.code, responseObject: obj))
                }
                else {
                    completion(.success(statusCode: responsePackage.code, responseObject: nil))
                }
            }
            else if let errorPackage = errorPackage {
                completion(.fail(statusCode: errorPackage.code, errorMsg: errorPackage.value))
            }
            else {
                completion(.fail(statusCode: 9999, errorMsg: "No response from both responsePackage and errorPackage"))
            }
        },
             functionName: functionName,
             file: file,
             fileID: fileID,
             line: line)
        
    }
    
    func postAndResponseListObject<T: Mappable>(endPoint: String,
                                                requestBody: [String: Any]?,
                                                extraHeaders: [String: String]? = nil,
                                                forAuthenticate: Bool = false,
                                                objectType: T.Type,
                                                completion: @escaping ((ResponseList<T>)->()),
                                                functionName: String = #function,
                                                file: String = #file,
                                                fileID: String = #fileID,
                                                line: Int = #line) {
        post(endPoint: endPoint,
             requestBody: requestBody,
             extraHeaders: extraHeaders,
             forAuthenticate: forAuthenticate,
             completionHandler: { errorPackage, responsePackage in
            if let responsePackage = responsePackage,
               let value = responsePackage.value as? [String: Any],
               let data = value[Constant.kData] as? [[String: Any]] {
                var objList: [T] = []
                data.forEach { dataNode in
                    if let obj = T.init(JSON: dataNode) {
                        objList.append(obj)
                    }
                }
                completion(.success(statusCode: responsePackage.code, responseObject: objList, pagination: nil))
            }
            else if let errorPackage = errorPackage {
                completion(.fail(statusCode: errorPackage.code, errorMsg: errorPackage.value))
            }
            else {
                completion(.fail(statusCode: 9999, errorMsg: "No response from both responsePackage and errorPackage"))
            }
        },
             functionName: functionName,
             file: file,
             fileID: fileID,
             line: line)
        
    }
    
    func putAndResponseObject<T: Mappable>(endPoint: String,
                                  requestBody: [String: Any]?,
                                  extraHeaders: [String: String]? = nil,
                                  forAuthenticate: Bool = false,
                                  completion: @escaping ((Response<T>)->()),
                                  functionName: String = #function,
                                  file: String = #file,
                                  fileID: String = #fileID,
                                  line: Int = #line) {
        put(endPoint: endPoint,
             requestBody: requestBody,
             extraHeaders: extraHeaders,
             forAuthenticate: forAuthenticate,
             completionHandler: { errorPackage, responsePackage in
            if let responsePackage = responsePackage,
               let value = responsePackage.value as? [String: Any],
               let data = value[Constant.kData] as? [String: Any] {
                if let obj = T.init(JSON: data) {
                    completion(.success(statusCode: responsePackage.code, responseObject: obj))
                }
                else {
                    completion(.success(statusCode: responsePackage.code, responseObject: nil))
                }
            }
            else if let errorPackage = errorPackage {
                completion(.fail(statusCode: errorPackage.code, errorMsg: errorPackage.value))
            }
            else {
                completion(.fail(statusCode: 9999, errorMsg: "No response from both responsePackage and errorPackage"))
            }
        },
             functionName: functionName,
             file: file,
             fileID: fileID,
             line: line)
        
    }
    
    func putAndResponseListObject<T: Mappable>(endPoint: String,
                                                requestBody: [String: Any]?,
                                                extraHeaders: [String: String]? = nil,
                                                forAuthenticate: Bool = false,
                                                completion: @escaping ((ResponseList<T>)->()),
                                                functionName: String = #function,
                                                file: String = #file,
                                                fileID: String = #fileID,
                                                line: Int = #line) {
        put(endPoint: endPoint,
             requestBody: requestBody,
             extraHeaders: extraHeaders,
             forAuthenticate: forAuthenticate,
             completionHandler: { errorPackage, responsePackage in
            if let responsePackage = responsePackage,
               let value = responsePackage.value as? [String: Any],
               let data = value[Constant.kData] as? [[String: Any]] {
                var objList: [T] = []
                data.forEach { dataNode in
                    if let obj = T.init(JSON: dataNode) {
                        objList.append(obj)
                    }
                }
                completion(.success(statusCode: responsePackage.code, responseObject: objList, pagination: nil))
            }
            else if let errorPackage = errorPackage {
                completion(.fail(statusCode: errorPackage.code, errorMsg: errorPackage.value))
            }
            else {
                completion(.fail(statusCode: 9999, errorMsg: "No response from both responsePackage and errorPackage"))
            }
        },
             functionName: functionName,
             file: file,
             fileID: fileID,
             line: line)
        
    }
    
    func delete(endPoint: String,
             extraHeaders: [String: String]? = nil,
             forAuthenticate: Bool = false,
             completion: @escaping ((ResponseNoMapping)->()),
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        delete(endPoint: endPoint,
               extraHeaders: extraHeaders,
               forAuthenticate: forAuthenticate,
               completionHandler: { errorPackage, responsePackage in
            if let responsePackage = responsePackage{
                completion(.success(statusCode: responsePackage.code))
            }
            else if let errorPackage = errorPackage {
                completion(.fail(statusCode: errorPackage.code, errorMsg: errorPackage.value))
            }
            else {
                completion(.fail(statusCode: 9999, errorMsg: "No response from both responsePackage and errorPackage"))
            }
        },
               functionName: functionName,
               file: file,
               fileID: fileID,
               line: line)
        
    }
}

extension APIServiceManager {
    
}
