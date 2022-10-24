//
//  NetworkServiceConfig.swift
//  frameproject
//
//  Created by Quang Trinh on 13/08/2022.
//

import Foundation


class NetworkServiceConfig: NetworkServiceConfigProtocol {
    required init(maxNumberRequest: Int, timeoutInterval: Int) {
        self.timeoutInterval = timeoutInterval
        self.maxNumberRequest = maxNumberRequest
    }
    
    var maxNumberRequest: Int
    
    var timeoutInterval: Int
    
}
