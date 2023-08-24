//
//  ConfigModel.swift
//  frameproject
//
//  Created by Quang Trinh on 24/08/2023.
//

import Foundation

class ConfigModel: Decodable {
    var baseRequestDomain: String?
    var baseRequestScheme: String?
    var baseRequestPortNumber: Int?
    var uploadImagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case baseRequestDomain = "baseRequestDomain"
        case baseRequestScheme = "baseRequestScheme"
        case baseRequestPortNumber = "baseRequestPortNumber"
        case uploadImagePath = "uploadImagePath"
    }
}
