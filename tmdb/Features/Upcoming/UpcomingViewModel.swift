//
//  UpcomingViewModel.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

final class UpcomingViewModel: ListViewModel {

    private let tmdbService: TMDBService

    var sections = 3
    var listItems = [ListItem]()

    private var isFetchInProgress: Bool = false
    private var page: Int = 1

    weak var fetchableDelegate: Fetchable?

    init(fetchableDelegate: Fetchable? = nil,
         tmdbService: TMDBService = TMDBService()) {
        self.fetchableDelegate = fetchableDelegate
        self.tmdbService = tmdbService
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

    func search(query: String) {
        return
    }

    func filterResults() {
        return
    }

}
