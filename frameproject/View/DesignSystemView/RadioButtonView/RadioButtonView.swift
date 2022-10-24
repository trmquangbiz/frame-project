//
//  RadioButtonView.swift
//  frameproject
//
//  Created by Quang Trinh on 10/08/2022.
//

import UIKit

class RadioButtonView: DesignSystemView {
    
    // MARK: - View Elements
    private var outerBoxView: View = View.init()
    private var innerCoreView: View = View.init()
    private var outerBoxViewHeightConstraint: NSLayoutConstraint!
    private var outerBoxViewWidthConstraint: NSLayoutConstraint!
    private var innerCoreViewHeightConstraint: NSLayoutConstraint!
    private var innerCoreViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    /// default = light gray
    var unselectedColor = DesignSystem.Color.lightGray {
        didSet {
            updateUnselectedColor()
        }
    }
    
    /// default = red
    var selectedColor = DesignSystem.Color.red {
        didSet {
            updateSelectedColor()
        }
    }
    
    /// default = 24
    var outerBoxHeight: CGFloat = 24 {
        didSet {
            if outerBoxHeight != oldValue {
                updateOnOuterBoxHeight()
            }
        }
    }
    
    /// default = 12
    var innerCoreHeight: CGFloat = 12 {
        didSet {
            if innerCoreHeight != oldValue {
                updateOnInnerCoreHeight()
            }
        }
    }
    
    /// default = 1
    var outerBoxBorderWidth: CGFloat = 1 {
        didSet {
            if outerBoxBorderWidth != oldValue {
                updateOuterBoxBorderWidth()
            }
        }
    }
    
    /// default = true
    var isOn: Bool = false {
        didSet {
            if isOn != oldValue {
                updateOnToggle()
            }
        }
    }
    
    override func layoutView() {
        super.layoutView()
        
        contentView.addSubviewForLayout(outerBoxView)
        outerBoxViewHeightConstraint = outerBoxView.configHeight(0)
        outerBoxViewWidthConstraint = outerBoxView.configWidth(0)
        contentView.addConstraints([outerBoxView.alignTop(to: contentView),
                                    outerBoxView.alignLeading(to: contentView),
                                    contentView.alignBottom(to: outerBoxView),
                                    contentView.alignTrailing(to: outerBoxView)])
        outerBoxView.addConstraints([outerBoxViewHeightConstraint,
                                    outerBoxViewWidthConstraint])
        
        outerBoxView.addSubviewForLayout(innerCoreView)
        innerCoreViewHeightConstraint = innerCoreView.configHeight(0)
        innerCoreViewWidthConstraint = innerCoreView.configWidth(0)
        outerBoxView.addConstraints([innerCoreView.relationCenterX(to: outerBoxView),
                                    innerCoreView.relationCenterY(to: outerBoxView)])
        innerCoreView.addConstraints([innerCoreViewHeightConstraint,
                                      innerCoreViewWidthConstraint])

        updateSelectedColor()
        updateUnselectedColor()
        updateOuterBoxBorderWidth()
        updateOnOuterBoxHeight()
        updateOnInnerCoreHeight()
        updateOnToggle()
        
    }
    
    func toggle(isOn: Bool) {
        self.isOn = isOn
    }
    
    private func updateOnToggle() {
        outerBoxView.layer.borderColor = isOn ? selectedColor.cgColor : unselectedColor.cgColor
        innerCoreView.alpha = isOn ? 1 : 0
    }
    
    private func updateSelectedColor() {
        if isOn {
            outerBoxView.layer.borderColor = selectedColor.cgColor
        }
        innerCoreView.backgroundColor = selectedColor
    }
    
    private func updateUnselectedColor() {
        if !isOn {
            outerBoxView.layer.borderColor = unselectedColor.cgColor
        }
    }
    
    private func updateOuterBoxBorderWidth() {
        outerBoxView.layer.borderWidth = outerBoxBorderWidth
    }
    
    private func updateOnOuterBoxHeight() {
        outerBoxViewHeightConstraint.constant = outerBoxHeight
        outerBoxViewWidthConstraint.constant = outerBoxHeight
        outerBoxView.addCornerRadius(outerBoxHeight/2)
    }
    
    private func updateOnInnerCoreHeight() {
        innerCoreViewHeightConstraint.constant = innerCoreHeight
        innerCoreViewWidthConstraint.constant = innerCoreHeight
        innerCoreView.addCornerRadius(innerCoreHeight/2)
    }

}
