//
//  NetworkServiceConfigProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 13/08/2022.
//

import Foundation


protocol NetworkServiceConfigProtocol: AnyObject {
    var maxNumberRequest: Int { get }
    var timeoutInterval: Int { get }
    init (maxNumberRequest: Int, timeoutInterval: Int)
}
