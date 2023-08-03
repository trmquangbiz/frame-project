//
//  SampleViewProtocol.swift
//  frameproject
//
//  Created by Quang Trinh on 03/08/2023.
//

import Foundation


protocol SampleViewProtocol: AnyObject {
    var presenter: SamplePresenterProtocol! {get set}
    func updateSampleViewDetail()
    func updateSampleList()
    func endReloading()
    func endLoadMore()
    func beginReloading()
}
