//
//  AppDelegate.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?
    private var session = SessionManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }

        #if debug
        if CommandLine.arguments.contains("UITEST") {
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.keyWindow?.layer.speed = 100
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.navigate(to: .authentication)
        }
        #endif

        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.navigate(to: session.isSessionValid ? .upcoming : .authentication)

        return true
    }

}

