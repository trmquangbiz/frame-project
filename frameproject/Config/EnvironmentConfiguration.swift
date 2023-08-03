//
//  EnvironmentConfiguration.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

protocol EnvironmentConfiguration {
    var baseRequestURL: String {get set}
    var uploadImageURL: String {get set}
}
