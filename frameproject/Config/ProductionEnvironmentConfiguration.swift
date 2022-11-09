//
//  ProductionEnvironmentConfiguration.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

class ProductionEnvironmentConfiguration: EnvironmentConfiguration {
    let baseRequestURL: String = "https://mocha.lozi.vn/v6"
    
    let uploadImageURL: String = "https://latte.lozi.vn/v1.2/upload/images"
    
    let loziBaseRequestURL: String = "https://latte.lozi.vn/v1.2"
    
    let baseLoshipWebURL: String = "https://loship.vn"
    
    let domain: String = "loship.vn"
    
    let chatHost: String = "coffee.lozi.vn"
    
    let port: UInt32 = 1883
    
    let shortLinkDomain: String = "lzi.vn"
    
    let shortLinkURLPrefix: String = "https"
    
    let reviewExceptedIds: [Int] = [16765785]
    
    let spotlightDomainIdentifier: String = "loship.user.spotlight.production"
    
    
}
