//
//  EnvironmentConfiguration.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

protocol EnvironmentConfiguration {
    let baseRequestURL: String {get set}
    let uploadImageURL: String {get set}
    let loziBaseRequestURL: String {get set}
    let baseLoshipWebURL: String {get set}
    let domain: String {get set}
    let chatHost: String {get set}
    let port: UInt32 {get set}
    let shortLinkDomain: String {get set}
    let shortLinkURLPrefix: String {get set}
//    var zalopayInviroment: ZPZPIEnvironment!
    let reviewExceptedIds: [Int] {get set}
    let spotlightDomainIdentifier: String {get set}
}
