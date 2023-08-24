//
//  Certificate.swift
//  frameproject
//
//  Created by Quang Trinh on 24/08/2023.
//

import Foundation

struct Certificates {
    static let yourCert = Certificates.certificate(filename: "your.cert.file.name")
  
    private static func certificate(filename: String) -> SecCertificate {
        let filePath = Bundle.main.path(forResource: filename, ofType: "cer")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let certificate = SecCertificateCreateWithData(nil, data as CFData)!
        return certificate
    }
}
