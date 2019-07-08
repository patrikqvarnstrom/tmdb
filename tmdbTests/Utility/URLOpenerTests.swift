//
//  URLOpenerTests.swift
//  tmdbTests
//
//  Created by Patrik Qvarnström on 2019-07-08.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import XCTest

@testable import tmdb

class URLOpenerTest: XCTestCase {

    func testURLOpener() {
        // given
        let mockURLOpener = MockUrlOpener()
        let mockURLOpenerWithInvalidURL = MockUrlOpener(validURL: false)

        // when
        mockURLOpener.open(URL(fileURLWithPath: ""), options: [:], completionHandler: nil)
        mockURLOpenerWithInvalidURL.open(URL(fileURLWithPath: ""), options: [:], completionHandler: nil)

        // then
        XCTAssertEqual(mockURLOpener.callCount, 1)
        XCTAssertEqual(mockURLOpenerWithInvalidURL.callCount, 0)
    }

}
class MockUrlOpener: URLOpenerProtocol {
    var callCount: Int = 0
    let validURL: Bool

    init(validURL: Bool = true) {
        self.validURL = validURL
    }

    func canOpenURL(_ url: URL) -> Bool {
        return validURL
    }

    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        if canOpenURL(url) {
            callCount += 1
        }
    }
}
