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
        
        loadingRequestCounter = LoadingRequestCounter.init(queueName: "frameproject.trmquang.sample.requestcounter") {[weak self] in
            if let weakSelf = self, let view = weakSelf.view {
                view.endReloading()
            }
        }
        
        // time to fetch out
        sampleObservable.fetchLocal()
        if let view = view {
            view.updateSampleViewDetail()
            view.updateSampleList()
            view.beginReloading()
        }
    }
    
    func reloadData() {
        loadingRequestCounter.addRequest()
        sampleObservable.fetchRemote(queryParams: nil,
                                     onSuccess: {[weak self] in
            if let weakSelf = self {
                weakSelf.loadingRequestCounter.completeRequest()
            }
            
        }, onFail: {[weak self] errorCode, errorMsg in
            if let weakSelf = self {
                weakSelf.loadingRequestCounter.completeRequest()
            }
            // show error message if you want
        })
        
        
    }
    

}
