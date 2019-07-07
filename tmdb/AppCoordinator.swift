//
//  AppCoordinator.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    func navigate(to destination: Destination)
}

enum Destination {
    case authentication
    case movie(id: String)
    case search
    case upcoming
}

final class AppCoordinator: Coordinator {

    private let authCoordinator: AuthCoordinator
    private let listCoordinator: ListCoordinator
    private let authNavigationController = UINavigationController()
    private let rootViewController = UINavigationController()
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        authCoordinator = AuthCoordinator(rootViewController: authNavigationController)
        listCoordinator = ListCoordinator(rootViewController: rootViewController)
        rootViewController.navigationBar.prefersLargeTitles = true
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .authentication:
            window.rootViewController = authNavigationController
            authCoordinator.coordinator = self
            authCoordinator.navigate(to: destination)
        case .upcoming:
            window.rootViewController = rootViewController
            listCoordinator.navigate(to: destination)
        default:
            assertionFailure("Non supported destination")
            break
        }
        window.makeKeyAndVisible()
    }

}
