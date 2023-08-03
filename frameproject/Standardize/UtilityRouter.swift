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
    
    static func showSample(sampleId: Int) {
        if let vc = SampleWireFrame.createSampleViewController(sampleId: sampleId) {
            let nav = UINavigationController.init(rootViewController: vc)
            let window = UIWindow.init(frame: UIScreen.main.bounds)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            window.backgroundColor = DesignSystem.Color.white
            window.rootViewController = nav
            appDelegate.window = window
            appDelegate.window!.makeKeyAndVisible()
        }
    }
}
