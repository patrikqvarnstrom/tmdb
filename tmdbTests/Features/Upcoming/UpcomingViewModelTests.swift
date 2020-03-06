//
//  UpcomingViewModelTest.swift
//  tmdbTests
//
//  Created by Patrik Qvarnström on 2019-07-08.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import XCTest
@testable import tmdb

class UpcomingViewModelTests: XCTestCase {

    func testLazyLoadFetchIsNotOverloaded() {
        // given
        let viewController = MovieViewControllerMock()
        let upcomingViewModel = UpcomingViewModel(fetchableDelegate: viewController)

        // when
        upcomingViewModel.isFetchInProgress = true
        upcomingViewModel.fetchData()

        // then
        XCTAssertEqual(viewController.callCount, 0)
    }

    func testDestinationForItemIsReturned() {
        // given
        let viewController = MovieViewControllerMock()
        let upcomingViewModel = UpcomingViewModel(fetchableDelegate: viewController)
        upcomingViewModel.listItems = [UpcomingViewModelTests.aListItem()]

        // when
        let destination = upcomingViewModel.destination(for: IndexPath(item: 0, section: 0))

        // then
        XCTAssertNotNil(destination)
    }

    func testSortingByLatestDate() {
        // given
        let upcomingViewModel = UpcomingViewModel()
        let olderListItem = UpcomingViewModelTests.aListItem()
        let latestListItem = UpcomingViewModelTests.aListItem(id: 2, releaseDate: Date().description)

        upcomingViewModel.listItems = [olderListItem,
                                       olderListItem,
                                       latestListItem,
                                       olderListItem]

        // when
        let sorted = upcomingViewModel.sortedByLatestDate(listItems: upcomingViewModel.listItems)

        // then
        XCTAssertEqual(sorted.first?.id, latestListItem.id)
    }

    static func aListItem(id: Int = 1,
                          adult: Bool = false,
                          backdropPath: String? = nil,
                          genres: [Int] = [1, 2, 3],
                          originalLanguage: String = "enUS",
                          originalTitle: String = "Jurassic Park",
                          overview: String = "Dinosaurs",
                          posterPath: String? = nil,
                          popularity: Double = 9.0,
                          releaseDate: String = "19951202",
                          title: String = "Jurassic Park",
                          video: Bool = false,
                          voteAverage: Double = 4.5) -> ListItem {
        return ListItem(id: id,
                        adult: adult,
                        backdropPath: backdropPath,
                        genres: genres,
                        originalLanguage: originalLanguage,
                        originalTitle: originalTitle,
                        overview: overview,
                        posterPath: posterPath,
                        popularity: popularity,
                        releaseDate: releaseDate,
                        title: title,
                        video: video,
                        voteAverage: voteAverage)
    }

}
