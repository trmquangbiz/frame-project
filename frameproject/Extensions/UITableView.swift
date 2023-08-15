//
//  UITableView.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import Foundation
import UIKit
extension UITableView {
    /**
     Method registers an array of nib name defined by the nibName String parameter with current table view
     - Parameter identifiers:  [String]
     */
    func registerNibCells(with identifiers: [String]) {
        for identifier in identifiers {
            ViewUtility.registerNibWithTableView(identifier, tableView: self)
        }
    }
}
