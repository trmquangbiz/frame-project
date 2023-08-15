//
//  SampleListPresenter.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import Foundation
import RealmSwift

class SampleListPresenter: SampleListPresenterProtocol {
    var sampleObservableList: SmartLocalObservableList<Results<SampleObject>>!
    
    weak var view: SampleListViewProtocol?
    
    var wireFrame: SampleListWireFrameProtocol!
    
    var sampleObjectList: [SampleNameCellModel] = [] {
        didSet {
            if let view = view {
                view.updateView()
            }
        }
    }
    
    func viewDidLoad() {
        sampleObservableList = SampleObject.makeSampleListObservableList()
            .subscribe({[weak self] changes in
                if let weakSelf = self {
                    weakSelf.sampleObjectList = weakSelf.makeMapList()
                }
            })
        sampleObservableList.fetchLocal()
        if let view = view {
            view.beginRefreshing()
        }
    }
    
    func reloadData() {
        sampleObservableList.fetchRemote(queryParams: ["sort": "nearest"],
                                         onSuccess: {[weak self] in
            if let weakSelf = self, let view = weakSelf.view {
                view.endRefreshing()
            }
        }, onFail: {[weak self] errorCode, errorMsg in
            if let weakSelf = self, let view = weakSelf.view {
                view.endRefreshing()
            }
            // show error message if you want
            
        }, onEmpty: {[weak self] in
            if let weakSelf = self, let view = weakSelf.view {
                view.endRefreshing()
            }
            // show empty result
        })

    }
    
    func loadMore() {
        sampleObservableList.loadMore(queryParams: ["sort": "nearest"],
                                      onSuccess: {[weak self] in
            if let weakSelf = self, let view = weakSelf.view {
                view.endLoadMore()
            }
        }, onFail: {[weak self] _,_ in
            if let weakSelf = self, let view = weakSelf.view {
                view.endLoadMore()
            }
        }, onEmpty: {[weak self] in
            if let weakSelf = self, let view = weakSelf.view {
                view.endLoadMore()
            }
        })
    }
    
    func showDetail(sampleId: Int) {
        if let view = view {
            wireFrame.pushSampleDetail(id: sampleId, from: view)
        }
    }
    
    func makeMapList() -> [SampleNameCellModel] {
        if let obj = sampleObservableList.obj, obj.isInvalidated == false {
            return Array(obj).map { e in
                return SampleNameCellModel.init(sample: e)
            }
        }
        return []
    }
    
    func makeTestData() {
        let additionalList: [SampleObject] = [SampleObject.init(JSON: ["id": 1, "name": "Test object 1"])!.makeCompleteData(group: "sampleList", orderNumber: 1),
                                              SampleObject.init(JSON: ["id": 2, "name": "Test object 2"])!.makeCompleteData(group: "sampleList", orderNumber: 2),
                                              SampleObject.init(JSON: ["id": 3, "name": "Test object 3"])!.makeCompleteData(group: "sampleList", orderNumber: 3),
                                              SampleObject.init(JSON: ["id": 4, "name": "Test object 4"])!.makeCompleteData(group: "sampleList", orderNumber: 4),
                                              SampleObject.init(JSON: ["id": 5, "name": "Test object 5"])!.makeCompleteData(group: "sampleList", orderNumber: 5)]
        let realm = try! Realm()
        realm.safeWrite {
            realm.add(additionalList,update: .all)
        }
    }
    func makeLoadMoreTestData() {
        let additionalList: [SampleObject] = [SampleObject.init(JSON: ["id": 6, "name": "Test object 6"])!.makeCompleteData(group: "sampleList", orderNumber: 6),
                                              SampleObject.init(JSON: ["id": 7, "name": "Test object 7"])!.makeCompleteData(group: "sampleList", orderNumber: 7),
                                              SampleObject.init(JSON: ["id": 8, "name": "Test object 8"])!.makeCompleteData(group: "sampleList", orderNumber: 8),
                                              SampleObject.init(JSON: ["id": 9, "name": "Test object 9"])!.makeCompleteData(group: "sampleList", orderNumber: 9),
                                              SampleObject.init(JSON: ["id": 10, "name": "Test object 10"])!.makeCompleteData(group: "sampleList", orderNumber: 10)]
        let realm = try! Realm()
        realm.safeWrite {
            realm.add(additionalList,update: .all)
        }
    }
}
