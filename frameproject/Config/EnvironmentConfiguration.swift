//
//  EnvironmentConfiguration.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

class EnvironmentConfiguration: EnvironmentConfigurationProtocol {
    var configFileName: String
    
    var model: ConfigModel?
    
    required init(configFileName: String) {
        self.configFileName = configFileName
        
        guard let path = Bundle.main.path(forResource: configFileName, ofType: "plist") else {
            Debugger.debug("Cannot create config file")
            return
        }
        Debugger.debug("Config file path: \(path)")
        guard let myDict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            Debugger.debug("Cannot init config dictionary file")
            return
        }
        guard let model = JSONDecoder().map(ConfigModel.self, from: myDict) else {
            Debugger.debug("Cannot create model")
            return
        }
        self.model = model
    }
    
    
}
