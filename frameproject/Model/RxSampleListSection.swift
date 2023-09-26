//
//  RxSampleListSection.swift
//  frameproject
//
//  Created by Quang Trinh on 23/09/2023.
//

import Foundation
import RxDataSources

struct RxSampleListSection: SectionModelType {
    var items: [RxSampleObject]
    
    init(original: RxSampleListSection, items: [RxSampleObject]) {
        self = original
        self.items = items
    }
    
    typealias Item = RxSampleObject
    
    
}
