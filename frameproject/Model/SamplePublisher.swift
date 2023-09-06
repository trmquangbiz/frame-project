//
//  SamplePublisher.swift
//  frameproject
//
//  Created by Quang Trinh on 02/09/2023.
//

import Foundation
import Combine

class SamplePublisher<Value>: Publisher where Value: SamplePublisherOutput {
    func receive<S>(subscriber: S) where S : Subscriber, SamplePublisherError == S.Failure, Value == S.Input {
        subject.receive(subscriber: subscriber)
    }

    private (set) var subject: CurrentValueSubject<Output, Failure>
    enum SamplePublisherError: Error {
        
    }
    init(wrappedValue initialValue: Value) {
        subject = CurrentValueSubject(initialValue)
    }
    typealias Output = Value
    
    typealias Failure = SamplePublisherError
    
}
