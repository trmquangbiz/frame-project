//
//  DesignSystemView.swift
//  frameproject
//
//  Created by Quang Trinh on 31/07/2022.
//

import Foundation
import UIKit

class DesignSystemView: ShowHideView {
    
}

extension DesignSystem {
    class View {
        static var radioButtonView: RadioButtonView {
            get {
                return RadioButtonView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
            }
        }
    }
}
