//
//  APIServiceManagerProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 18/09/2023.
//

import Foundation
import ObjectMapper

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


protocol APIServiceManagerProtocol: AnyObject {
    
    func getObject<T: Mappable>(endPoint: String,
                                queryParams: [String: Any]?,
                                extraHeaders: [String: String]?,
                                forAuthenticate: Bool,
                                objectType: T.Type,
                                completion: @escaping ((Response<T>) -> ()),
                                functionName: String,
                                file: String,
                                fileID: String,
                                line: Int)
    
    
    func getListObject<T: Mappable>(endPoint: String,
                                    queryParams: [String: Any]?,
                                    extraHeaders: [String: String]?,
                                    forAuthenticate: Bool,
                                    objectType: T.Type,
                                    completion: @escaping ((ResponseList<T>)->()),
                                    functionName: String,
                                    file: String,
                                    fileID: String,
                                    line: Int)
    
    func postAndResponseObject<T: Mappable>(endPoint: String,
                                            requestBody: [String: Any]?,
                                            extraHeaders: [String: String]?,
                                            forAuthenticate: Bool,
                                            objectType: T.Type,
                                            completion: @escaping ((Response<T>)->()),
                                            functionName: String,
                                            file: String,
                                            fileID: String,
                                            line: Int)
    
    func postAndResponseListObject<T: Mappable>(endPoint: String,
                                                requestBody: [String: Any]?,
                                                extraHeaders: [String: String]?,
                                                forAuthenticate: Bool,
                                                objectType: T.Type,
                                                completion: @escaping ((ResponseList<T>)->()),
                                                functionName: String,
                                                file: String,
                                                fileID: String,
                                                line: Int)
    
    func putAndResponseObject<T: Mappable>(endPoint: String,
                                           requestBody: [String: Any]?,
                                           extraHeaders: [String: String]?,
                                           forAuthenticate: Bool,
                                           objectType: T.Type,
                                           completion: @escaping ((Response<T>)->()),
                                           functionName: String,
                                           file: String,
                                           fileID: String,
                                           line: Int)
    
    func putAndResponseListObject<T: Mappable>(endPoint: String,
                                               requestBody: [String: Any]?,
                                               extraHeaders: [String: String]?,
                                               forAuthenticate: Bool,
                                               objectType: T.Type,
                                               completion: @escaping ((ResponseList<T>)->()),
                                               functionName: String,
                                               file: String,
                                               fileID: String,
                                               line: Int)
    
    func delete(endPoint: String,
             extraHeaders: [String: String]?,
             forAuthenticate: Bool,
             completion: @escaping ((ResponseNoMapping)->()),
             functionName: String,
             file: String,
             fileID: String,
             line: Int)
}

extension APIServiceManagerProtocol {
    func setAuthorizationTokenFrom(json: [String:Any]) {
        if let token = json[Constant.kAccessToken] as? String {
            AuthenticationService.shared.setAccessToken(token)
        }
    }
    
    func handleNetworkCompletionHandler<T: Mappable>(responsePackage: ResponseData?, errorPackage: ErrorData?, objectType: T.Type, completion: @escaping ((ResponseList<T>)->())) {
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
    }
    
    func handleNetworkCompletionHandler<T: Mappable>(responsePackage: ResponseData?, errorPackage: ErrorData?, objectType: T.Type, completion: @escaping ((Response<T>)->())) {
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
    }
    
    func handleNetworkCompletionHandler(responsePackage: ResponseData?, errorPackage: ErrorData?, completion: @escaping ((ResponseNoMapping)->())) {
        if let responsePackage = responsePackage {
            completion(.success(statusCode: responsePackage.code))
        }
        else if let errorPackage = errorPackage {
            completion(.fail(statusCode: errorPackage.code, errorMsg: errorPackage.value))
        }
        else {
            completion(.fail(statusCode: 9999, errorMsg: "No response from both responsePackage and errorPackage"))
        }
    }
}
