//
//  Data.swift
//  frameproject
//
//  Created by Quang Trinh on 24/10/2022.
//

import Foundation

extension Data {
    var jsonString: String? {
        return String.init(data: self, encoding: .utf8)
    }
}
