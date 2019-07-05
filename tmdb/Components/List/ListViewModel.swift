//
//  ListViewModel.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

protocol Fetchable: class {
    func fetched()
}

class ListViewModel {

    var sections = 1
    var listItems = [ListItem]()

    weak var fetchableDelegate: Fetchable?

    init(fetchableDelegate: Fetchable? = nil) {
        self.fetchableDelegate = fetchableDelegate
    }

    func fetchData() {
        fetchableDelegate?.fetched()
    }

    func search(with query: String) {
        return
    }

    func filterResults() {
        return
    }

}
