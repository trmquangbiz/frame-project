//
//  ObservableArray.swift
//  frameproject
//
//  Created by Quang Trinh on 18/11/2022.
//

import Foundation


class ObservableArray<Element: Any>: ExpressibleByArrayLiteral  {
    
    
    fileprivate var contents: [Element] = [] {
        didSet {
            contentsDidChange()
        }
    }

    fileprivate var observerInfo: [Observer: ObservingActionInfo] = [:]
    
    var count: Int {
        return contents.count
        
    }
    
    var first: Element? {
        return contents.first
    }
    
    var last: Element? {
        return contents.last
    }
    
    var isEmpty: Bool {
        return contents.isEmpty
    }
    
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        for element in sequence {
            append(element)
        }
    }
    
    var startIndex: Int {
        return contents.startIndex
    }
    
    var endIndex: Int {
        return contents.endIndex
    }
    
    func append(_ newElement: Element) {
        contents.append(newElement)
    }
    
   func append<S>(contentsOf newElements: S) where S.Element == Element, S: Sequence {
        contents.append(contentsOf: newElements)
    }
    
    func replace<S>(contentsOf newElements: S) where S.Element == Element, S: Sequence {
        var s: [Element] = []
        s.append(contentsOf: newElements)
        self.contents = s
    }
    
    func firstIndex(of element: Element) -> Int? where Element: Hashable{
        return contents.firstIndex(of: element)
    }
    
    func lastIndex(of element: Element) -> Int? where Element: Hashable{
        return contents.lastIndex(of: element)
    }
    
    func removeAt(at index: Int) -> Element? {
        return contents.remove(at: index)
    }
    
    func removeFirst() -> Element? {
        return contents.removeFirst()
    }
    
    func removeAll() {
        contents.removeAll()
    }
    
    func insert(_ newElement: Element, at index: Int) {
        contents.insert(newElement, at: index)
    }
    
    func first(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        return try contents.first(where: predicate)
    }
    
    func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        return try contents.firstIndex(where: predicate)
    }
    
    func last(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        return try contents.last(where: predicate)
    }
    
    func lastIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        return try contents.lastIndex(where: predicate)
    }
    
    func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        return try contents.filter(isIncluded)
    }
    
    private func contentsDidChange() {
        for key in observerInfo.keys {
            if let action = observerInfo[key] {
                if let action = action as? ObservingSelectorInfo {
                    key.object.perform(action.selector)
                }
                else if let action = action as? ObservingBlockInfo {
                    action.block(action.userInfo)
                }
            }
        }
    }
    
    func registerChange(object: NSObject, thread: Thread = Thread.current, selector: Selector) {
        let observer = Observer.init(object: object)
        let action = ObservingSelectorInfo.init(selector: selector, thread: thread)
        observerInfo[observer] = action
    }
    
    
    func registerChange(object: NSObject, userInfo: [String: Any]? = nil, _ changeAction: @escaping ([String:Any]?)->()) {
        let observer = Observer.init(object: object)
        let action = ObservingBlockInfo.init(userInfo: userInfo, block: changeAction)
        observerInfo[observer] = action
    }
    
    func removeObserver(object: NSObject) {
        let observer = Observer.init(object: object)
        if observerInfo[observer] != nil {
            observerInfo.removeValue(forKey: observer)
        }
    }
    
    func removeAllObserver() {
        observerInfo.removeAll()
    }
    
    typealias ArrayLiteralElement = Element
    
    convenience required init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension ObservableArray: CustomStringConvertible {
    var description: String {
        return String.init(describing: contents)
    }
    
    
}
extension ObservableArray: Sequence {
    
    typealias Iterator = IndexingIterator<Array<Element>>
    
    func makeIterator() -> Iterator {
        return contents.makeIterator()
    }
}
