//
//  AppDelegate.swift
//  MVC-Sample
//
//  Created by david on 2018. 7. 31..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupKeyWindow()
        return true
    }
    
    private func setupKeyWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginViewController = LoginViewController()
        window?.rootViewController = UINavigationController(rootViewController: loginViewController)
        window?.makeKeyAndVisible()
    }
}
