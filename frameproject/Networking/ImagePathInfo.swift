//
//  ImagePathInfo.swift
//  frameproject
//
//  Created by Quang Trinh on 31/08/2022.
//

import Foundation
/// - Info format:
/// -       "key": <parameter name - Required Value>,
/// -       "path": <file path in local - Required Value>,
/// -       "fileName": <custom file name - Optional Value>,
/// -       "mimeType": <custom mime type - Optional Value>
struct ImagePathInfo {
    
    var name: String
    var path: String
    var fileName: String?
    var mimeType: String?
    
    init(name: String,
         path: String,
         fileName: String? = nil,
         mimeType: String? = nil) {
        self.name = name
        self.path = path
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
