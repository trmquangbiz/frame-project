//
//  APIPath.swift
//  frameproject
//
//  Created by Quang Trinh on 28/07/2023.
//

import Foundation

enum APIPath {
    case getSampleDetail(sampleId: Int)
    case getSampleList
    var path: String {
        get {
            switch self {
            case .getSampleDetail(sampleId: let id):
                return "samples/\(id)"
            case .getSampleList:
                return "samples"
            }
        }
    }
}
