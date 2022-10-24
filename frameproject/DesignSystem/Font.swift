//
//  Font.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import Foundation
import UIKit
extension DesignSystem {
    struct Font {
        // Black, size 24
        static let largeTitle: UIFont = UIFont.init(defaultFontType: .bold, size: 24)!
        /// Bold, size 20
        static let headline: UIFont = UIFont.init(defaultFontType: .bold, size: 20)!
        /// Bold, size 20
        static let title: UIFont = UIFont.init(defaultFontType: .bold, size: 20)!
        /// Bold, size 16
        static let title1: UIFont = UIFont.init(defaultFontType: .bold, size: 16)!
        /// Bold, size 14
        static let title2: UIFont = UIFont.init(defaultFontType: .bold, size: 14)!
        /// Regular, size 16
        static let content: UIFont = UIFont.init(defaultFontType: .regular, size: 16)!
        /// Regular, size 14
        static let content1: UIFont = UIFont.init(defaultFontType: .regular, size: 14)!
        /// Regular, size 14
        static let content2: UIFont = UIFont.init(defaultFontType: .regular, size: 14)!
        /// bold, size 12
        static let badge: UIFont = UIFont.init(defaultFontType: .bold, size: 12)!
    }
}

