//
//  RxSampleListViewModel.swift
//  frameproject
//
//  Created by Quang Trinh on 24/09/2023.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

enum RxSampleListViewState {
    case initiate
    case reloading
    case onEmpty
    case loadMore
    case endReloading
    case endLoadMore
    case onError(statusCode: Int, errorMsg: Any?)
    case showResult
}
protocol RxSampleListViewModelProtocol: AnyObject {
    var items: BehaviorRelay<[RxSampleObject]> {get set}
    var itemsObservable: Observable<[RxSampleObject]> {get}
    var state: BehaviorRelay<RxSampleListViewState> {get set}
    var stateObservable: Observable<RxSampleListViewState> {get}
    var currentPagination: [String: Any]? {get set}
    func addItem(_ item: RxSampleObject)
    func reloadData()
    func loadMore()
    func setAPIService(_ value: APIServiceManagerProtocol)
    func pushSampleDetail(_ id: Int, from nav: UINavigationController)
}

class RxSampleListViewModel: RxSampleListViewModelProtocol {
    
    var currentPagination: [String : Any]?
    var state: RxRelay.BehaviorRelay<RxSampleListViewState> = BehaviorRelay<RxSampleListViewState>.init(value: .initiate)
    var stateObservable: Observable<RxSampleListViewState> {
        state.asObservable()
    }
    var items: BehaviorRelay<[RxSampleObject]>
    var itemsObservable: Observable<[RxSampleObject]> {
        items.asObservable()
    }
    var apiService: APIServiceManagerProtocol = APIServiceManager.shared
    
    init(items: BehaviorRelay<[RxSampleObject]>) {
        self.items = items
    }
    
    func addItem(_ item: RxSampleObject) {
        var newList = items.value
        newList.append(item)
        items.accept(newList)
    }
    
    
    func setAPIService(_ value: APIServiceManagerProtocol) {
        #if DEBUG
        self.apiService = value
        #endif
    }
    
    func reloadData() {
        state.accept(.reloading)
        currentPagination = nil
        apiService.getListObject(endPoint: APIPath.getSampleList.path,
                                 queryParams: nil,
                                 extraHeaders: nil,
                                 forAuthenticate: false,
                                 objectType: RxSampleObject.self,
                                 completion: {[weak self] response in
            guard let `self` = self else {
                return
                
            }
            self.state.accept(.endReloading)
            switch response {
            case .success(_, let responseObject, let pagination):
                self.currentPagination = pagination
                if let responseObject = responseObject {
                    if responseObject.count == 0 {
                        self.state.accept(.onEmpty)
                    }
                    else {
                        self.state.accept(.showResult)
                    }
                    self.items.accept(responseObject)
                }
            case .fail(let statusCode, let errorMsg):
                if statusCode == 404 {
                    self.items.accept([])
                    self.state.accept(.onEmpty)
                }
                else {
                    self.state.accept(.onError(statusCode: statusCode, errorMsg: errorMsg))
                }
            }
        })
    }
    
    func loadMore() {
        state.accept(.loadMore)
        guard let currentPagination = currentPagination else {
            Debugger.debug("No pagination to load more")
            return
        }
        var queryParams: [String: Any] = [:]
        // setup pagination query here
        apiService.getListObject(endPoint: APIPath.getSampleList.path, queryParams: queryParams, extraHeaders: nil, forAuthenticate: false, objectType: RxSampleObject.self) { [weak self] response in
            guard let `self` = self else {
                return
            }
            self.state.accept(.endLoadMore)
            switch response {
            case .success(statusCode: _, responseObject: let responseObject, pagination: let pagination):
                self.currentPagination = pagination
                if let responseObject = responseObject {
                    var newList = self.items.value
                    newList.append(contentsOf: responseObject)
                    self.items.accept(newList)
                }
            case .fail(statusCode: let statusCode, errorMsg: let errorMsg):
                self.state.accept(.onError(statusCode: statusCode, errorMsg: errorMsg))
            }
        }
    }
    
    func pushSampleDetail(_ id: Int, from nav: UINavigationController) {
        if let vc = SampleWireFrame.createSampleViewController(sampleId: id) {
            nav.pushViewController(vc, animated: true)
        }
    }
    
}
