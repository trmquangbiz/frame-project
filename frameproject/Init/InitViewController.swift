//
//  InitViewController.swift
//  frameproject
//
//  Created by Quang Trinh on 03/08/2023.
//

import UIKit

class InitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UtilityRouter.showRxSampleList()
    }

}
