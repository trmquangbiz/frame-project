//
//  SampleWireFrame.swift
//  frameproject
//
//  Created by Quang Trinh on 03/08/2023.
//

import Foundation

class SampleWireFrame: SampleWireFrameProtocol {
    func pushSampleView(of sampleId: Int, from view: SampleViewProtocol) {
        if let vc = SampleWireFrame.createSampleViewController(sampleId: sampleId),
            let view = view as? SampleViewController,
            let navigationController = view.navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    static func createSampleViewController(sampleId: Int) -> SampleViewController? {
        if let vc = SampleViewController.initWithStoryBoard() {
            let presenter = SamplePresenter()
            let wireFrame = SampleWireFrame()
            presenter.view = vc
            presenter.wireFrame = wireFrame
            presenter.sampleId = sampleId
            vc.presenter = presenter
            return vc
        }
        return nil
    }
}


