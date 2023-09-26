//
//  UILayoutGuide.swift
//  frameproject
//
//  Created by Quang Trinh on 21/09/2023.
//

import Foundation
import UIKit

extension UILayoutGuide {
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
    
    // set heigh for view
    func equalHeight(_ height: CGFloat) {
        NSLayoutConstraint.activate([self.configHeight(height)])
    }
    
    func equalWidth(_ width: CGFloat) {
        NSLayoutConstraint.activate([self.configWidth(width)])
    }
}
