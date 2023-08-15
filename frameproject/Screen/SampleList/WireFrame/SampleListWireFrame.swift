//
//  SampleListWireFrame.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import Foundation

class SampleListWireFrame: SampleListWireFrameProtocol {
    func pushSampleDetail(id: Int, from view: SampleListViewProtocol) {
        if let vc = SampleWireFrame.createSampleViewController(sampleId: id), let view = view as? SampleListViewController, let navigationController = view.navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    static func createSampleListViewController() -> SampleListViewController? {
        if let vc = SampleListViewController.initWithStoryBoard() {
            let presenter = SampleListPresenter()
            let wireFrame = SampleListWireFrame()
            presenter.view = vc
            presenter.wireFrame = wireFrame
            vc.presenter = presenter
            
            return vc
        }
        
        return nil
    }
    
    
}
