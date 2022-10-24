//
//  SampleViewController.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import UIKit

class SampleViewController: ViewController {
    @objc dynamic var sampleObservingObj = SampleNSObjectClass()
    var radioButtonView = DesignSystem.View.radioButtonView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Debugger.debug(sampleObservingObj.subscribedSampleKeyPath)
        // Hello! Any change call me?
    }
    
    override func setupView() {
        super.setupView()
        radioButtonView.outerBoxHeight = 24
        radioButtonView.innerCoreHeight = 12
        radioButtonView.isOn = false
        view.addSubviewForLayout(radioButtonView)
        NSLayoutConstraint.activate([radioButtonView.relationCenterX(to: view),
                                     radioButtonView.relationCenterY(to: view)])
        
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
    
    deinit {
        // Who care, it will remove observers automatically
    }

}
