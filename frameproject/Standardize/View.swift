//
//  View.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import Foundation
import UIKit

class View: UIView {
    
    private var observableHandlingMap: [ObservingInfo: ObservingSelectorInfo] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutView()
    }
    
    /// please implement your  layout here
    func layoutView() {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    /// Only setup IBOutlet and layout logic here, don't use data from outside yet
    func setupView() {
        
    }
    
    /// deinit code block, which contains function unregisterViewObserver
    deinit {
        unregisterAllObservers()
    }
    
    
    /// Use this with caution, it will remove all observers you added by addSafeObserver method, this method also called in deinit code block, so no need to call remove observer in deinit anymore
    final func unregisterAllObservers() {
        removeViewObservers()
    }
    
    /// Implement this when you have registered any observer in addViewObserver, this code block is called once in deinit
    private func removeViewObservers() {
        let keys = observableHandlingMap.keys
        keys.forEach { key in
            key.object.removeObserver(self, forKeyPath: key.keyPath)
            removeSafeObserverOnMap(key: key)
        }
    }
    
    /// Don't override this anymore, this is 2022, and I'm smart enough to make you forget this
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object as? NSObject else {
            Debugger.debug("object is null")
            return
        }
        guard let keyPath = keyPath else {
            Debugger.debug("keyPath is null")
            return
        }
        guard let selectorInfo = observableHandlingMap[ObservingInfo.init(keyPath: keyPath, object: object)] else {
            Debugger.debug("Selector not add to handling map with keyPath \(keyPath) and \(object.debugDescription). Please use addSafeObserver method to add on class \(String.init(describing: self))" )
            return
        }
        perform(selectorInfo.selector, on: selectorInfo.thread, with: nil, waitUntilDone: false)
    }
    
    
    /// Smart add observer method that allows to add safe observer without the fear of being crashed
    final func addSafeObserver(_ observer: NSObject,
                         forKeyPath keyPath: String,
                         selector: Selector,
                         thread: Thread = Thread.main) {
        // check if exist
        guard let _ = observableHandlingMap[ObservingInfo.init(keyPath: keyPath, object: observer)] else {
            // if not exist, add a new
            observer.addObserver(self, forKeyPath: keyPath, context: nil)
            observableHandlingMap[ObservingInfo.init(keyPath: keyPath, object: observer)] = ObservingSelectorInfo.init(selector: selector,
                                                                                                                     thread: thread)
            return
        }
        // if already exist in map, remove observer, add new one and replace new selector info
        removeSafeObserver(observer, forKeyPath: keyPath)
        observer.addObserver(self, forKeyPath: keyPath, context: nil)
        observableHandlingMap[ObservingInfo.init(keyPath: keyPath,
                                                 object: observer)] = ObservingSelectorInfo.init(selector: selector,
                                                                                               thread: thread)
    }
   
    /// Smart remove observer method that allows to remove safe observer without of being crashed
    final func removeSafeObserver(_ observer: NSObject,
                            forKeyPath keyPath: String) {
        guard let _ = observableHandlingMap[ObservingInfo.init(keyPath: keyPath,
                                                               object: observer)] else {
            // if not exist, do nothing
            return
        }
        observer.removeObserver(self, forKeyPath: keyPath)
        removeSafeObserverOnMap(key: ObservingInfo.init(keyPath: keyPath,
                                                        object: observer))
    }
    
    private func removeSafeObserverOnMap(key: ObservingInfo) {
        observableHandlingMap.removeValue(forKey: key)
    }
    
    
    
    class func nibName() -> String {
        return String.init(describing: self)
    }
    /// To use this, make sure your nibName is the same with class
    class func initWithNib() -> Self {
        return ViewUtility.viewFrom(nibName()) as! Self
    }
}
