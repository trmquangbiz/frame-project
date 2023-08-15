//
//  UtilityRouter.swift
//  frameproject
//
//  Created by Quang Trinh on 03/08/2023.
//

import Foundation
import UIKit
// Routing View Helper
class UtilityRouter {
    static func showSampleList() {
        if let vc = SampleListWireFrame.createSampleListViewController() {
            let nav = UINavigationController.init(rootViewController: vc)
            let window = UIWindow.init(frame: UIScreen.main.bounds)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            window.backgroundColor = DSColor.white.value
            window.rootViewController = nav
            appDelegate.window = window
            appDelegate.window!.makeKeyAndVisible()
        }
    }
}
