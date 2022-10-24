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
        didSetContentViewColor()
    }
    
    private func didSetContentViewColor() {
        contentView.backgroundColor = contentViewColor
    }
    
}
