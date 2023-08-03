//
//  SamplePresenter.swift
//  frameproject
//
//  Created by Quang Trinh on 03/08/2023.
//

import Foundation
import RealmSwift

class SamplePresenter: SamplePresenterProtocol {
    
    weak var view: SampleViewProtocol?
    
    var wireFrame: SampleWireFrameProtocol!
    
    var sampleId: Int!
    
    var sampleObservable: SmartLocalObservable<SampleObject>!
    
    var sampleObservableList: SmartLocalObservableList<Results<SampleObject>>!
    
    var loadingRequestCounter: LoadingRequestCounter! = nil
    func viewDidLoad() {
        // Do some setup
        sampleObservable = .init(primaryKeyValue: sampleId!)
            .set(remotePath: .getSampleDetail(sampleId: sampleId))
            .subscribe({[weak self] obj in
                if let weakSelf = self, let view = weakSelf.view {
                    view.updateSampleViewDetail()
                }
            })
        
        sampleObservableList = .init(predicate: "group = 'sampleList'",
                                     sortConditions: [SortDescriptor.init(keyPath: "orderNumber", ascending: true)])
        .set(remotePath: .getSampleList)
        .subscribe({[weak self] changes in
            if let weakSelf = self, let view = weakSelf.view {
                view.updateSampleList()
            }
        })
        
        loadingRequestCounter = LoadingRequestCounter.init(queueName: "frameproject.trmquang.sample.requestcounter") {[weak self] in
            if let weakSelf = self, let view = weakSelf.view {
                view.endReloading()
            }
        }
        
        // time to fetch out
        sampleObservable.fetchLocal()
        sampleObservableList.fetchLocal()
        if let view = view {
            view.beginReloading()
        }
    }
    
    func reloadData() {
        loadingRequestCounter.addRequest()
        sampleObservable.fetchRemote(queryParams: nil,
                                     preprocessObject: nil, onSuccess: {[weak self] in
            if let weakSelf = self {
                weakSelf.loadingRequestCounter.completeRequest()
            }
            
        }, onFail: {[weak self] errorCode, errorMsg in
            if let weakSelf = self {
                weakSelf.loadingRequestCounter.completeRequest()
            }
            // show error message if you want
        })
        
        loadingRequestCounter.addRequest()
        sampleObservableList.fetchRemote(queryParams: ["sort": "nearest"],
                                         preprocessObject: { rawObjectList in
            for i in 0..<rawObjectList.count {
                rawObjectList[i].orderNumber = i
                rawObjectList[i].group = "sampleList"
            }
            return rawObjectList
        }, onSuccess: {[weak self] in
            if let weakSelf = self {
                weakSelf.loadingRequestCounter.completeRequest()
            }
            
        }, onFail: {[weak self] errorCode, errorMsg in
            if let weakSelf = self {
                weakSelf.loadingRequestCounter.completeRequest()
            }
            // show error message if you want
            
        }, onEmpty: {[weak self] in
            if let weakSelf = self {
                weakSelf.loadingRequestCounter.completeRequest()
            }
            // show empty result
        })
    }
    
    func loadMore() {
        sampleObservableList.loadMore(queryParams: ["sort": "nearest"],
                                      preprocessObject: {[weak self] rawObjectList in
            var fromNumber = 0
            if let weakSelf = self,
               let list = weakSelf.sampleObservableList.obj{
                fromNumber = list.count
            }
            for i in 0..<rawObjectList.count {
                rawObjectList[i].orderNumber = fromNumber + i
                rawObjectList[i].group = "sampleList"
            }
            return rawObjectList
        }, onSuccess: {[weak self] in
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
    
    func showDetail(of sampleId: Int) {
        if let view = view {
            wireFrame.pushSampleView(of: sampleId, from: view)
        }
    }
    
    
    
}
