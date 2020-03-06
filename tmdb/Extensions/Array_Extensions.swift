//
//  Array_Extensions.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-07.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    var genreNames: [String] {
        return compactMap { GenreType(rawValue: $0)?.name }
    }
}
