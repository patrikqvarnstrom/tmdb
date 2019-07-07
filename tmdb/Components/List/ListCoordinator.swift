//
//  ListCoordinator.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

class ListCoordinator: Coordinator {

    private weak var rootViewController: UINavigationController?

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .movie:
            return UIViewController()
        case .upcoming:
            let viewController = ListViewController(style: .grouped)
            viewController.setup(with: UpcomingViewModel())
            return viewController
        default:
            assertionFailure("Non supported destination")
            return UIViewController()
        }
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .movie:
            let viewController = makeViewController(for: destination)
            rootViewController?.pushViewController(viewController, animated: true)
        case .upcoming:
            let viewController = makeViewController(for: destination)
            rootViewController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}
