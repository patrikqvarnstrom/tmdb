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
    private let urlOpener: URLOpener

    var listLayout: ListLayout
    var listItems = [ListItem]()
    var sections = 1

    private var isFetchInProgress: Bool = false
    private var query: String? = nil

    weak var fetchableDelegate: Fetchable?

    init(fetchableDelegate: Fetchable? = nil,
         listLayout: ListLayout = .largeImages,
         tmdbService: TMDBService = TMDBService(),
         urlOpener: URLOpener = URLOpener(),
         query: String? = nil) {
        self.fetchableDelegate = fetchableDelegate
        self.listLayout = listLayout
        self.tmdbService = tmdbService
        self.urlOpener = urlOpener
        self.query = query ?? "Jurassic"
        fetchData()
    }

    func destination(for indexPath: IndexPath) -> Destination? {
        let item = listItems[indexPath.row]
        return .movie(id: item.id.description)
    }

    func fetchData() {
        guard let queryString = query else { return }
        search(queryString)
    }

    func tmdb() {
        guard let url = URL(string: "https://www.themoviedb.org") else { return }
        urlOpener.openWebsite(url: url, completion: nil)
    }

    func search(_ query: String? = nil) {
        guard let queryString = query else { return }
        self.query = queryString
        guard !isFetchInProgress else { return }
        isFetchInProgress = true
        tmdbService.fetchSearchResults(query: queryString, completionHandler: { [weak self] page, err in
            if err == nil {
                self?.listItems = page?.results ?? []
                self?.query = nil
            }
            self?.isFetchInProgress = false
            self?.fetchableDelegate?.fetched()
        })
    }

}
