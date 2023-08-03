//
//  ObservingInfo.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import Foundation


struct ObservingInfo: Equatable, Hashable {
    var keyPath: String
    var object: NSObject
    
    init(keyPath: String, object: NSObject) {
        self.keyPath = keyPath
        self.object = object
    }
    
    static func == (lhs: ObservingInfo, rhs: ObservingInfo) -> Bool {
        return lhs.keyPath ==  rhs.keyPath && lhs.object == rhs.object
    }
}
