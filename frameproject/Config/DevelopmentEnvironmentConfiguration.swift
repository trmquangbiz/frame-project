//
//  DevelopmentEnvironmentConfiguration.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

class DevelopmentEnvironmentConfiguration: EnvironmentConfiguration {
    var baseRequestURL: String = "https://lungo.lozi.space/v6"
    
    var uploadImageURL: String = "https://macchiato.lozi.space/v1/upload/images"
    
    var loziBaseRequestURL: String = "https://macchiato.lozi.space/v1"
    
    var baseLoshipWebURL: String = "https://creme.lozi.space"
    
    var domain: String = "creme.lozi.space"
    
    var chatHost: String = "macchiato.lozi.space"
    
    var port: UInt32 = 1883
    
    var shortLinkDomain: String = "https"
    
    var shortLinkURLPrefix: String = "https"
    
    var reviewExceptedIds: [Int] = []
    
    var spotlightDomainIdentifier: String = "loship.user.spotlight.development"
    
    
}
