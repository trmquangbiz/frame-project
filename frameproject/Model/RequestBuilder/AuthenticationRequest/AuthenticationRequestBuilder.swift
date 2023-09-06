//
//  AuthenticationRequestBuilder.swift
//  frameproject
//
//  Created by Quang Trinh on 06/09/2023.
//

import Foundation

class AuthenticationRequestBuilder {
    enum RequestError: Error {
        case noCountryCode
        case noPhone
        case phoneInWrongFormat
        case noPassword
    }
    private(set) var countryCode: String?
    private(set) var phone: String?
    private(set) var password: String?

    
    func setCountryCode(_ value: String) {
        self.countryCode = value
    }
    func setPhone(_ value: String) {
        self.phone = value
    }
    
    func setPassword(_ value: String) {
        self.password = value
    }
    
    func build() throws -> AuthenticationRequest {
        guard let countryCode = countryCode else {
            throw RequestError.noCountryCode
        }
        guard let phone = phone, phone.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 else {
            throw RequestError.noPhone
        }
        guard let password = password else {
            throw RequestError.noPassword
        }
        guard phone.isCorrectPhoneNumberFormat() else {
            throw RequestError.phoneInWrongFormat
        }
        let request = AuthenticationRequest.init(countryCode: countryCode, phone: phone, password: password)
        return request
        
    }
}
