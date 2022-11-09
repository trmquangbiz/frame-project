//
//  AlamofireServiceConfig.swift
//  frameproject
//
//  Created by Quang Trinh on 24/10/2022.
//

import Foundation

class AlamofireServiceConfig: NetworkServiceConfigProtocol {
    var maxNumberRequest: Int
    
    var timeoutInterval: Double
    
    var additionalHeadersForRequest: [String : String]
    
    var allowCellularAccess: Bool
    
    required init(maxNumberRequest: Int, timeoutInterval: Double, additionalHeadersForRequest: [String : String], allowCellularAccess: Bool) {
        self.maxNumberRequest = maxNumberRequest
        self.timeoutInterval = timeoutInterval
        self.additionalHeadersForRequest = additionalHeadersForRequest
        self.allowCellularAccess = allowCellularAccess
    }
    
    
}
