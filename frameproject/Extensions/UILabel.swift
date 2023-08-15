//
//  UILabel.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import Foundation
import UIKit

extension UILabel {
    func textLayout(font: DesignSystem.Font, color: DesignSystem.Color) {
        self.font = font.value
        self.textColor = color.value
    }
}
