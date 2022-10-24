//
//  NetworkUtility.swift
//  frameproject
//
//  Created by Quang Trinh on 20/08/2022.
//

import Foundation

class NetworkUtility {
    
    static var networkRequestInfoDateFormatter: DateFormatter {
        get {
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            return dateFormatter
        }
    }
}
