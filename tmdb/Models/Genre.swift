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
}
