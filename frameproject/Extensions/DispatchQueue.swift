//
//  DispatchQueue.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

extension DispatchQueue {
    enum DefaultQueueNamePrefix: String {
        case serial = "serial"
        case concurrent = "concurrent"
    }
    
    enum CustomQueueName: String {
        case networkManager = "networkmanager"
        case observableArray = "observablearray"
    }
    
    private static func makeSession() -> String {
        return "\(Date().timeIntervalSince1970)"
    }
    
    static func makeCustomQueue(type: DefaultQueueNamePrefix, name: CustomQueueName) -> DispatchQueue {
        return DispatchQueue.init(label: "\(Constant.bundleIdentifier).queue.\(type.rawValue).\(name.rawValue).\(makeSession())")
    }
}
