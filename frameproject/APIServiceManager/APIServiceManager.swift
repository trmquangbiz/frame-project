//
//  APIServiceManager.swift
//  frameproject
//
//  Created by Quang Trinh on 28/10/2022.
//

import Foundation


class APIServiceManager {
    
    let config = Configuration.shared
    
    static let shared: APIServiceManager = {
        let instance = APIServiceManager()
        instance.networkManager.taskDelegate = instance
        return instance
    }()
    
    
    var networkManager: NetworkManager = NetworkManager()
    
    private func setAuthorizationTokenFrom(json: [String:AnyObject]) {
        if let token = json[Constant.kAccessToken] as? String {
            UserDefaults.standard.set(token, forKey: Constant.kAccessToken)
        }
    }
    
    /**
     Method gets the AskTutor base request URL
     - returns: String
     */
    private func getBaseRequestURL() -> String {
        return config.baseRequestURL
    }
    
    /**
     currentRequestURLString
     
     - parameter endPoint: <#endPoint description#>
     
     - returns: <#return value description#>
     */
    func currentRequestURLString(fromEndPoint endPoint: String) -> String {
        return self.getBaseRequestURL() + "/" + endPoint
    }
    
    
    func createParameters(_ parameters: [String: AnyObject]?) -> [String: AnyObject] {
        var newParamters: [String: AnyObject] = [:]
        if let parameters = parameters {
            let keys = parameters.keys
            for key in keys {
                newParamters.updateValue(parameters[key]!, forKey: key)
            }
        }
        return newParamters
    }
    
    func currentHeaderForRequest(extraHeaders: [String:String]?) -> [String: String] {
        var header: [String:String] = [:]
        if let authorizationToken = getAuthorizationToken() {
            header[Constant.kHeaderAccessToken] = authorizationToken
        }
        header["Content-Type"] = "application/json"
        header[Constant.kXLanguage] = "\(GlobalStatusVariable.currentLanguage)"
        header[Constant.kAcceptLanguage] = "\(GlobalStatusVariable.currentLanguage)"
        if let jwtStr = Utils.mobileJWTStr() {
            header[Constant.kXLoziClientToken] = jwtStr
        }
        header[Constant.kXLoziAppClient] = Constant.appClientId
        header[Constant.kXLoziClient] = Constant.clientId
        header[Constant.kXAppBuild] = "\(Constant.appBuild)"
        header[Constant.kXAPIVersion] = Constant.apiVersion
        if let extraHeaders = extraHeaders {
            for key in extraHeaders.keys {
                if let value = extraHeaders[key] {
                    header[key] = value
                }
            }
        }
        return header
    }
    func currentLoziHeaderForRequest(extraHeaders: [String: String]?) -> [String: String] {
        var header: [String:String] = [:]
        
        if let authorizationToken = getAuthorizationToken() {
            header[Constant.kHeaderAccessToken] = authorizationToken
        }
        header["Content-Type"] = "application/json"
        header[Constant.kXLoziAppClient] = Constant.appClientId
        header[Constant.kAcceptLanguage] = "\(GlobalStatusVariable.currentLanguage)"
        header[Constant.kXLoziClient] = Constant.clientId
        header[Constant.kXAppBuild] = "\(Constant.appBuild)"
        header[Constant.kXAPIVersion] = Constant.apiVersion
        if let extraHeaders = extraHeaders {
            for key in extraHeaders.keys {
                if let value = extraHeaders[key] {
                    header[key] = value
                }
            }
        }
        return header
    }
    
    
    /// get current authorization token
    ///
    ///
    private func getAuthorizationToken() -> String? {
        return AuthenticationService.accessToken
    }
}


extension APIServiceManager: NetworkManagerDelegate {
    func prehandleResponseData(_ manager: NetworkManager, response: ResponseData, forAuthenticate: Bool) {
        if let serverTime = response.requestInfo.responseHeaders["x-lozi-server-time"],
            let serverTimeValue = Double.init(serverTime) {
            let date = Date.init(timeIntervalSince1970: serverTimeValue)
            // handle save server time here
        }
        
        if let responseData = response.value as? [String:AnyObject] {
            if forAuthenticate == true {
                // get authorization token here
                setAuthorizationTokenFrom(json: responseData)
            }
            
        }
    }
    
    func prehandleErrorData(_ manager: NetworkManager, error: ErrorData) {
        if error.code <= 502,
            let serverTime = error.requestInfo.responseHeaders["x-lozi-server-time"],
            let serverTimeValue = Double.init(serverTime) {
            let date = Date.init(timeIntervalSince1970: serverTimeValue)
            // handle save server time here
        }
    }
    
    
}
