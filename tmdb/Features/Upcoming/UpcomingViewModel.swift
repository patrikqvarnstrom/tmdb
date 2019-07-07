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

    var listLayout: ListLayout
    var listItems = [ListItem]()
    var sections = 1

    private var isFetchInProgress: Bool = false
    private var page: Int = 1

    weak var fetchableDelegate: Fetchable?

    init(fetchableDelegate: Fetchable? = nil,
         listLayout: ListLayout = .largeImages,
         tmdbService: TMDBService = TMDBService()) {
        self.fetchableDelegate = fetchableDelegate
        self.listLayout = listLayout
        self.tmdbService = tmdbService
    }

    func destination(for indexPath: IndexPath) -> Destination? {
        let item = listItems[indexPath.row]
        return .movie(id: item.id.description)
    }

    func fetchData() {
        guard !isFetchInProgress else { return }
        isFetchInProgress = true

        tmdbService.fetchUpcoming(page: page.description, completionHandler: { [weak self] page, err in
            self?.isFetchInProgress = false
            if err == nil {
                self?.page += 1
                self?.listItems.append(contentsOf: page?.results ?? []) 
            }
            self?.fetchableDelegate?.fetched()
        })
    }

    func tmdb() {
        guard let url = URL(string: "https://www.themoviedb.org") else { return }
        UIApplication.shared.open(url)
    }

    func search(with query: String) {
        guard !isFetchInProgress else { return }
        isFetchInProgress = true

        tmdbService.fetchSearchResults(page: page.description, query: query, completionHandler: { [weak self] page, err in
            self?.isFetchInProgress = false
            if err == nil {
                self?.page += 1
                self?.listItems = page?.results ?? []
            }
            self?.fetchableDelegate?.fetched()
        })
    }

}
