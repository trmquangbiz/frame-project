//
//  UIImageView.swift
//  frameproject
//
//  Created by Quang Trinh on 24/08/2023.
//

import Foundation
import UIKit
import Kingfisher
extension UIImageView {
    
    internal func changeImage(_ image: UIImage?, animated: Bool) {
        if animated, let image = image {
            let transition = CATransition()
            transition.duration = 0.25
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            layer.add(transition, forKey: nil)
            
            self.image = image
        } else {
            self.image = image
        }
    }
    
    
    
    func downloadImage(from urlStr: String?, placeHolder: String? = nil, isBlur: Bool = false) {
        var placeholderImage: UIImage?
        if let placeHolder = placeHolder {
            placeholderImage = UIImage.init(named: placeHolder)
        }
        
        if isBlur == false {
            kf.setImage(with: urlStr != nil ? URL.init(string: urlStr!) : nil, placeholder: placeholderImage, options: [.keepCurrentImageWhileLoading])
        }
        else {
            let processor = BlurImageProcessor.init(blurRadius: 6)
            kf.setImage(with: urlStr != nil ? URL.init(string: urlStr!) : nil, options: [.processor(processor)])
        }
    }
}
