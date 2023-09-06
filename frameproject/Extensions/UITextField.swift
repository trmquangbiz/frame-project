//
//  UITextField.swift
//  frameproject
//
//  Created by Quang Trinh on 02/09/2023.
//

import Foundation
import Combine
import UIKit

extension UITextField {
   
    var textPublisher: AnyPublisher<String, Never> {
        get {
            NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: nil)
                .compactMap { $0.object as? UITextField } // receiving notifications with objects which are instances of UITextFields
                .compactMap(\.text) // extracting text and removing optional values (even though the text cannot be nil)
                .eraseToAnyPublisher()
        }
    }
}
