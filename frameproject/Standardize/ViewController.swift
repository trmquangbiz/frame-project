//
//  ViewController.swift
//  frameproject
//
//  Created by Quang Trinh on 29/07/2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    private var isFirstTimesViewWillAppear = true
    private var isFirstTimesViewDidAppear = true
    private var observableHandlingMap: [ObservingInfo: ObservingSelectorInfo] = [:]
    private lazy var initNavigationTitle: String = Self.storyBoardId()
    private var isHaveTitleView: Bool = false
    var viewIsLoaded: Bool {
        return _viewIsLoaded
    }
    private var _viewIsLoaded: Bool = false
    var viewIsAppeared: Bool {
        return _viewIsAppeared
    }
    private var _viewIsAppeared: Bool = false
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _viewIsLoaded = true
        setupView()
        registerViewObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstTimesViewWillAppear {
            firstTimesViewWillAppear()
            isFirstTimesViewWillAppear = false
        }
        if isHaveTitleView {
            // set navigationItem.titleView here
        }
        else {
            navigationItem.title = initNavigationTitle
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _viewIsAppeared = true
        if isFirstTimesViewDidAppear {
            firstTimesViewDidAppear()
            isFirstTimesViewDidAppear = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _viewIsAppeared = false
    }
    
    
    deinit {
        unregisterAllObservers()
    }
    
    func setupView() {
        
    }
    
    /**
     Use this function to setNavigationTitle, so you don't need to set it in viewDidLoad, make you code cleaner. However. if you want to change navigation title during runtime, please set it manually
     */
    final func setNavigationTitle(_ title: String) {
        initNavigationTitle = title
    }
    
    final func registerViewObserver() {
        addViewObservers()
    }
    
    /// Use this to add your view observer, don't forget to implement, this code block is called once in viewDidLoad
    func addViewObservers() {
        
    }
    
    /// Use this with caution, it will remove all observers you added by addSafeObserver method, this method also called in deinit code block
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
    
    func firstTimesViewWillAppear() {
        
    }
    
    func firstTimesViewDidAppear() {
        
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
    
    class func storyBoardName() -> String {
        return ""
    }
    
    class func storyBoardId() -> String {
        return String.init(describing: self)
    }
    
    class func initWithStoryBoard() -> Self? {
        if let vc = ViewUtility.viewController(storyBoardId(), storyboardName: storyBoardName()) as? Self {
            return vc
        }
        return nil
    }
}


