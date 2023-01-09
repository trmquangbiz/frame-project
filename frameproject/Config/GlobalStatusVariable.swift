//
//  GlobalStatusVariable.swift
//  frameproject
//
//  Created by Quang Trinh on 22/12/2022.
//

import Foundation
import IQKeyboardManagerSwift
final class GlobalStatusVariable: NSObject {
    class func setupStatusVariable() {
        if let currentLanguage = UserDefaults.standard.object(forKey: Constant.kLanguage) as? String {
            Bundle.setLanguage(currentLanguage)
            
        }
        else {
            UserDefaults.standard.setValue("vi", forKey: Constant.kLanguage)
            Bundle.setLanguage("vi")
        }
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "buttons.done".localized
    }
    deinit {
        Debugger.debug("Deinit: GlobalStatusVariable")
    }
    /// get current language of application
    static var currentLanguage: String {
        get {
            if let language = UserDefaults.standard.object(forKey: Constant.kLanguage) as? String {
                return language
            }
            else {
                return "vi"
            }
        }
    }
    static var googleAPIKey: String {
        get {
            #if DEBUG
            return "AIzaSyB0GefQuX7OQXteL7Le5lFwOUMdnCh1nTE"
//                return "AIzaSyDOImdsJdbnLingPQxOOoS4OFJ3DnSWP40"
            #else
                return "AIzaSyB0GefQuX7OQXteL7Le5lFwOUMdnCh1nTE"
            #endif
            
        }
    }
    
    static var currentShippingAddressId: Int? {
        get {
            return  UserDefaults.standard.object(forKey: Constant.kCurrentShippingAddressId) as? Int
        }
    }
    
    static var highlightKeywordColorArr: [Int] {
        return [0xEBEBEB, 0xFDCCD2, 0xCEEAFC, 0xE5F6D3, 0xFDEDD3]
    }
}
