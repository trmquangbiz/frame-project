//
//  Encodable.swift
//  frameproject
//
//  Created by Quang Trinh on 24/08/2023.
//

import Foundation

extension Encodable {
    func asDictionary()  -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
             return dictionary
        }
        catch {
            return nil
        }
    }
}
