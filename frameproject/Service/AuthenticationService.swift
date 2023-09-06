//
//  AuthenticationService.swift
//  frameproject
//
//  Created by Quang Trinh on 22/12/2022.
//

import Foundation
import RealmSwift
class AuthenticationService {
    static let shared: AuthenticationService = {
        var manager = AuthenticationService()
        return manager
    }()
    
    private (set) var accessToken: String?
    

    var currentUserId: Int? {
        return (UserDefaults.standard.object(forKey: Constant.kCurrentUserId) as? Int)
    }
    
    var currentUser: User? {
        return User.current
    }
    
    var isAuthorized: Bool {
        return accessToken != nil
    }
    
    var isHavingOwnerData: Bool {
        return currentUser != nil
    }
    
    func saveUserId(_ value: Int) {
        UserDefaults.standard.set(value, forKey: Constant.kCurrentUserId)
    }
    
    func removeUserId() {
        guard let _ = currentUserId else {
            return
        }
        UserDefaults.standard.removeObject(forKey: Constant.kCurrentUserId)
    }
    
    func setAccessToken(_ value: String) {
        self.accessToken = value
    }
    
    func softLogout() {
        self.accessToken = nil
    }
    
    var currentLoginPhone: String? {
        return UserDefaults.standard.object(forKey: Constant.kCurrentLoginPhone) as? String
    }
    var currentLoginCountryCode: String? {
        return UserDefaults.standard.object(forKey: Constant.kCurrentLoginCountryCode) as? String
    }
    
    func fetchAccessToken(successCompletion: (() -> ())?, failCompletion: ((Int?)->())?) {
        guard let phone = currentLoginPhone,
              let countryCode = currentLoginCountryCode else {
            return
        }
        do {
            let account = "\(countryCode)-\(phone)"
            let passwordData = try Keychain.readPassword(service: "login", account: account)
            if let password = passwordData.string {
                login(request: .init(countryCode: countryCode,
                                     phone: phone,
                                     password: password),
                      successCompletion: successCompletion,
                      failCompletion: failCompletion)
            }
            else {
                Debugger.debug("Canot convert password to string")
            }
        }
        catch {
            Debugger.debug("Fetching passwrod in keychain fail: " + error.localizedDescription)
        }
    }
    
    func saveAccountAndPassword(countryCode: String, phoneNumber: String, password: String) {
        let account = "\(countryCode)-\(phoneNumber)"
        if let passwordData = password.dataFormat {
            UserDefaults.standard.set(phoneNumber, forKey: Constant.kCurrentLoginPhone)
            UserDefaults.standard.set(countryCode, forKey: Constant.kCurrentLoginCountryCode)
            do {
                try Keychain.save(service: "login", account: account, password: passwordData)
            }
            catch {
                if let error = error as? Keychain.KeychainError {
                    switch error {
                    case .itemNotFound:
                        break;
                    case .duplicateItem:
                        updateAccountAndPassword(countryCode: countryCode, phoneNumber: phoneNumber, password: password)
                    case .invalidItemFormat:
                        break;
                    case .unexpectedStatus(_):
                        break;
                    }
                }
            }
        }
    }
    
    func updateAccountAndPassword(countryCode: String, phoneNumber: String, password: String) {
        let account = "\(countryCode)-\(phoneNumber)"
        if let passwordData = password.dataFormat {
            do {
                try Keychain.update(service: "login", account: account, password: passwordData)
            }
            catch {
                if let error = error as? Keychain.KeychainError {
                    Debugger.debug(error.localizedDescription)
                }
            }
        }
    }
    func logout() {
        softLogout()
        if let currentLoginPhone = currentLoginPhone {
            UserDefaults.standard.removeObject(forKey: Constant.kCurrentLoginPhone)
            UserDefaults.standard.removeObject(forKey: Constant.kCurrentLoginCountryCode)
            do {
                try Keychain.deletePassword(service: "login", account: currentLoginPhone)
            } catch {

            }
        }
        
    }
    
    func login(request: AuthenticationRequest, successCompletion: (() -> ())?, failCompletion: ((Int?)->())?) {
        APIServiceManager.shared.postAndResponseObject(endPoint: APIPath.login.path,
                                                       requestBody: request.asDictionary(),
                                                       forAuthenticate: true,
                                                       objectType: User.self) {response in
            switch response {
            case .success(statusCode: _, responseObject: let responseObject):
                self.saveAccountAndPassword(countryCode: request.countryCode, phoneNumber: request.phone, password: request.password)
                guard let user = responseObject else {
                    if let completion = successCompletion {
                        completion()
                    }
                    return
                    
                }
                let userId = user.id
                let realm = try! Realm()
                realm.safeWrite {
                    realm.add(user, update: .all)
                }
                
                self.saveUserId(userId)
                if let completion = successCompletion {
                    completion()
                }
            case .fail(statusCode: let statusCode, errorMsg: let errorMsg):
                if statusCode == 400,
                   let errorInfo = errorMsg as? [String: Any],
                    let code = errorInfo["code"] as? Int{
                    if let completion = failCompletion {
                        completion(code)
                    }
                }
                else {
                    if let completion = failCompletion {
                        completion(nil)
                    }
                }
            }
        }
    }
}
