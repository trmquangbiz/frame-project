//
//  TestObject.swift
//  frameproject
//
//  Created by Quang Trinh on 20/12/2022.
//

import Foundation

class TestObject: CustomStringConvertible {

    var name: String = ""
    
    init (name: String) {
        self.name = name
    }
    
    var description: String {
        return String.init(describing: type(of: self)) + " with " + name
    }
}
