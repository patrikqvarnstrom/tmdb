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
        case .movie(let id):
            let viewController = MovieViewController()
            viewController.setup(with: MovieViewModel(fetchableDelegate: viewController,
                                                      identifier: id))
            return viewController
        case .search:
            let viewController = MovieListViewController(style: .plain)
            viewController.coordinator = self
            viewController.setup(with: UpcomingViewModel(listLayout: .largeImagesWithSearch))
            return viewController
        case .upcoming:
            let viewController = MovieListViewController(style: .plain)
            viewController.coordinator = self
            viewController.setup(with: UpcomingViewModel())
            return viewController
        default:
            assertionFailure("Non supported destination")
            return UIViewController()
        }
    }

    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        switch destination {
        case .movie:
            rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
            rootViewController?.pushViewController(viewController, animated: true)
        case .search:
            rootViewController?.present(viewController,
                                        animated: true,
                                        completion: nil)
        case .upcoming:
            rootViewController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}
