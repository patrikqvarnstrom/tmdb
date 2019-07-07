//
//  Genre.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id, name
    }

    var description: String {
        guard let genre = GenreType(rawValue: id) else { return "" }
        return genre.name
    }

}

enum GenreType: Int {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scifi = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37

    var name: String {
        switch self {
        case .action:
            return "Action"
        case .adventure:
            return "Adventure"
        case .animation:
            return "Animation"
        case .comedy:
            return "Comedy"
        case .documentary:
            return "Documentary"
        case .drama:
            return "Drama"
        case .family:
            return "Family"
        case .fantasy:
            return "Fantasy"
        case .history:
            return "History"
        case .horror:
            return "Horror"
        case .music:
            return "Music"
        case .mystery:
            return "Mystery"
        case .romance:
            return "Romance"
        case .scifi:
            return "Science Fiction"
        case .thriller:
            return "Thriller"
        case .tvMovie:
            return "Tv-movie"
        case .war:
            return "War"
        case .western:
            return "Western"
        }
    }
}

