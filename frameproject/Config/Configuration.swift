//
//  Configuration.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

class Configuration {
    static let shared: Configuration = {
        var instance = Configuration()
        return instance
    }()
    var environmentConfig: EnvironmentConfigurationProtocol
    
    var baseRequestDomain: String? {
        get {
            return environmentConfig.baseRequestDomain
        }
    }
    var baseRequestScheme: String? {
        get {
            return environmentConfig.baseRequestScheme
        }
    }
    var baseRequestPortNumber: Int? {
        get {
            return environmentConfig.baseRequestPortNumber
        }
    }
    var baseRequestURL: String {
        get {
            guard let scheme = baseRequestScheme,
                  let domain = baseRequestDomain else {
                return ""
            }
            return "\(scheme)://\(domain)" + (baseRequestPortNumber != nil ? ":\(baseRequestPortNumber!)" : "")
        }
    }
    var uploadImageURL: String {
        get {
            let requestURL = baseRequestURL
            guard let uploadImagePath = environmentConfig.uploadImagePath,
                  requestURL.count > 0 else {
                return ""
            }
            return requestURL + "/\(uploadImagePath)" 
        }
    }
    
    init () {
        #if DEBUG
            environmentConfig = EnvironmentConfiguration.init(configFileName: "Development")
        #else
            environmentConfig = EnvironmentConfiguration.init(configFileName: "Production")
        #endif
    }
}
