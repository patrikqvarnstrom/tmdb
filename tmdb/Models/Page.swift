//
//  Page.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-06.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

struct Page: Codable {
    let page: Int
    let results: [ListItem]

    enum CodingKeys: String, CodingKey {
        case page, results
    }
}
