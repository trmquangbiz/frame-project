//
//  SampleViewController.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import UIKit
import RealmSwift

class SampleViewController: ViewController {
    @objc dynamic var sampleObservingObj = SampleNSObjectClass()
    var radioButtonView = DesignSystem.View.radioButtonView
    
    let radioButtonInteractiveView = UIView()
    
    var testLbl = UILabel()
    
    var testObjectList: ObservableArray<TestObject> = [TestObject.init(name: "a"),
                                                       TestObject.init(name: "b"),
                                                       TestObject.init(name: "c"),
                                                       TestObject.init(name: "d")]
    var presenter: SamplePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Debugger.debug(sampleObservingObj.subscribedSampleKeyPath)
        // Hello! Any change call me?
        let copiedObjectList = testObjectList
        for obj in copiedObjectList {
            Debugger.debug(obj)
        }
        presenter.viewDidLoad()
        radioButtonInteractiveView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(radioButtonInteractiveView_Tap)))
    }
    
    deinit {
        // Who care, it will remove observers automatically
    }
    
    override func setupView() {
        super.setupView()
        radioButtonView.outerBoxHeight = 24
        radioButtonView.innerCoreHeight = 12
        radioButtonView.isOn = false
        view.addSubviewForLayout(radioButtonView)
        NSLayoutConstraint.activate([radioButtonView.alignTop(to: view.safeAreaLayoutGuide, space: 15),
                                     radioButtonView.alignLeading(to: view!, space: 15)])
        
        
        radioButtonInteractiveView.backgroundColor = UIColor.clear
        radioButtonInteractiveView.isUserInteractionEnabled = true
        view.addSubviewForLayout(radioButtonInteractiveView)
        NSLayoutConstraint.activate([radioButtonInteractiveView.configWidth(30),
                                     radioButtonInteractiveView.configHeight(30),
                                     radioButtonInteractiveView.relationCenterX(to: radioButtonView),
                                     radioButtonInteractiveView.relationCenterY(to: radioButtonView)])
        
        
        testLbl.numberOfLines = 0
        view.addSubviewForLayout(testLbl)
        testLbl.setContentHuggingPriority(.init(1000), for: .vertical)
        testLbl.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        NSLayoutConstraint.activate([testLbl.spacingTop(to: radioButtonView, space: 15),
                                     testLbl.alignLeading(to: view!, space: 15),
                                     view.alignTrailing(to: testLbl, space: 15)])
        
        testLbl.text = "Hello, World!"
        
        
    }
    
    
    override func addViewObservers() {
        super.addViewObservers()
        addSafeObserver(sampleObservingObj, forKeyPath: #keyPath(SampleNSObjectClass.subscribedSampleKeyPath), selector: #selector(receiveChange))
    }
    
    override func firstTimesViewDidAppear() {
        super.firstTimesViewDidAppear()
        sampleObservingObj.subscribedSampleKeyPath = "Yes, it is me, your father!"
        radioButtonView.toggle(isOn: true)
//        radioButtonView.showHideDirection = .vertical
//        radioButtonView.show()
//        radioButtonView.hide()
    }
    
    @objc func receiveChange() {
        Debugger.debug("Did receive change with new value: \(sampleObservingObj.subscribedSampleKeyPath)")
    }
    
    @objc func radioButtonInteractiveView_Tap() {
        radioButtonView.toggle(isOn: !radioButtonView.isOn)
    }
    
    
    override class func storyBoardName() -> String {
        return "Sample"
    }

}

extension SampleViewController: SampleViewProtocol {
    func updateSampleViewDetail() {
        
    }
    
    func updateSampleList() {
        
    }
    
    func endReloading() {
        
    }
    
    func endLoadMore() {
        
    }
    
    func beginReloading() {
        
    }
    
    
}
