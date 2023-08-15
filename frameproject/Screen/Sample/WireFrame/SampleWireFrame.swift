//
//  SampleWireFrame.swift
//  frameproject
//
//  Created by Quang Trinh on 03/08/2023.
//

import Foundation

class SampleWireFrame: SampleWireFrameProtocol {
    
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


