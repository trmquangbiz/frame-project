//
//  LocalObjectFetcherProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 11/10/2023.
//

import Foundation


protocol LocalObjectFetcherProtocol {
    associatedtype Element
    func get(id: Any) throws -> Element?
    func write(from object: Element) throws
    func delete(id: Any) throws
    func delete(obj: Element) throws
}
