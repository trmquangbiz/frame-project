//
//  Font.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import Foundation
import UIKit
extension DesignSystem {
    enum Font {
        case largeTitle
        case headline
        case title
        case title1
        case title2
        case content
        case content1
        case badge
        var value: UIFont {
            switch self {
            case .largeTitle:
                return UIFont.init(defaultFontType: .bold, size: 24)!
            case .headline:
                return UIFont.init(defaultFontType: .bold, size: 20)!
            case .title:
                return UIFont.init(defaultFontType: .bold, size: 20)!
            case .title1:
                return UIFont.init(defaultFontType: .bold, size: 16)!
            case .title2:
                return UIFont.init(defaultFontType: .bold, size: 14)!
            case .content:
                return UIFont.init(defaultFontType: .regular, size: 16)!
            case .content1:
                return UIFont.init(defaultFontType: .regular, size: 14)!
            case .badge:
                return UIFont.init(defaultFontType: .bold, size: 12)!
            }
        }
    }
}

