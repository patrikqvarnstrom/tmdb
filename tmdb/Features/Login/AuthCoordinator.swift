//
//  AuthenticationCoordinator.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

class AuthCoordinator: Coordinator {

    weak var coordinator: Coordinator?
    private weak var rootViewController: UINavigationController?

    init(coordinator: Coordinator? = nil, rootViewController: UINavigationController) {
        self.coordinator = coordinator
        self.rootViewController = rootViewController
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .authentication:
            let viewController = LoginViewController()
            viewController.authenticationDelegate = self
            return viewController
        default:
            assertionFailure("Non supported destination")
            return UIViewController()
        }
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .authentication:
            let viewController = makeViewController(for: destination)
            rootViewController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}

extension AuthCoordinator: AuthenticationDelegate {
    func authenticationDidFail() {
        // Error feedback if guest session failed
        // e.g. coordinator?.navigate(to: .signUp)
    }

    func authenticationDidSucceed() {
        coordinator?.navigate(to: .upcoming)
    }

}
