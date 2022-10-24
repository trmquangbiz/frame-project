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
    var headers: [String: String]
    var queryParam: [String: Any]
    var requestBody: [String: Any]
    
    /// cURL from requested request
    var cURL: String?
    var requestTime: Date = Date()
    var responseTime: Date?
    
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
          headers: [String: String] = [:],
          queryParam: [String: Any] = [:],
          requestBody: [String: Any] = [:],
          cURL: String?) {
        self.url = url
        self.method = method
        self.headers = headers
        self.queryParam = queryParam
        self.requestBody = requestBody
        self.cURL = cURL
    }
    
    
}
