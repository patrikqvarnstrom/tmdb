//
//  MovieViewModel.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-07.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

final class MovieViewModel {

    private let identifier: String
    private let tmdbService: TMDBService

    var movie: Movie?

    weak var fetchableDelegate: Fetchable?

    init(fetchableDelegate: Fetchable? = nil,
         identifier: String,
         tmdbService: TMDBService = TMDBService()) {
        self.fetchableDelegate = fetchableDelegate
        self.identifier = identifier
        self.tmdbService = tmdbService
    }

    func fetchData() {
        tmdbService.fetchMovie(with: identifier, completionHandler: { [weak self] movie, err in
            if err == nil {
                self?.movie = movie ?? nil
            }
            self?.fetchableDelegate?.fetched()
        })
    }

}
