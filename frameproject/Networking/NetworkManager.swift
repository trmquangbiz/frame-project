//
//  NetworkManager.swift
//  frameproject
//
//  Created by Quang Trinh on 31/08/2022.
//

import Foundation

class NetworkManager {
    var service: NetworkServiceProtocol
    weak var taskDelegate: NetworkManagerDelegate?
    let networkQueue = DispatchQueue.makeCustomQueue(type: .serial, name: .networkManager)
    init (service: NetworkServiceProtocol = AlamofireNetworkService.init()) {
        self.service = service
    }
    
    func get(url: String,
             headers: [String: String],
             queryParam: [String: Any],
             forAuthenticate: Bool,
             completionHandler: @escaping NetworkCompletionHandler,
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        let request = service.get(url: url,
                                  headers: headers,
                                  queryParam: queryParam,
                                  forAuthenticate: forAuthenticate) {[weak self] error, response in
            if let response = response {
                if let weakSelf = self {
                    weakSelf.logSuccessResponse(response: response, functionName: functionName, file: file, fileID: fileID, line: line)
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleResponseData(weakSelf, response: response, forAuthenticate: forAuthenticate)
                    }
                }
            }
            if let error = error {
                if let weakSelf = self {
                    weakSelf.logFailResponse(error: error, functionName: functionName, file: file, fileID: fileID, line: line)
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleErrorData(weakSelf, error: error)
                    }
                }
            }
            completionHandler(error, response)
        }
        
        logInitiateRequest(request: request,
                           functionName: functionName,
                           file: file,
                           fileID: fileID,
                           line: line)
    }
    func post(url: String,
              headers: [String: String],
              requestBody: [String: Any],
              forAuthenticate: Bool,
              completionHandler: @escaping NetworkCompletionHandler,
              functionName: String = #function,
              file: String = #file,
              fileID: String = #fileID,
              line: Int = #line) {
        let request = service.post(url: url,
                                   headers: headers,
                                   requestBody: requestBody,
                                   forAuthenticate: forAuthenticate) {[weak self] error, response in
            if let response = response {
                if let weakSelf = self {
                    weakSelf.logSuccessResponse(response: response, functionName: functionName, file: file, fileID: fileID, line: line)
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleResponseData(weakSelf, response: response, forAuthenticate: forAuthenticate)
                    }
                }
            }
            if let error = error {
                if let weakSelf = self {
                    weakSelf.logFailResponse(error: error, functionName: functionName, file: file, fileID: fileID, line: line)
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleErrorData(weakSelf, error: error)
                    }
                }
            }
            completionHandler(error, response)
        }
        logInitiateRequest(request: request,
                           functionName: functionName,
                           file: file,
                           fileID: fileID,
                           line: line)
    }
    func put(url: String,
             headers: [String: String],
             requestBody: [String: Any],
             forAuthenticate: Bool,
             completionHandler: @escaping NetworkCompletionHandler,
             functionName: String = #function,
             file: String = #file,
             fileID: String = #fileID,
             line: Int = #line) {
        let request = service.put(url: url,
                                  headers: headers,
                                  requestBody: requestBody,
                                  forAuthenticate: forAuthenticate) {[weak self] error, response in
            if let response = response {
                if let weakSelf = self {
                    weakSelf.logSuccessResponse(response: response, functionName: functionName, file: file, fileID: fileID, line: line)
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleResponseData(weakSelf, response: response, forAuthenticate: forAuthenticate)
                    }
                }
            }
            if let error = error {
                if let weakSelf = self {
                    weakSelf.logFailResponse(error: error, functionName: functionName, file: file, fileID: fileID, line: line)
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleErrorData(weakSelf, error: error)
                    }
                }
            }
            completionHandler(error, response)
        }
        logInitiateRequest(request: request,
                           functionName: functionName,
                           file: file,
                           fileID: fileID,
                           line: line)
    }
    func delete(url: String,
                headers:[String: String],
                completionHandler: @escaping NetworkCompletionHandler,
                functionName: String = #function,
                file: String = #file,
                fileID: String = #fileID,
                line: Int = #line) {
        let request = service.delete(url: url,
                                  headers: headers) {[weak self] error, response in
            if let response = response {
                if let weakSelf = self {
                    weakSelf.logSuccessResponse(response: response, functionName: functionName, file: file, fileID: fileID, line: line)
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleResponseData(weakSelf, response: response, forAuthenticate: false)
                    }
                }
            }
            if let error = error {
                if let weakSelf = self {
                    weakSelf.logFailResponse(error: error, functionName: functionName, file: file, fileID: fileID, line: line)
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleErrorData(weakSelf, error: error)
                    }
                }
            }
            completionHandler(error, response)
        }
        logInitiateRequest(request: request,
                           functionName: functionName,
                           file: file,
                           fileID: fileID,
                           line: line)
    }
    func download(url: String,
                  headers: [String: String],
                  params: [String: AnyObject],
                  dataType: DataType,
                  completionHandler: @escaping NetworkCompletionHandler) {
        
    }
    
    func upload(url: String,
                headers: [String: String],
                data: Data,
                imagePathInfos: ImagePathInfo,
                completionHandler: @escaping NetworkCompletionHandler,
                functionName: String = #function,
                file: String = #file,
                fileID: String = #fileID,
                line: Int = #line) {
        let _ = service.upload(url: url, headers: headers, data: data, imagePathInfos: imagePathInfos) {[weak self] error, response in
            if let response = response {
                if let weakSelf = self {
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleResponseData(weakSelf, response: response, forAuthenticate: false)
                    }
                }
            }
            if let error = error {
                if let weakSelf = self {
                    if let taskDelegate = weakSelf.taskDelegate {
                        taskDelegate.prehandleErrorData(weakSelf, error: error)
                    }
                }
            }
            completionHandler(error, response)
        }
    }
    
    private func logInitiateRequest(request: NetworkRequestInfo,
                                    functionName: String,
                                    file: String,
                                    fileID: String,
                                    line: Int) {
        Debugger.debug({
            var log = "\n-----Begin Request Initiate log-----"
            log += "\n- URL: \(request.url)"
            log += "\n- Method: \(request.method.rawValue)"
            if let cURL = request.cURL {
                log += "\n- cURL:"
                log += "\n```"
                log += "\n\(cURL)"
                log += "\n```"
            }
            log += "\n-----End Request Initiate log-----"
            return log
        },
                       functionName: functionName,
                       file: file,
                       fileID: fileID,
                       line: line)
    }
    
    private func logSuccessResponse(response: ResponseData,
                                    functionName: String,
                                    file: String,
                                    fileID: String,
                                    line: Int) {
        let responseRequest = response.requestInfo
        switch response.requestInfo.method {
        case .get, .delete:
            Debugger.debug({
                var log = "\n-----Begin Request Success log-----"
                log += "\n- URL: \(responseRequest.url)"
                log += "\n- Method: \(responseRequest.method.rawValue)"
                log += "\n- Status code: \(response.code)"
                log += "\n- Request time: \(responseRequest.requestTime)"
                if let cURL = responseRequest.cURL {
                    log += "\n- cURL:"
                    log += "\n```"
                    log += "\n\(cURL)"
                    log += "\n```"
                }
                log += "\n-----End Request Success log-----"
                return log
            },
                           functionName: functionName,
                           file: file,
                           fileID: fileID,
                           line: line)
        case .post, .put:
            Debugger.debug({
                var log = "\n-----Begin Request Success log-----"
                log += "\n- URL: \(responseRequest.url)"
                log += "\n- Method: \(responseRequest.method.rawValue)"
                if let json = responseRequest.requestBody.jsonString {
                    log += "\n- Request body:"
                    log += "\n```"
                    log += "\n\(json)"
                    log += "\n```"
                }
                log += "\n- Status code: \(response.code)"
                log += "\n- Request time: \(responseRequest.requestTime)"
                if let cURL = responseRequest.cURL {
                    log += "\n- cURL:"
                    log += "\n```"
                    log += "\n\(cURL)"
                    log += "\n```"
                }
                log += "\n-----End Request Success log-----"
                return log
            },
                           functionName: functionName,
                           file: file,
                           fileID: fileID,
                           line: line)
        case .options, .head, .patch, .trace, .connect:
            break;
        }
    }
    
    private func logFailResponse(error: ErrorData,
                                 functionName: String,
                                 file: String,
                                 fileID: String,
                                 line: Int) {
        let responseRequest = error.requestInfo
        switch error.requestInfo.method {
        case .get, .delete:
            Debugger.debug({
                var log = "\n-----Begin Request Error log-----"
                log += "\n- URL: \(responseRequest.url)"
                log += "\n- Method: \(responseRequest.method.rawValue)"
                log += "\n- Status code: \(error.code)"
                if let errorMessage = error.value as? String {
                    log += "\n- Error message: \(errorMessage)"
                }
                else if let errorJSON = error.value as? [String: AnyObject], let jsonString = errorJSON.jsonString {
                    log += "\n- Error message:"
                    log += "\n```"
                    log += jsonString
                    log += "\n```"
                }
                log += "\n- Request time: \(responseRequest.requestTime)"
                if let cURL = responseRequest.cURL {
                    log += "\n- cURL:"
                    log += "\n```"
                    log += "\n\(cURL)"
                    log += "\n```"
                }
                log += "\n-----End Request Error log-----"
                return log
            },
                           functionName: functionName,
                           file: file,
                           fileID: fileID,
                           line: line)
        case .post, .put:
            Debugger.debug({
                var log = "\n-----Begin Request Error log-----"
                log += "\n- URL: \(responseRequest.url)"
                log += "\n- Method: \(responseRequest.method.rawValue)"
                if let json = responseRequest.requestBody.jsonString {
                    log += "\n- Request body:"
                    log += "\n```"
                    log += "\n\(json)"
                    log += "\n```"
                }
                log += "\n- Status code: \(error.code)"
                if let errorMessage = error.value as? String {
                    log += "\n- Error message: \(errorMessage)"
                }
                else if let errorJSON = error.value as? [String: AnyObject], let jsonString = errorJSON.jsonString {
                    log += "\n- Error message:"
                    log += "\n```"
                    log += jsonString
                    log += "\n```"
                }
                log += "\n- Request time: \(responseRequest.requestTime)"
                if let cURL = responseRequest.cURL {
                    log += "\n- cURL:"
                    log += "\n```"
                    log += "\n\(cURL)"
                    log += "\n```"
                }
                log += "\n-----End Request Error log-----"
                return log
            },
                           functionName: functionName,
                           file: file,
                           fileID: fileID,
                           line: line)
        case .options, .head, .patch, .trace, .connect:
            break;
        }
    }
}


protocol NetworkManagerDelegate: AnyObject {
    func prehandleResponseData(_ manager: NetworkManager, response: ResponseData, forAuthenticate: Bool)
    func prehandleErrorData(_ manager: NetworkManager, error: ErrorData)
}
