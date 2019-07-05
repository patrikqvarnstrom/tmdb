//
//  ListItem.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

struct ListItem: Codable {
    let id: String
    let adult: Bool
    let backdropPath: String
    let genres: [Genre]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let posterPath: URL
    let popularity: Double
    let releaseDate: Date
    let title: String
    let video: Bool
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case adult, id, overview, popularity, title, video
        case backdropPath = "backdrop_path"
        case genres = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

