//
//  MovieViewModelTests.swift
//  tmdbTests
//
//  Created by Patrik Qvarnström on 2019-07-08.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import XCTest
@testable import tmdb

class ListViewModelTests: XCTestCase {

    func testFetchDataTriggersDelegateCallback() {
        // given
        let mockViewController = MovieViewControllerMock()
        let mockListViewModel = MockListViewModel(fetchableDelegate: mockViewController)

        // when
        mockListViewModel.fetchData()
        mockListViewModel.search(nil)

        // then
        XCTAssertEqual(mockViewController.callCount, 2)
    }

}

class MockListViewModel: ListViewModel {
    var fetchableDelegate: Fetchable?
    var listItems: [ListItem]
    var listLayout: ListLayout
    var sections: Int

    init(fetchableDelegate: Fetchable) {
        self.fetchableDelegate = fetchableDelegate
        self.listItems = []
        self.listLayout = .largeImages
        sections = 1
    }

    func destination(for indexPath: IndexPath) -> Destination? {
        return nil
    }

    func fetchData() {
        fetchableDelegate?.fetched()
    }

    func tmdb() {
        //
    }

    func search(_ query: String?) {
        fetchableDelegate?.fetched()
    }

}

class MovieViewControllerMock: Fetchable {
    var callCount: Int = 0

    func fetched() {
        callCount += 1
    }
}
