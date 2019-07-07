//
//  ListViewModel.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-06.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

protocol ListViewModel {
    var fetchableDelegate: Fetchable? { get set }
    var listItems: [ListItem] { get }
    var sections: Int { get }
    func fetchData()
}
