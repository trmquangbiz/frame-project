//
//  AlamofireNetworkService.swift
//  frameproject
//
//  Created by Quang Trinh on 24/10/2022.
//

import Foundation
import Alamofire


class AlamofireNetworkService: NetworkServiceProtocol {
    var config: NetworkServiceConfigProtocol
    private let session = AF
    
    init(config: NetworkServiceConfigProtocol = AlamofireServiceConfig(maxNumberRequest: 100, timeoutInterval: 60, additionalHeadersForRequest: [:], allowCellularAccess: true)) {
        self.config = config
        session.sessionConfiguration.httpAdditionalHeaders = config.additionalHeadersForRequest
        session.sessionConfiguration.allowsCellularAccess = config.allowCellularAccess
        session.sessionConfiguration.httpMaximumConnectionsPerHost = config.maxNumberRequest
        session.sessionConfiguration.timeoutIntervalForRequest = config.timeoutInterval
    }
    
    func get(url: String,
             headers: [String : String],
             queryParam: [String : Any],
             forAuthenticate: Bool,
             completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo {
        let request = session.request(url,
                                      method: .get,
                                      parameters: queryParam,
                                      encoding: URLEncoding.default,
                                      headers: HTTPHeaders.init(headers),
                                      interceptor: nil,
                                      requestModifier: .none)
        let requestInfo = NetworkRequestInfo.init(url: url,
                                                  method: .get,
                                                  headers: headers,
                                                  queryParam: queryParam,
                                                  requestBody: [:],
                                                  cURL: request.cURL,
                                                  isForAuthenticate: forAuthenticate)
        request.responseString(queue: .global(qos: .background)) {[weak self] response in
            requestInfo.responseTime = Date()
            if let weakSelf = self {
                weakSelf.completionHandle(response: response,
                                          requestInfo: requestInfo,
                                          forAuthenticate: forAuthenticate,
                                          completionHandler: completionHandler)
            }
        }
        return requestInfo
    }
    
    func post(url: String, headers: [String : String], requestBody: [String : Any], forAuthenticate: Bool, completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo {
        let request = session.request(url,
                                      method: .post,
                                      parameters: requestBody,
                                      encoding: JSONEncoding.default,
                                      headers: HTTPHeaders.init(headers),
                                      interceptor: nil,
                                      requestModifier: .none)
        let requestInfo = NetworkRequestInfo.init(url: url,
                                                  method: .get,
                                                  headers: headers,
                                                  queryParam: [:],
                                                  requestBody: requestBody,
                                                  cURL: request.cURL,
                                                  isForAuthenticate: forAuthenticate)
        request.responseString(queue: .global(qos: .background)) { [weak self] response in
            requestInfo.responseTime = Date()
            if let weakSelf = self {
                weakSelf.completionHandle(response: response,
                                          requestInfo: requestInfo,
                                          forAuthenticate: forAuthenticate,
                                          completionHandler: completionHandler)
            }
        }
        return requestInfo
    }
    
    func put(url: String, headers: [String : String], requestBody: [String : Any], forAuthenticate: Bool, completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo {
        let request = session.request(url,
                                      method: .put,
                                      parameters: requestBody,
                                      encoding: JSONEncoding.default,
                                      headers: HTTPHeaders.init(headers),
                                      interceptor: nil,
                                      requestModifier: .none)
        let requestInfo = NetworkRequestInfo.init(url: url,
                                                  method: .put,
                                                  headers: headers,
                                                  queryParam: [:],
                                                  requestBody: requestBody,
                                                  cURL: request.cURL,
                                                  isForAuthenticate: forAuthenticate)
        request.responseString(queue: .global(qos: .background)) { [weak self] response in
            requestInfo.responseTime = Date()
            if let weakSelf = self {
                weakSelf.completionHandle(response: response,
                                          requestInfo: requestInfo,
                                          forAuthenticate: forAuthenticate,
                                          completionHandler: completionHandler)
            }
        }
        return requestInfo
    }
    
    func delete(url: String, headers: [String : String], completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo {
        let request = session.request(url,
                                      method: .delete,
                                      parameters: nil,
                                      encoding: JSONEncoding.default,
                                      headers: HTTPHeaders.init(headers),
                                      interceptor: nil,
                                      requestModifier: .none)
        let requestInfo = NetworkRequestInfo.init(url: url,
                                                  method: .delete,
                                                  headers: headers,
                                                  queryParam: [:],
                                                  requestBody: [:],
                                                  cURL: request.cURL)
        request.responseString(queue: .global(qos: .background)) { [weak self] response in
            requestInfo.responseTime = Date()
            if let weakSelf = self {
                weakSelf.completionHandle(response: response,
                                          requestInfo: requestInfo,
                                          forAuthenticate: false,
                                          completionHandler: completionHandler)
            }
        }
        return requestInfo
    }
    
    func download(url: String, headers: [String : String], params: [String : AnyObject], dataType: DataType, completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo {
        let request = session.download(url, method: .get,
                                       parameters: params, encoding: URLEncoding.default,
                                       headers: HTTPHeaders.init(headers), to: { (url, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
            let destinationURL = NetworkManagerUtilities.getDownloadDestinationPath(url: url,
                                                                                    response: response)
            return (destinationURL, DownloadRequest.Options.init(rawValue: 0))
        })
        let requestInfo = NetworkRequestInfo.init(url: url,
                                                  method: .get,
                                                  headers: headers,
                                                  queryParam: params,
                                                  requestBody: [:],
                                                  cURL: request.cURL)
        request.response(completionHandler: { (response) in
            requestInfo.responseTime = Date()
            if let error = response.error, let request = response.request, let url = request.url {
                requestInfo.url = url.absoluteString
                let error = ErrorData.init(code: 9999, value: error.localizedDescription, requestInfo: requestInfo)
                completionHandler(error, nil)
            }
            else {
                self.completionHandleData(response: response, requestInfo: requestInfo, dataType: dataType, completionHandler: completionHandler)
            }
        })
        return requestInfo
    }
    
    func upload(url: String, headers: [String : String], data: Data, imagePathInfos: ImagePathInfo, completionHandler: @escaping NetworkCompletionHandler) -> NetworkRequestInfo {
        
        let request = session.upload(multipartFormData: { form in
            form.append(data,
                        withName: imagePathInfos.name,
                        fileName: imagePathInfos.fileName,
                        mimeType: imagePathInfos.mimeType)
        },
                       to: url,
                       usingThreshold: UInt64(), method: .post,
                       headers: HTTPHeaders.init(headers), requestModifier: nil)
        let requestInfo = NetworkRequestInfo.init(url: url, method: .post, headers: headers, cURL: request.cURL)
        request.responseString { [weak self] response in
            requestInfo.responseTime = Date()
            if let weakSelf = self {
                weakSelf.completionHandle(response: response,
                                          requestInfo: requestInfo,
                                          forAuthenticate: false,
                                          completionHandler: completionHandler)
            }
        }
        return requestInfo
    }
    
    private func completionHandle(response: AFDataResponse<String>, requestInfo: NetworkRequestInfo, forAuthenticate: Bool, completionHandler: @escaping NetworkCompletionHandler) {
        if let error = response.error {
            let errorData = ErrorData.init(code: 9999, value: error.localizedDescription, requestInfo: requestInfo)
            if let request = response.request, let url = request.url {
                requestInfo.url = url.absoluteString
            }
            DispatchQueue.main.async {
                completionHandler(errorData, nil)
            }
            return
        }
        else {
            if let headers = response.response?.allHeaderFields {
                for key in headers.keys {
                    if let key = key as? String, let headerVal = headers[key] as? String {
                        requestInfo.responseHeaders[key] = headerVal
                    }
                }
            }
            if let request = response.request,
               let url = request.url {
                requestInfo.url = url.absoluteString
            }
            switch response.result {
            case .success(let responseStr):
                if let code = response.response?.statusCode {
                    var responseBody: Any = responseStr
                    if let json = responseStr.dictionary {
                        responseBody = json
                    }
                    if code >= 200 && code <= 300 {
                        let responseData = ResponseData.init(code: code, value: responseBody, requestInfo: requestInfo)
                        DispatchQueue.main.async {
                            completionHandler(nil, responseData)
                        }
                        return
                    }
                    else {
                        let errorData = ErrorData.init(code: code, value: responseBody, requestInfo: requestInfo)
                        DispatchQueue.main.async {
                            completionHandler(errorData, nil)
                        }
                    }
                }
                else {
                    let errorData = ErrorData.init(code: 9999, value: "No status code", requestInfo: requestInfo)
                    DispatchQueue.main.async {
                        completionHandler(errorData, nil)
                    }
                }
                
            case .failure(let error):
                var errorDescription = "Alamofire throw error"
                if let AFerrorDescription = error.errorDescription {
                    errorDescription = AFerrorDescription
                }
                let errorData = ErrorData.init(code: 9999, value: errorDescription, requestInfo: requestInfo)
                DispatchQueue.main.async {
                    completionHandler(errorData, nil)
                }
            }
        }
    }
    
    private func completionHandleData(response: AFDownloadResponse<URL?>, requestInfo: NetworkRequestInfo, dataType: DataType, completionHandler: @escaping NetworkCompletionHandler) {
        if let error = response.error {
            let errorData = ErrorData.init(code: 9999, value: error.localizedDescription, requestInfo: requestInfo)
            if let request = response.request, let url = request.url {
                requestInfo.url = url.absoluteString
            }
            completionHandler(errorData, nil)
            return
        }
        else {
            if let headers = response.response?.allHeaderFields {
                for key in headers.keys {
                    if let key = key as? String, let headerVal = headers[key] as? String {
                        requestInfo.responseHeaders[key] = headerVal
                    }
                }
            }
            if let request = response.request,
               let url = request.url {
                requestInfo.url = url.absoluteString
            }
            switch response.result {
            case .success(let destinationURL):
                if let code = response.response?.statusCode {
                    if code >= 200 && code <= 300 {
                        if let destinationURL = destinationURL {
                            switch dataType {
                            case .data:
                                do {
                                    let data = try Data.init(contentsOf: destinationURL, options: Data.ReadingOptions.init(rawValue: 0))
                                    let responseData = ResponseData.init(code: code, value: data, requestInfo: requestInfo)
                                    DispatchQueue.main.async {
                                        completionHandler(nil, responseData)
                                    }
                                    return
                                }
                                catch {
                                    
                                }
                            case .image:
                                if let image = UIImage.init(contentsOfFile: destinationURL.absoluteString) {
                                    let responseData = ResponseData.init(code: code, value: image, requestInfo: requestInfo)
                                    DispatchQueue.main.async {
                                        completionHandler(nil, responseData)
                                    }
                                    return
                                }
                            case .string:
                                do {
                                    let str = try String.init(contentsOfFile: destinationURL.absoluteString)
                                    let responseData = ResponseData.init(code: code, value: str, requestInfo: requestInfo)
                                    DispatchQueue.main.async {
                                        completionHandler(nil, responseData)
                                    }
                                    return
                                }
                                catch {
                                    
                                }
                            }
                            return
                        }
                        else {
                            let errorData = ErrorData.init(code: code, value: "Cannot get destination URL", requestInfo: requestInfo)
                            DispatchQueue.main.async {
                                completionHandler(errorData, nil)
                            }
                        }
                    }
                    else {
                        let errorDescription = "Something's wrong"
                        let errorData = ErrorData.init(code: code, value: errorDescription, requestInfo: requestInfo)
                        DispatchQueue.main.async {
                            completionHandler(errorData, nil)
                        }
                    }
                }
                else {
                    let errorData = ErrorData.init(code: 9999, value: "No status code", requestInfo: requestInfo)
                    DispatchQueue.main.async {
                        completionHandler(errorData, nil)
                    }
                }
            case .failure(let error):
                var errorDescription = "Alamofire throw error"
                if let AFerrorDescription = error.errorDescription {
                    errorDescription = AFerrorDescription
                }
                let errorData = ErrorData.init(code: 9999, value: errorDescription, requestInfo: requestInfo)
                DispatchQueue.main.async {
                    completionHandler(errorData, nil)
                }
            }
        }
    }
}

extension DataRequest {
    var cURL: String {
        return cURLDescription()
    }
}

extension DownloadRequest {
    var cURL: String {
        return cURLDescription()
    }
}
