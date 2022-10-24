//
//  ErrorData.swift
//  frameproject
//
//  Created by Quang Trinh on 20/08/2022.
//

import Foundation

class ErrorData {
    var code: Int
    var value: Any
    var requestInfo: NetworkRequestInfo
    init(code: Int, value: Any, requestInfo: NetworkRequestInfo) {
        self.code = code
        self.value = value
        self.requestInfo = requestInfo
    }
}
