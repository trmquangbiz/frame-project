//
//  APIServiceManager.swift
//  frameproject
//
//  Created by Quang Trinh on 28/10/2022.
//

import Foundation


class APIServiceManager {
    
    static let shared: APIServiceManager = {
        let instance = APIServiceManager()
        instance.networkManager.taskDelegate = instance
        return instance
    }()
    
    var networkManager: NetworkManager = NetworkManager()
}


extension APIServiceManager: NetworkManagerDelegate {
    func prehandleResponseData(_ manager: NetworkManager, response: ResponseData, forAuthenticate: Bool) {
        if let serverTime = response.requestInfo.responseHeaders["x-lozi-server-time"],
            let serverTimeValue = Double.init(serverTime) {
            let date = Date.init(timeIntervalSince1970: serverTimeValue)
            CheatingCounterService.shared.saveServerTimeDiff(from: date)
        }
        
        if response.requestInfo.isForAuthenticate {
            
        }
    }
    
    func prehandleErrorData(_ manager: NetworkManager, error: ErrorData) {
        if error.code <= 502,
            let serverTime = error.requestInfo.responseHeaders["x-lozi-server-time"],
            let serverTimeValue = Double.init(serverTime) {
            let date = Date.init(timeIntervalSince1970: serverTimeValue)
            CheatingCounterService.shared.saveServerTimeDiff(from: date)
        }
    }
    
    
}
