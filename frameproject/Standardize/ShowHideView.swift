//
//  ShowHideView.swift
//  frameproject
//
//  Created by Quang Trinh on 10/08/2022.
//

import UIKit

class ShowHideView: View {

    enum ShowHideDirection {
        case horizontal
        case vertical
    }
    // MARK: - View elements
    let contentView: View = View.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    private var zeroHeightConstraint: NSLayoutConstraint!
    private var contentViewLeadingSpaceConstraint: NSLayoutConstraint!
    private var contentViewTopSpaceConstraint: NSLayoutConstraint!
    private var contentViewTrailingSpaceConstraint: NSLayoutConstraint!
    private var contentViewBottomSpaceConstraint: NSLayoutConstraint!
    private var zeroWidthConstraint: NSLayoutConstraint!
    
    /// default .vertical
    var showHideDirection: ShowHideDirection = .vertical {
        didSet {
            didSetShowHideDescription()
        }
    }
    
    /// default 0
    var contentViewTopPadding: CGFloat = 0 {
        didSet {
            didSetContentViewTopPadding()
        }
    }
    
    /// default 0
    var contentViewLeadPadding: CGFloat = 0 {
        didSet {
            didSetContentViewLeadPadding()
        }
    }
    
    /// default 0
    var contentViewTrailPadding: CGFloat = 0 {
        didSet {
            didSetContentViewTrailPadding()
        }
    }
    
    /// default 0
    var contentViewBottomPadding: CGFloat = 0 {
        didSet {
            didSetContentViewBottomPadding()
        }
    }
    
    var isShow: Bool = true {
        didSet {
            didSetIsShow()
        }
    }
    
    override func layoutView() {
        super.layoutView()
        layer.masksToBounds = true
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        addSubviewForLayout(contentView)
        contentViewLeadingSpaceConstraint = contentView.alignLeading(to: self, space: contentViewLeadPadding)
        contentViewTopSpaceConstraint = contentView.alignTop(to: self, space: contentViewTopPadding)
        contentViewTrailingSpaceConstraint = self.alignTrailing(to: contentView, space: contentViewTrailPadding)
        contentViewBottomSpaceConstraint = self.alignBottom(to: contentView, space: contentViewBottomPadding)
        zeroWidthConstraint = configWidth(0)
        zeroHeightConstraint = configHeight(0)
        addConstraints([contentViewLeadingSpaceConstraint,
                        contentViewTopSpaceConstraint,
                        contentViewTrailingSpaceConstraint,
                        contentViewBottomSpaceConstraint,
                        zeroWidthConstraint,
                        zeroHeightConstraint])
        didSetIsShow()
    }
    
    
    
    func show() {
        isShow = true
        
    }
    
    func hide() {
        isShow = false
    }
    
    private func didSetIsShow() {
        ViewUtility.renderShowHide(isShow: isShow,
                                   bottomSpaceConstraint: showHideDirection == .vertical ? contentViewBottomSpaceConstraint: contentViewTrailingSpaceConstraint,
                                   zeroHeightConstraint: showHideDirection == .vertical ? zeroHeightConstraint : zeroWidthConstraint)
        showHideDirection == .vertical ? (zeroWidthConstraint.isActive = false) : (zeroHeightConstraint.isActive = false)
        showHideDirection == .vertical ? (contentViewTrailingSpaceConstraint.isActive = true) : (contentViewBottomSpaceConstraint.isActive = true)
    }
    
    
    private func didSetShowHideDescription() {
        ViewUtility.renderShowHide(isShow: isShow,
                                   bottomSpaceConstraint: showHideDirection == .vertical ? zeroHeightConstraint: zeroWidthConstraint,
                                   zeroHeightConstraint: showHideDirection == .vertical ? contentViewBottomSpaceConstraint: contentViewTrailingSpaceConstraint)
        ViewUtility.renderShowHide(isShow: !isShow,
                                   bottomSpaceConstraint: showHideDirection == .vertical ? zeroWidthConstraint : zeroHeightConstraint ,
                                   zeroHeightConstraint: showHideDirection == .vertical ? contentViewTrailingSpaceConstraint : contentViewBottomSpaceConstraint)
        
    }
    
    private func didSetContentViewTopPadding() {
        contentViewTopSpaceConstraint.constant = contentViewTopPadding
    }
    
    private func didSetContentViewLeadPadding() {
        contentViewLeadingSpaceConstraint.constant = contentViewLeadPadding
    }
    
    private func didSetContentViewTrailPadding() {
        contentViewTrailingSpaceConstraint.constant = contentViewTrailPadding
    }
    
    private func didSetContentViewBottomPadding() {
        contentViewBottomSpaceConstraint.constant = contentViewBottomPadding
    }

}
