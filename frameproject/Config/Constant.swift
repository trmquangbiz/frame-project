//
//  Constant.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation
import UIKit
class Constant {
    
    static var bundleIdentifier: String {
        if let key = bundleMainInfo?[kCFBundleIdentifierKey as String] as? String {
            return key
        }
        return ""
    }
    
    static var bundleMainInfo: [String: Any]? {
        return Bundle.main.infoDictionary
    }
    
    // MARK: - Status local key
    static let kLanguage: String = "language"
    
    static let kHeaderAccessToken = "Access-Token"
    static let kContentType = "Content-Type"
    static let kAcceptLanguage = "Accept-Language"
    
    static let kData: String = "data"
    static let kAccessToken: String = "accessToken"
    static let kTmpAccessToken: String = "tmpAccessToken"
    static let kId = "id"
    
    static let kCurrentUserId = "currentUserId"
    
    // MARK: - Constant for pagination
    static let kTotal = "total"
    static let kPage = "page"
    static let kNextUrl = "nextUrl"
    static let kPagination = "pagination"
    
    static let kStoredUUID = "storedUUID"
    static let kAPNDeviceToken = "apnDeviceToken"
    
    static let phoneNumberFormatRegex = "^0?\\d{4,16}$"
    
}
