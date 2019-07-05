//
//  UpcomingViewModel.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

final class UpcomingViewModel {

    private let tmdbService: TMDBService

    var sections = 1
    var listItems = [ListItem]()

    weak var fetchableDelegate: Fetchable?

    init(fetchableDelegate: Fetchable? = nil,
         tmdbService: TMDBService = TMDBService()) {
        self.fetchableDelegate = fetchableDelegate
        self.tmdbService = tmdbService
    }

    func fetchData() {
        tmdbService.fetchUpcoming(completionHandler: { [weak self] page, err in
            if err == nil {
                self?.listItems = page?.results ?? []
            }
            self?.fetchableDelegate?.fetched()
        })
    }

    func search(query: String) {
        return
    }

    func filterResults() {
        return
    }

}
