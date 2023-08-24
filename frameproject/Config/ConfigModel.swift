//
//  ConfigModel.swift
//  frameproject
//
//  Created by Quang Trinh on 24/08/2023.
//

import Foundation

class ConfigModel: Decodable {
    var baseRequestURL: String = ""
    var uploadImageURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case baseRequestURL = "baseRequestURL"
        case uploadImageURL = "uploadImageURL"
    }
}
