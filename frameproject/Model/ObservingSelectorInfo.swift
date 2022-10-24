//
//  ObservingSelectorInfo.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import Foundation

struct ObservingSelectorInfo{
    var selector: Selector
    var thread: Thread
    
    init (selector: Selector, thread: Thread) {
        self.selector = selector
        self.thread = thread
    }
}
