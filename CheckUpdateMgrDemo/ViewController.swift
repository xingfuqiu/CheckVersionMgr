//
//  ViewController.swift
//  checkupdate
//
//  Created by XingfuQiu on 2018/5/29.
//  Copyright © 2018年 XingfuQiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let checkMgr = CheckVersionMgr.shared
        checkMgr.openTrackUrlInAppStore = false
        checkMgr.CheckAgainInterval = 0
        checkMgr.checkVersionWithSystemAlert()
        
//        checkMgr.checkVersionWithCustomView { (model, status) in
//            //code
//        }
        
//        CheckVersionMgr.shared.checkVersionWithSystemAlert()
    }
}

