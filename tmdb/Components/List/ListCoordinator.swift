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
        case .search(let query):
            let viewController = MovieListViewController()
            viewController.title = "Search"
            viewController.coordinator = self
            viewController.setup(with: SearchViewModel(listLayout: .largeImagesWithSearch,
                                                       query: query))
            return viewController
        case .upcoming:
            let viewController = MovieListViewController()
            viewController.title = "Upcoming"
            viewController.coordinator = self
            viewController.setup(with: UpcomingViewModel(coordinator: self))
            return viewController
        default:
            assertionFailure("Non supported destination")
            return UIViewController()
        }
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .search:
            let viewController = makeViewController(for: destination)
            rootViewController?.present(viewController, animated: true, completion: nil)
        case .movie, .upcoming:
            rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
            let viewController = makeViewController(for: destination)
            rootViewController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}
