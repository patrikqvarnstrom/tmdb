//
//  UpcomingViewModel.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

final class SearchViewModel: ListViewModel {

    private let tmdbService: TMDBService

    var listLayout: ListLayout
    var listItems = [ListItem]()
    var sections = 1

    private var isFetchInProgress: Bool = false
    private var query: String?

    weak var fetchableDelegate: Fetchable?

    init(fetchableDelegate: Fetchable? = nil,
         listLayout: ListLayout = .largeImages,
         tmdbService: TMDBService = TMDBService()) {
        self.fetchableDelegate = fetchableDelegate
        self.listLayout = listLayout
        self.tmdbService = tmdbService
        search(with: "Jurassic")
    }

    func destination(for indexPath: IndexPath) -> Destination? {
        let item = listItems[indexPath.row]
        return .movie(id: item.id.description)
    }

    func fetchData() {
        guard let queryString = query else { return }
        search(with: queryString)
    }

    func tmdb() {
        guard let url = URL(string: "https://www.themoviedb.org") else { return }
        UIApplication.shared.open(url)
    }

    func search(with query: String) {
        self.query = query
        guard !isFetchInProgress else { return }
        isFetchInProgress = true
        tmdbService.fetchSearchResults(query: query, completionHandler: { [weak self] page, err in
            if err == nil {
                self?.listItems = page?.results ?? []
                self?.query = nil
            }
            self?.isFetchInProgress = false
            self?.fetchableDelegate?.fetched()
        })
    }

}
