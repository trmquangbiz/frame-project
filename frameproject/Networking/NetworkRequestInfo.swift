//
//  NetworkRequestInfo.swift
//  frameproject
//
//  Created by Quang Trinh on 20/08/2022.
//

import Foundation

class NetworkRequestInfo {
    var url: String
    var method: NetworkHTTPMethod
    var headers: [String: String]?
    var queryParam: [String: Any]
    var requestBody: [String: Any]
    
    var isForAuthenticate: Bool
    /// cURL from requested request
    var cURL: String?
    var requestTime: Date
    var responseTime: Date?
    var responseHeaders: [String: String] = [:]
    
    var downloadDestinationURL: URL?
    
    var latency: TimeInterval {
        get {
            if let responseTime = responseTime {
                return responseTime.timeIntervalSince(requestTime)
            }
            return 0
        }
    }
    
    init (url: String = "https://",
          method: NetworkHTTPMethod = .get,
          headers: [String: String]? = [:],
          queryParam: [String: Any] = [:],
          requestBody: [String: Any] = [:],
          cURL: String?,
          requestTime: Date = Date(),
          responseTime: Date? = nil,
          responseHeaders: [String: String] = [:],
          downloadDestinationURL: URL? = nil,
          isForAuthenticate: Bool = false) {
        self.url = url
        self.method = method
        self.headers = headers
        self.queryParam = queryParam
        self.requestBody = requestBody
        self.cURL = cURL
        self.requestTime = requestTime
        self.responseTime = responseTime
        self.responseHeaders = responseHeaders
        self.downloadDestinationURL = downloadDestinationURL
        self.isForAuthenticate = isForAuthenticate
    }
    
    /// for copy
    convenience init(networkRequestInfo: NetworkRequestInfo) {
        self.init(url: networkRequestInfo.url,
                  method: networkRequestInfo.method,
                  headers: networkRequestInfo.headers,
                  queryParam: networkRequestInfo.queryParam,
                  requestBody: networkRequestInfo.requestBody,
                  cURL: networkRequestInfo.cURL,
                  requestTime: networkRequestInfo.requestTime,
                  responseTime: networkRequestInfo.responseTime,
                  responseHeaders: networkRequestInfo.responseHeaders,
                  downloadDestinationURL: networkRequestInfo.downloadDestinationURL,
                  isForAuthenticate: networkRequestInfo.isForAuthenticate)
    }
    
    func copy() -> NetworkRequestInfo {
        return NetworkRequestInfo.init(networkRequestInfo: self)
    }
}
