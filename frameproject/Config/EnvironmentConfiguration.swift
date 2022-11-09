//
//  EnvironmentConfiguration.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

protocol EnvironmentConfiguration {
    var baseRequestURL: String {get set}
    var uploadImageURL: String {get set}
    var loziBaseRequestURL: String {get set}
    var baseLoshipWebURL: String {get set}
    var domain: String {get set}
    var chatHost: String {get set}
    var port: UInt32 {get set}
    var shortLinkDomain: String {get set}
    var shortLinkURLPrefix: String {get set}
    var reviewExceptedIds: [Int] {get set}
    var spotlightDomainIdentifier: String {get set}
}
