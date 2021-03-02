//
//  AppDelegate.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/2.
//

import AVFoundation
import UIKit
import URLNavigator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let navigator = Navigator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppRouter.initialize(navigator: navigator)

        let tabvc = TabBarViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabvc
        window?.makeKeyAndVisible()
        return true
    }
}
