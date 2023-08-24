//
//  EnvironmentConfigurationProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 24/08/2023.
//

import Foundation

protocol EnvironmentConfigurationProtocol: AnyObject {
    var configFileName: String {get set}
    var model: ConfigModel? {get set}
    init(configFileName: String)
}

extension EnvironmentConfigurationProtocol {
    
    var baseRequestURL: String {
        get {
            return model?.baseRequestURL ?? ""
        }
    }
    var uploadImageURL: String {
        get {
            return model?.uploadImageURL ?? ""
        }
    }
}
