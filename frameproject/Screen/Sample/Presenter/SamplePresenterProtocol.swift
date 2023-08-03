//
//  SamplePresenterProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 03/08/2023.
//

import Foundation
import RealmSwift
protocol SamplePresenterProtocol: AnyObject {
    var view: SampleViewProtocol? {get set}
    var wireFrame: SampleWireFrameProtocol! {get set}
    var sampleId: Int! {get set}
    var sampleObservable: SmartLocalObservable<SampleObject>! {get set}
    var sampleObservableList: SmartLocalObservableList<Results<SampleObject>>! {get set}
    func viewDidLoad()
    func reloadData()
    func loadMore()
    func showDetail(of sampleId: Int)
}
