//
//  AuthenticationRequest.swift
//  frameproject
//
//  Created by Quang Trinh on 06/09/2023.
//

import Foundation

class AuthenticationRequest: Encodable {
    var countryCode: String
    var phone: String
    var password: String
    
    init(countryCode: String, phone: String, password: String) {
        self.countryCode = countryCode
        self.phone = phone
        self.password = password
    }
}
