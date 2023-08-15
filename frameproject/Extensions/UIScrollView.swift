//
//  UIScrollView.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import Foundation
import UIKit
import MJRefresh
extension UIScrollView {
    func addRefreshHeader(_ refreshAction: @escaping ()->()) {
        let headerForLoading = MJRefreshNormalHeader {
            refreshAction()
        }
        headerForLoading.loadingView?.style = .medium
        headerForLoading.lastUpdatedTimeLabel?.isHidden = true
        headerForLoading.stateLabel?.isHidden = true
        mj_header = headerForLoading
        
    }
    func addLoadMoreFooter(_ loadMoreAction: @escaping ()->()) {
        let footerForLoading = MJRefreshAutoNormalFooter {
            loadMoreAction()
        }
        footerForLoading.isRefreshingTitleHidden = true
        footerForLoading.loadingView?.style = .medium
        footerForLoading.stateLabel?.isHidden = true
        mj_footer = footerForLoading
    }
    
    func footerEndRefreshing(completionRestoredEdgeInset: UIEdgeInsets? = nil)  {
        if let mj_footer = mj_footer {
            mj_footer.endRefreshingWithNoMoreData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {[weak self] in
                if let weakSelf = self, let mj_footer = weakSelf.mj_footer {
                    mj_footer.resetNoMoreData()
                    if let completionRestoredEdgeInset = completionRestoredEdgeInset {
                        weakSelf.contentInset = completionRestoredEdgeInset
                    } else {
                        weakSelf.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    }
                }
            })
        }
    }
    
    func headerBeginRefreshing() {
        mj_header?.beginRefreshing()
    }
    func headerEndRefreshing() {
        mj_header?.endRefreshing()
    }
    func footerBeginRefreshing() {
        mj_footer?.beginRefreshing()
    }
    
    func headerIsRefreshing() -> Bool{
        return mj_header?.isRefreshing ?? false
    }
    func footerIsRefreshing() -> Bool {
        return mj_footer?.isRefreshing ?? false
    }
}
