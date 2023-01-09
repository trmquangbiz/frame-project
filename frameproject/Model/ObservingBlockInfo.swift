//
//  ObservingBlockInfo.swift
//  frameproject
//
//  Created by Quang Trinh on 07/01/2023.
//

import Foundation


struct ObservingBlockInfo: ObservingActionInfo{
    var block: (_ userInfo: [String:Any]?)->()
    var userInfo: [String: Any]?
    init (userInfo: [String: Any]? ,block: @escaping (_ userInfo: [String:Any]?)->()) {
        self.userInfo = userInfo
        self.block = block
    }
}
