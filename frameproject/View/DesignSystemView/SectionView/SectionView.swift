//
//  SectionView.swift
//  frameproject
//
//  Created by Quang Trinh on 11/08/2022.
//

import UIKit

class SectionView: ShowHideView {
    
    var contentViewColor = DesignSystem.Color.white {
        didSet {
            didSetContentViewColor()
        }
    }
    override func layoutView() {
        super.layoutView()
        contentViewTopPadding = DesignSystem.Spacing.margin.rawValue
        setContentViewColor(contentViewColor.value)
    }
    
    private func didSetContentViewColor() {
        setContentViewColor(contentViewColor.value)
    }
    
    func setContentViewColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }
    
}
