//
//  LoadingRequestCounter.swift
//  frameproject
//
//  Created by Quang Trinh on 03/08/2023.
//

import Foundation


class LoadingRequestCounter {
    private(set) var reloadRequestToComplete: Int = 0
    private var queue: DispatchQueue
    private var completion: (()->())
    
    init(queueName: String, completion: @escaping (()->())) {
        self.queue = DispatchQueue.init(label: queueName)
        self.completion = completion
    }
    func set(numberOfRequest: Int) {
        queue.async {[weak self] in
            if let weakSelf = self {
                weakSelf.reloadRequestToComplete = numberOfRequest
            }
        }
        
    }
    
    func addRequest() {
        queue.async {[weak self] in
            if let weakSelf = self {
                weakSelf.reloadRequestToComplete += 1
            }
        }
    }
    func completeRequest() {
        queue.async { [weak self] in
            if let weakSelf = self {
                weakSelf.reloadRequestToComplete -= 1
                if weakSelf.reloadRequestToComplete <= 0 {
                    weakSelf.completion()
                }
            }
        }
    }
}
