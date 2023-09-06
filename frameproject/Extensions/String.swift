//
//  String.swift
//  frameproject
//
//  Created by Quang Trinh on 25/10/2022.
//

import Foundation

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
}
extension String {
    var dataFormat: Data? {
        return data(using: .utf8)
    }
    var dictionary: [String: Any]? {
        if let data = dataFormat {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
        
    }
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var base64InputHMAC: String? {
        get {
            if let utf8Str = data(using: .utf8) {
                return utf8Str.base64EncodedString(options: .init(rawValue: 0))
            }
            return nil
        }
    }
    
    var base64Decoded: String? {
        get {
            if let decodedData = Data(base64Encoded: self), let decodedString = String(data: decodedData, encoding: .utf8){
                return decodedString
            }
            return nil
        }
        
    }
    
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = cString(using: String.Encoding.utf8)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: algorithm.digestLength())
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, Int(key.lengthOfBytes(using: .utf8)), cData!, Int(lengthOfBytes(using: .utf8)), result)
        let digest = stringFromResult(result: result, length: algorithm.digestLength())
        result.deallocate()

        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
    func isMatchWithRegex(regexStr: String) -> Bool {
        do {
            let regex = try NSRegularExpression.init(pattern: regexStr, options: [])
            if let result = regex.firstMatch(in: self, options: [], range: NSRange.init(location: 0, length: self.count)) {
                let str = String(self[Range(result.range, in: self)!])
                if str == self {
                    return true
                }
                
            }
            return false
        }
        catch {
            return false
        }
    }
    func isCorrectPhoneNumberFormat() -> Bool {
        return isMatchWithRegex(regexStr: Constant.phoneNumberFormatRegex)
    }
    
    func toDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            } catch {
                Debugger.debug("Convert string to dictionary fail: " + error.localizedDescription)
            }
        }
        return nil
    }
}
