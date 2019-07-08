//
//  UpcomingViewModel.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

final class UpcomingViewModel: ListViewModel {

    private let tmdbService: TMDBService
    private let urlOpener: URLOpener

    var listLayout: ListLayout
    var listItems = [ListItem]()
    var isFetchInProgress: Bool = false
    var sections = 1
    
    private var page: Int = 1

    weak var coordinator: Coordinator?
    weak var fetchableDelegate: Fetchable?

    init(application: UIApplication = UIApplication.shared,
         coordinator: Coordinator? = nil,
         fetchableDelegate: Fetchable? = nil,
         listLayout: ListLayout = .largeImages,
         tmdbService: TMDBService = TMDBService(),
         urlOpener: URLOpener = URLOpener()) {
        self.coordinator = coordinator
        self.fetchableDelegate = fetchableDelegate
        self.listLayout = listLayout
        self.tmdbService = tmdbService
        self.urlOpener = urlOpener
    }

    func destination(for indexPath: IndexPath) -> Destination? {
        let item = listItems[indexPath.row]
        return .movie(id: item.id.description)
    }

    func sortedByLatestDate(listItems: [ListItem]) -> [ListItem] {
        return listItems.sorted { $0.releaseDate > $1.releaseDate }
    }

    func fetchData() {
        guard !isFetchInProgress else { return }
        isFetchInProgress = true

        tmdbService.fetchUpcoming(page: page.description, completionHandler: { [weak self] page, err in
            self?.isFetchInProgress = false
            if err == nil {
                self?.page += 1
                if let results = self?.sortedByLatestDate(listItems: page?.results ?? []) {
                    self?.listItems.append(contentsOf: results)
                }
            }
            self?.fetchableDelegate?.fetched()
        })
    }

    func tmdb() {
        guard let url = URL(string: "https://www.themoviedb.org") else { return }
        urlOpener.openWebsite(url: url, completion: nil)
    }

    func search(_ query: String? = nil) {
        coordinator?.navigate(to: .search(query: nil))
    }

}
