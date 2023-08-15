//
//  SampleListWireFrameProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import Foundation

protocol SampleListWireFrameProtocol: AnyObject {
    static func createSampleListViewController() -> SampleListViewController?
    func pushSampleDetail(id: Int, from view: SampleListViewProtocol)
}
