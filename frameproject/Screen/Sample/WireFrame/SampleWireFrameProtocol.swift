//
//  SampleWireFrameProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 03/08/2023.
//

import Foundation

protocol SampleWireFrameProtocol: AnyObject {
    static func createSampleViewController(sampleId: Int) -> SampleViewController?
    func pushSampleView(of sampleId: Int, from view: SampleViewProtocol)
}
