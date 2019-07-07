//
//  Movie.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-07.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genres: [Genre]
    let id: Int
    let originalTitle: String
    let overview: String?
    let posterPath: String?
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case adult, genres, id, overview
        case backdropPath = "backdrop_path"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
