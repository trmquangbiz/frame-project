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
    var environmentConfig: EnvironmentConfiguration
    
    var baseRequestURL: String {
        get {
            return environmentConfig.baseRequestURL
        }
    }
    var uploadImageURL: String {
        get {
            return environmentConfig.uploadImageURL
        }
    }
    
    init () {
        #if DEBUG
            environmentConfig = DevelopmentEnvironmentConfiguration()
        #else
            environmentConfig = ProductionEnvironmentConfiguration()
        #endif
    }
}
