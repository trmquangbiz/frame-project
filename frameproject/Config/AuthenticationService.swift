//
//  AuthenticationService.swift
//  frameproject
//
//  Created by Quang Trinh on 22/12/2022.
//

import Foundation
import UIKit
import RealmSwift
final class AuthenticationService {
    static var accessToken: String? {
        return (UserDefaults.standard.object(forKey: Constant.kAccessToken) as? String)
    }
    static var currentUserId: Int? {
        return (UserDefaults.standard.object(forKey: Constant.kCurrentUserId) as? Int)
    }
}
