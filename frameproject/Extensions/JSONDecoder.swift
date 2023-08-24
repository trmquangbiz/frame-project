//
//  JSONDecoder.swift
//  frameproject
//
//  Created by Quang Trinh on 24/08/2023.
//

import Foundation

extension JSONDecoder {
    func map<T: Decodable>(_ type: T.Type, from dict: [String: Any]) -> T? {
        if let data = dict.data {
            do {
                let object = try decode(T.self, from: data)
                return object
            }
            catch {
                return nil
            }
        }
        return nil
    }
}
