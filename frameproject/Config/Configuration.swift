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
    var loziBaseRequestURL: String {
        get {
            return environmentConfig.loziBaseRequestURL
        }
    }
    var baseLoshipWebURL: String {
        get {
            return environmentConfig.baseLoshipWebURL
        }
    }
    var domain: String {
        get {
            return environmentConfig.domain
        }
    }
    var chatHost: String {
        get {
            return environmentConfig.chatHost
        }
    }
    var port: UInt32 {
        get {
            return environmentConfig.port
        }
    }
    var shortLinkDomain: String {
        get {
            return environmentConfig.shortLinkDomain
        }
    }
    var shortLinkURLPrefix: String {
        get {
            return environmentConfig.shortLinkURLPrefix
        }
    }
    var reviewExceptedIds: [Int] {
        get {
            return environmentConfig.reviewExceptedIds
        }
    }
    var spotlightDomainIdentifier: String {
        get {
            return environmentConfig.spotlightDomainIdentifier
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
