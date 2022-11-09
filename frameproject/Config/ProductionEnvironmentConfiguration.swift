//
//  ProductionEnvironmentConfiguration.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

class ProductionEnvironmentConfiguration: EnvironmentConfiguration {
    var baseRequestURL: String = "https://mocha.lozi.vn/v6"
    
    var uploadImageURL: String = "https://latte.lozi.vn/v1.2/upload/images"
    
    var loziBaseRequestURL: String = "https://latte.lozi.vn/v1.2"
    
    var baseLoshipWebURL: String = "https://loship.vn"
    
    var domain: String = "loship.vn"
    
    var chatHost: String = "coffee.lozi.vn"
    
    var port: UInt32 = 1883
    
    var shortLinkDomain: String = "lzi.vn"
    
    var shortLinkURLPrefix: String = "https"
    
    var reviewExceptedIds: [Int] = [16765785]
    
    var spotlightDomainIdentifier: String = "loship.user.spotlight.production"
    
    
}
