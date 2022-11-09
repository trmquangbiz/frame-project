//
//  DevelopmentEnvironmentConfiguration.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

class DevelopmentEnvironmentConfiguration: EnvironmentConfiguration {
    let baseRequestURL: String = "https://lungo.lozi.space/v6"
    
    let uploadImageURL: String = "https://macchiato.lozi.space/v1/upload/images"
    
    let loziBaseRequestURL: String = "https://macchiato.lozi.space/v1"
    
    let baseLoshipWebURL: String = "https://creme.lozi.space"
    
    let domain: String = "creme.lozi.space"
    
    let chatHost: String = "macchiato.lozi.space"
    
    let port: UInt32 = 1883
    
    let shortLinkDomain: String = "https"
    
    let shortLinkURLPrefix: String = "https"
    
    let reviewExceptedIds: [Int] = []
    
    let spotlightDomainIdentifier: String = "loship.user.spotlight.development"
    
    
}
