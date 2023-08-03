//
//  Utils.swift
//  frameproject
//
//  Created by Quang Trinh on 22/12/2022.
//

import Foundation
import UIKit
import RealmSwift
class Utils {
    class func convertArrayOfIntIntoStringToRequest(list: [Int] ) -> String {
        var str = ""
        if list.count > 0 {
            for i in 0..<list.count {
                if i != 0 {
                    str.append(",")
                    
                }
                str.append("\(list[i])")
            }
        }
        
        return str
    }
    
    class func convertArrayOfObjectIntoStringToRequest<T>(list: [T] ) -> String {
        var str = ""
        if list.count > 0 {
            for i in 0..<list.count {
                if i != 0 {
                    str.append(",")
                    
                }
                str.append("\(list[i])")
            }
        }
        return str
    }
    
    class func makeParagraphSpacing(spacing: CGFloat) -> Any {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = spacing
        return paragraphStyle
    }
    
    class func checkIsSessionExpire(session: Date, timeExpire: Int) -> Bool {
        let now = Date.init()
        let calendar = Calendar.current.dateComponents([.second], from: session, to: now)
        if let second = calendar.second, second >= timeExpire {
            return true
        } else {
            return false
        }
    }
}
