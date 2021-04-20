//
//  AppDelegate.swift
//  Touch
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import UIKit
import Touch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Touch.shared.setup(clientId: "bRUVL8o0KiMIDRBKojxECtTWp",loginDelegate: self)
        return true
    }
    
}

extension AppDelegate: TouchLoginManagerProtocol{
    func requestLogin() {
        // Start user login flow. After user succesfully logs in, forward user id to Touch platform
        Touch.shared.login(userId: "54321")
    }
}
