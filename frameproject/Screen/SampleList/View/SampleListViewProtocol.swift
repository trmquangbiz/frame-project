//
//  SampleListViewProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import Foundation

protocol SampleListViewProtocol: AnyObject {
    var presenter: SampleListPresenterProtocol! { get set }
    func updateView()
    func beginRefreshing()
    func endRefreshing()
    func endLoadMore()
}
