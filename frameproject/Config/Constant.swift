//
//  Constant.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

class Constant {
    
    static var bundleIdentifier: String {
        if let key = bundleMainInfo?[kCFBundleIdentifierKey as String] as? String {
            return key
        }
        return ""
    }
    
    static var bundleMainInfo: [String: Any]? {
        return Bundle.main.infoDictionary
    }
}
