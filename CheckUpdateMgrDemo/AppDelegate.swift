//
//  AppDelegate.swift
//  checkupdate
//
//  Created by XingfuQiu on 2018/5/29.
//  Copyright © 2018年 XingfuQiu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()

        return true
    }

}

