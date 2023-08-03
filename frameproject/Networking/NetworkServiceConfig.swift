//
//  NetworkServiceConfig.swift
//  frameproject
//
//  Created by Quang Trinh on 13/08/2022.
//

import Foundation


class NetworkServiceConfig: NetworkServiceConfigProtocol {
    var timeoutInterval: Double
    
    var additionalHeadersForRequest: [String : String]
    
    var allowCellularAccess: Bool
    var maxNumberRequest: Int
    
    required init(maxNumberRequest: Int, timeoutInterval: Double, additionalHeadersForRequest: [String : String], allowCellularAccess: Bool) {
        self.timeoutInterval = timeoutInterval
        self.maxNumberRequest = maxNumberRequest
        self.additionalHeadersForRequest = additionalHeadersForRequest
        self.allowCellularAccess = allowCellularAccess
    }
    
}
