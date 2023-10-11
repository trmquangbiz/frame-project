//
//  LocalListFetcherProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 11/10/2023.
//

import Foundation


protocol LocalListFetcherProtocol {
    associatedtype List: Sequence
    func get(predicate: NSPredicate?, sortDescriptors: [Any]) throws -> List
    func write(from list: [List.Element]) throws
    func delete(predicate: NSPredicate?) throws
    func delete(_ list: List) throws
}

extension LocalListFetcherProtocol {
    func get(_ predicateFormat: String?, _ args: Any..., sortDescriptors: [Any]) throws -> List {
        var predicate: NSPredicate?
        if let predicateFormat = predicateFormat {
            predicate = NSPredicate(format: predicateFormat, argumentArray: unwrapOptionals(in: args))
        }
        do {
            let list = try get(predicate: predicate, sortDescriptors: sortDescriptors)
            return list
        } catch {
            throw error
        }
    }
    
    func unwrapOptionals(in varargs: [Any]) -> [Any] {
        return varargs.map { arg in
            if let someArg = arg as Any? {
                return someArg
            }
            return NSNull()
        }
    }
    
    func delete(_ predicateFormat: String?, _ args: Any...) throws {
        var predicate: NSPredicate?
        if let predicateFormat = predicateFormat {
            predicate = NSPredicate(format: predicateFormat, argumentArray: unwrapOptionals(in: args))
        }
        do {
            try delete(predicate: predicate)
        }
        catch {
            throw error
        }
    }
}
