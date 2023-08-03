//
//  Dictionary.swift
//  frameproject
//
//  Created by Quang Trinh on 24/10/2022.
//

import Foundation

extension Dictionary {
    var data: Data? {
        get {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                return jsonData
            }
            catch {
                return nil
            }
        }
    }
    
    var jsonString: String? {
        get {
            return data?.jsonString
        }
    }
}
