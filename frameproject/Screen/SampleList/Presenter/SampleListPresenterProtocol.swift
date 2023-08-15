//
//  SampleListPresenterProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import Foundation
import RealmSwift

protocol SampleListPresenterProtocol: AnyObject {
    var view: SampleListViewProtocol? {get set}
    var wireFrame: SampleListWireFrameProtocol! {get set}
    var sampleObservableList: SmartLocalObservableList<Results<SampleObject>>! {get set}
    var sampleObjectList: [SampleNameCellModel] {get set}
    func viewDidLoad()
    func reloadData()
    func showDetail(sampleId: Int)
    func loadMore()
}
