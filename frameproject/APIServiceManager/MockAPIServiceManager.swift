//
//  MockAPIServiceManager.swift
//  frameproject
//
//  Created by Quang Trinh on 18/09/2023.
//

import Foundation
import ObjectMapper

class MockAPIServiceManager: APIServiceManagerProtocol {
    let config = Configuration.shared
    /// Your json file should be in this format Method_{domain}({portNumberIfHave})_endPoint
    ///
    /// For example: GET_localhost(8080)_samples
    func getJSONFileName(fromEndPoint endPoint: String) -> String {
        guard let baseRequestDomain = config.baseRequestDomain else {
            return ""
        }
        let trimmedEndpoint = endPoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return (baseRequestDomain + (config.baseRequestPortNumber != nil ? "(\(config.baseRequestPortNumber!))" : "") + (trimmedEndpoint.count > 0 ? "/\(trimmedEndpoint)" : "")).replacingOccurrences(of: "/", with: "_")
    }
    
    func getJSON(fileName: String) -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            Debugger.debug("Cannot create JSON mock path for \(fileName)")
            return nil
        }
        do {
            if let data = try String.init(contentsOfFile: path).data(using: .utf8) {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                if let jsonDict = jsonResult as? [String: Any] {
                    return jsonDict
                }
            }
            return nil
        }
        catch {
            return nil
        }
    }
    
    
    func getObject<T: Mappable>(endPoint: String,
                                queryParams: [String: Any]?,
                                extraHeaders: [String: String]? = nil,
                                forAuthenticate: Bool = false,
                                objectType: T.Type,
                                completion: @escaping ((Response<T>) -> ()),
                                functionName: String = #function,
                                file: String = #file,
                                fileID: String = #fileID,
                                line: Int = #line) {
        let jsonFileName = "GET_\(getJSONFileName(fromEndPoint: endPoint))"
        if let json = getJSON(fileName: jsonFileName),
           let data = json[Constant.kData] as? [String: Any] {
            if let obj = T.init(JSON: data) {
                completion(.success(statusCode: 200, responseObject: obj))
            }
            else {
                completion(.success(statusCode: 200, responseObject: nil))
            }
        }
        else {
            completion(.fail(statusCode: 9999, errorMsg: "Something went wrong with json serialization"))
        }
        
    }
    
    func getListObject<T: Mappable>(endPoint: String,
                                    queryParams: [String: Any]?,
                                    extraHeaders: [String: String]? = nil,
                                    forAuthenticate: Bool = false,
                                    objectType: T.Type,
                                    completion: @escaping ((ResponseList<T>)->()),
                                    functionName: String = #function,
                                    file: String = #file,
                                    fileID: String = #fileID,
                                    line: Int = #line) {
        let jsonFileName = "GET_\(getJSONFileName(fromEndPoint: endPoint))"
        if let json = getJSON(fileName: jsonFileName) {
            if forAuthenticate == true {
                setAuthorizationTokenFrom(json: json)
            }
            let responseData = ResponseData.init(code: 200, value: json, requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: responseData, errorPackage: nil, objectType: objectType, completion: completion)
        }
        else {
            let errorData = ErrorData.init(code: 9999, value: "Cannot map json", requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: nil, errorPackage: errorData, objectType: objectType, completion: completion)
        }
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
        let jsonFileName = "POST_\(getJSONFileName(fromEndPoint: endPoint))"
        if let json = getJSON(fileName: jsonFileName) {
            if forAuthenticate == true {
                setAuthorizationTokenFrom(json: json)
            }
            let responseData = ResponseData.init(code: 200, value: json, requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: responseData, errorPackage: nil, objectType: objectType, completion: completion)
        }
        else {
            let errorData = ErrorData.init(code: 9999, value: "Cannot map json", requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: nil, errorPackage: errorData, objectType: objectType, completion: completion)
        }
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
        let jsonFileName = "POST_\(getJSONFileName(fromEndPoint: endPoint))"
        if let json = getJSON(fileName: jsonFileName) {
            if forAuthenticate == true {
                setAuthorizationTokenFrom(json: json)
            }
            let responseData = ResponseData.init(code: 200, value: json, requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: responseData, errorPackage: nil, objectType: objectType, completion: completion)
        }
        else {
            let errorData = ErrorData.init(code: 9999, value: "Cannot map json", requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: nil, errorPackage: errorData, objectType: objectType, completion: completion)
        }
    }
    
    func putAndResponseObject<T: Mappable>(endPoint: String,
                                           requestBody: [String: Any]?,
                                           extraHeaders: [String: String]? = nil,
                                           forAuthenticate: Bool = false,
                                           objectType: T.Type,
                                           completion: @escaping ((Response<T>)->()),
                                           functionName: String = #function,
                                           file: String = #file,
                                           fileID: String = #fileID,
                                           line: Int = #line) {
        let jsonFileName = "PUT_\(getJSONFileName(fromEndPoint: endPoint))"
        if let json = getJSON(fileName: jsonFileName) {
            if forAuthenticate == true {
                setAuthorizationTokenFrom(json: json)
            }
            let responseData = ResponseData.init(code: 200, value: json, requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: responseData, errorPackage: nil, objectType: objectType, completion: completion)
        }
        else {
            let errorData = ErrorData.init(code: 9999, value: "Cannot map json", requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: nil, errorPackage: errorData, objectType: objectType, completion: completion)
        }
    }
    
    func putAndResponseListObject<T: Mappable>(endPoint: String,
                                               requestBody: [String: Any]?,
                                               extraHeaders: [String: String]? = nil,
                                               forAuthenticate: Bool = false,
                                               objectType: T.Type,
                                               completion: @escaping ((ResponseList<T>)->()),
                                               functionName: String = #function,
                                               file: String = #file,
                                               fileID: String = #fileID,
                                               line: Int = #line) {
        let jsonFileName = "PUT_\(getJSONFileName(fromEndPoint: endPoint))"
        if let json = getJSON(fileName: jsonFileName) {
            if forAuthenticate == true {
                setAuthorizationTokenFrom(json: json)
            }
            let responseData = ResponseData.init(code: 200, value: json, requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: responseData, errorPackage: nil, objectType: objectType, completion: completion)
        }
        else {
            let errorData = ErrorData.init(code: 9999, value: "Cannot map json", requestInfo: NetworkRequestInfo.init(cURL: nil))
            handleNetworkCompletionHandler(responsePackage: nil, errorPackage: errorData, objectType: objectType, completion: completion)
        }
    }
    
    func delete(endPoint: String,
             extraHeaders: [String: String]? = nil,
             forAuthenticate: Bool = false,
             completion: @escaping ((ResponseNoMapping)->()),
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        // no need to mock on delete request
        completion(.success(statusCode: 200))
    }
    
    
}
