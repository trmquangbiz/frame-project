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
    
    var baseRequestDomain: String?{
        get {
            
            return model?.baseRequestDomain
        }
    }
    var baseRequestScheme: String? {
        get {
            return model?.baseRequestScheme
        }
    }
    var baseRequestPortNumber: Int? {
        get {
            return model?.baseRequestPortNumber
        }
    }
    var uploadImagePath: String? {
        get {
            return model?.uploadImagePath
        }
    }
}
