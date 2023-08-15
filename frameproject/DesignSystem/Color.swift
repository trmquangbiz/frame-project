//
//  Color.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import Foundation
import UIKit

extension DesignSystem {
    enum Color: Int {
        case red = 0xF7001E
        case lightRed = 0xFFE0E0
        case black = 0x333333
        case white = 0xFFFFFF
        case ashGray = 0xF6F6F6
        case lightGray = 0xEBEBEB
        case gray = 0xCBCBCB
        case darkGray = 0x9C9C9C
        case green = 0x7ED321
        case orange = 0xF5A623
        case purple = 0xA975D4
        case blue = 0x0897EE
        var value: UIColor {
            get {
                return UIColor.init(self.rawValue)
            }
        }
    }
}
