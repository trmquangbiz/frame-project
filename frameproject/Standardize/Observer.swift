//
//  Observer.swift
//  frameproject
//
//  Created by Quang Trinh on 07/01/2023.
//

import Foundation

struct Observer: Equatable, Hashable {
    var object: NSObject
    
    init(object: NSObject) {
        self.object = object
    }
    
    static func == (lhs: Observer, rhs: Observer) -> Bool {
        return lhs.object == rhs.object
    }
}


