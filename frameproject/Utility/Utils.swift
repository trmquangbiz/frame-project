//
//  Utils.swift
//  frameproject
//
//  Created by Quang Trinh on 22/12/2022.
//

import Foundation
import UIKit
import RealmSwift
class Utils {
    
    private class func roundUpForExtraDistance(distance: Int) -> Int {
        // 99
        let extraPart = distance%1000 // 99
        let decimalPart = distance/1000 // 0
        if decimalPart == 0 {
            return 1000
        }
        if extraPart > 99 {
            return (decimalPart + 1) * 1000 // 1000
        }
        return decimalPart * 1000 // 0
    }
    
    class func convertArrayOfIntIntoStringToRequest(list: [Int] ) -> String {
        var str = ""
        if list.count > 0 {
            for i in 0..<list.count {
                if i != 0 {
                    str.append(",")
                    
                }
                str.append("\(list[i])")
            }
        }
        
        return str
    }
    
    class func convertArrayOfObjectIntoStringToRequest<T>(list: [T] ) -> String {
        var str = ""
        if list.count > 0 {
            for i in 0..<list.count {
                if i != 0 {
                    str.append(",")
                    
                }
                str.append("\(list[i])")
            }
        }
        return str
    }
    
    class func mobileJWTStr() -> String? {
        let currentDateInterval = Date().timeIntervalSince1970
        let dateInterval = NSNumber(value: (currentDateInterval)).int64Value
        let inputHMAC = "\(Constant.clientId)|\(dateInterval)"
//        CustomLogger.log("inputHMAC: \(inputHMAC)")
        if let base64InputHMAC = inputHMAC.base64InputHMAC {
//            CustomLogger.log("InputHMAC-base64: \(base64InputHMAC)")
            let hmacSHA256 = base64InputHMAC.hmac(algorithm: .SHA256, key: Constant.JWTSecretKey)
//            CustomLogger.log("HMACSHA256: \(hmacSHA256)")
            return "\(inputHMAC).\(hmacSHA256)"
        }
        return nil
    }
    
    class func  encryptTrackingData(_ data: String) -> String? {
        let inputHMAC = data
        if let base64InputHMAC = inputHMAC.base64InputHMAC {
            let hmacSHA256 = base64InputHMAC.hmac(algorithm: .SHA256, key: Constant.JWTTrackingDataSecretKey)
            return "\(base64InputHMAC).\(hmacSHA256)"
        }
        return nil
    }

    class func encryptDeviceInfoData() -> String {
        if let userId = AuthenticationService.currentUserId {
            let json: [String: Any] = ["deviceId": DeviceUID.uid()!,
                                       "platform": "iOS",
                                       "userId": userId]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let jsonString = String(data: jsonData, encoding: .utf8)!
                if let base64InputHMAC = jsonString.base64InputHMAC {
                    let hmacSHA256 = base64InputHMAC.hmac(algorithm: .SHA256, key: Constant.JWTDeviceInfoSecretKey)
                    return"\(base64InputHMAC).\(hmacSHA256)"
                }
                else {
                    return ""
                }
            } catch {
                return ""
            }
        }
        return ""
        
    }
    class func makeParagraphSpacing(spacing: CGFloat) -> Any {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = spacing
        return paragraphStyle
    }
    
    class func checkIsSessionExpire(session: Date, timeExpire: Int) -> Bool {
        let now = Date.init()
        let calendar = Calendar.current.dateComponents([.second], from: session, to: now)
        if let second = calendar.second, second >= timeExpire {
            return true
        } else {
            return false
        }
    }
}
