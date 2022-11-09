//
//  String.swift
//  frameproject
//
//  Created by Quang Trinh on 25/10/2022.
//

import Foundation


extension String {
    var dictionary: [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
        
    }
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
