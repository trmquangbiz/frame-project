//
//  NetworkServiceConfigProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 13/08/2022.
//

import Foundation


protocol NetworkServiceConfigProtocol: AnyObject {
    var maxNumberRequest: Int { get }
    var timeoutInterval: Double { get }
    var additionalHeadersForRequest: [String: String] {get set}
    var allowCellularAccess: Bool {get set}
    init (maxNumberRequest: Int,
          timeoutInterval: Double,
          additionalHeadersForRequest: [String: String],
          allowCellularAccess: Bool)
}
