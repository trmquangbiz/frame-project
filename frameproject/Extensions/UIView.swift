//
//  UIView.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import Foundation
import UIKit

enum UIViewShadowVerticalDirection {
    case bottom
    case top
}
extension UIView {
    func circleRadius() {
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate = completionDelegate as? CAAnimationDelegate {
            rotateAnimation.delegate = delegate
        }
        layer.add(rotateAnimation, forKey: nil)
    }
    
    func addShadow() {
        layer.shadowColor = DSColor.lightGray.value.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2
    }
    func addShadowToOneSide(verticalDirection: UIViewShadowVerticalDirection) {
        layer.masksToBounds = false
        layer.shadowColor = DSColor.darkGray.value.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1
        
        switch verticalDirection {
        case .bottom:
            layer.shadowOffset = CGSize.init(width: 0, height: 2)
            
        case .top:
            layer.shadowOffset = CGSize.init(width: 0, height: -2)
        }
        
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.shadowPath = mask.path
        mask.shadowColor = layer.shadowColor
        mask.shadowOpacity = layer.shadowOpacity
        mask.shadowOffset = layer.shadowOffset
        mask.shadowRadius = layer.shadowRadius
        self.layer.mask = mask
    }
    
    func roundCustomCorners(radius: CGFloat, customCorners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: customCorners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
    }
    
    func addCornerRadius(_ cornerRadius: CGFloat = DesignSystem.Corner.normal.rawValue, masksToBound: Bool = true) {
        layer.masksToBounds = masksToBound
        layer.cornerRadius = cornerRadius
    }
    
    func addChildView(_ childView: UIView,
                      top: CGFloat = 0,
                      bottom: CGFloat = 0,
                      trailing: CGFloat = 0,
                      leading: CGFloat = 0) {
        addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [childView.alignTop(to: self, space: top),
                                                 childView.alignBottom(to: self, space: bottom),
                                                 childView.alignLeading(to: self, space: leading),
                                                 childView.alignTrailing(to: self, space: trailing)
        ]
        addConstraints(constraints)
    }
    
    var viewContainingController: UIViewController? {
        get {
            var nextResponder: UIResponder? = self
            
            repeat {
                nextResponder = nextResponder?.next
                
                if let viewController = nextResponder as? UIViewController {
                    return viewController
                }
                
            } while nextResponder != nil
            
            return nil
        }
    }
    
    var navigationController: UINavigationController? {
        get {
            return viewContainingController?.navigationController
        }
    }
    
    var tabBarController: UITabBarController? {
        get {
            return viewContainingController?.tabBarController
        }
    }
    
    
}

extension UIView {
    // align trailing to destinationView
    func alignTrailing(to destinationView: Any ,
                  relation: NSLayoutConstraint.Relation = .equal,
                  multiplier: CGFloat = 1,
                  space: CGFloat = 0,
                  priority: Float = 1000) -> NSLayoutConstraint  {
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self,
                                                                     attribute: .trailing,
                                                                     relatedBy: relation,
                                                                     toItem: destinationView,
                                                                     attribute: .trailing,
                                                                     multiplier: multiplier,
                                                                     constant: space)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
        
    }
    // align leading to destinationView
    func alignLeading(to destinationView: Any ,
                  relation: NSLayoutConstraint.Relation = .equal,
                  multiplier: CGFloat = 1,
                  space: CGFloat = 0,
                  priority: Float = 1000) -> NSLayoutConstraint  {
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self,
                                                                     attribute: .leading,
                                                                     relatedBy: relation,
                                                                     toItem: destinationView,
                                                                     attribute: .leading,
                                                                     multiplier: multiplier,
                                                                     constant: space)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    // align top to destinationView
    func alignTop(to destinationView: Any ,
                  relation: NSLayoutConstraint.Relation = .equal,
                  multiplier: CGFloat = 1,
                  space: CGFloat = 0,
                  priority: Float = 1000) -> NSLayoutConstraint  {
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self,
                                                                     attribute: .top,
                                                                     relatedBy: relation,
                                                                     toItem: destinationView,
                                                                     attribute: .top,
                                                                     multiplier: multiplier,
                                                                     constant: space)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
        
    }
    // align bottom to destinationView
    func alignBottom(to destinationView: Any ,
                  relation: NSLayoutConstraint.Relation = .equal,
                  multiplier: CGFloat = 1,
                  space: CGFloat = 0,
                  priority: Float = 1000) -> NSLayoutConstraint  {
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self,
                                                                     attribute: .bottom,
                                                                     relatedBy: relation,
                                                                     toItem: destinationView,
                                                                     attribute: .bottom,
                                                                     multiplier: multiplier,
                                                                     constant: space)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    /// spacing view's trailing side to destinationView's leading side
    func spacingRight(to destinationView: Any,
                      relation: NSLayoutConstraint.Relation = .equal,
                      multiplier: CGFloat = 1,
                      space: CGFloat = 0,
                      priority: Float = 1000) -> NSLayoutConstraint{
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: destinationView,
                                                                     attribute: .leading,
                                                                     relatedBy: relation,
                                                                     toItem: self,
                                                                     attribute: .trailing,
                                                                     multiplier: multiplier,
                                                                     constant: space)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    /// spacing view's leading side to destinationView's trailing side
    func spacingLeft(to destinationView: Any,
                      relation: NSLayoutConstraint.Relation = .equal,
                      multiplier: CGFloat = 1,
                      space: CGFloat = 0,
                      priority: Float = 1000) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self,
                                                                     attribute: .leading,
                                                                     relatedBy: relation,
                                                                     toItem: destinationView,
                                                                     attribute: .trailing,
                                                                     multiplier: multiplier,
                                                                     constant: space)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    /// spacing view's bottom side to destinationView's top side
    func spacingBottom(to destinationView: Any,
                      relation: NSLayoutConstraint.Relation = .equal,
                      multiplier: CGFloat = 1,
                      space: CGFloat = 0,
                      priority: Float = 1000) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: destinationView,
                                                                     attribute: .top,
                                                                     relatedBy: relation,
                                                                     toItem: self,
                                                                     attribute: .bottom,
                                                                     multiplier: multiplier,
                                                                     constant: space)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    /// spacing view's top side to destinationView's bottom side
    func spacingTop(to destinationView: Any,
                      relation: NSLayoutConstraint.Relation = .equal,
                      multiplier: CGFloat = 1,
                      space: CGFloat = 0,
                      priority: Float = 1000) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self,
                                                                     attribute: .top,
                                                                     relatedBy: relation,
                                                                     toItem: destinationView,
                                                                     attribute: .bottom,
                                                                     multiplier: multiplier,
                                                                     constant: space)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    // config height constraint
    func configHeight(relation: NSLayoutConstraint.Relation = .equal,
                      multipler: CGFloat = 1,
                      _ height: CGFloat,
                      priority: Float = 1000) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multipler, constant: height)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    // config width constraint
    func configWidth(relation: NSLayoutConstraint.Relation = .equal,
                      multipler: CGFloat = 1,
                      _ width: CGFloat,
                      priority: Float = 1000) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multipler, constant: width)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    // relation width to destination view
    func relationWidth(to destinationView: Any,
                       relation: NSLayoutConstraint.Relation = .equal,
                       multiplier: CGFloat = 1,
                       constant: CGFloat = 0,
                       priority: Float = 1000) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: relation, toItem: destinationView, attribute: .width, multiplier: multiplier, constant: 0)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    
    // relation height to destination view
    func relationHeight(to destinationView: Any,
                       relation: NSLayoutConstraint.Relation = .equal,
                       multiplier: CGFloat = 1,
                       constant: CGFloat = 0,
                       priority: Float = 1000) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: relation, toItem: destinationView, attribute: .height, multiplier: multiplier, constant: 0)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    // relation center x to destination view
    func relationCenterX(to destinationView: Any,
                        relation: NSLayoutConstraint.Relation = .equal,
                        multiplier: CGFloat = 1,
                        constant: CGFloat = 0,
                        priority: Float = 1000) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: relation, toItem: destinationView, attribute: .centerX, multiplier: multiplier, constant: 0)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    // relation center y to destination view
    func relationCenterY(to destinationView: Any,
                         relation: NSLayoutConstraint.Relation = .equal,
                         multiplier: CGFloat = 1,
                         constant: CGFloat = 0,
                         priority: Float = 1000) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: relation, toItem: destinationView, attribute: .centerY, multiplier: multiplier, constant: 0)
        constraint.priority = UILayoutPriority.init(priority)
        return constraint
    }
    
    func addSubviewForLayout(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // set heigh for view
    func equalHeight(_ height: CGFloat) {
        addConstraint(self.configHeight(height))
    }
    
    func equalWidth(_ width: CGFloat) {
        addConstraint(self.configWidth(width))
    }
    
}
