//
//  LoginViewModelTests.swift
//  tmdbTests
//
//  Created by Patrik Qvarnström on 2019-07-08.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import XCTest
@testable import tmdb

class LoginViewModelTests: XCTestCase {

    func testAuthenticationDidFail() {
        // given
        let mockLoginViewController = MockLoginViewController()
        let mockSessionHandler = MockSessionHandler()
        let mockLoginViewModel = MockLoginViewModel(delegate: mockLoginViewController,
                                                    session: mockSessionHandler)

        // when
        mockSessionHandler.isSessionValid = false
        mockLoginViewModel.authenticate()

        // then
        XCTAssertEqual(mockLoginViewModel.authenticationRequiredCallCount, 1)
        XCTAssertEqual(mockLoginViewController.didFail, true)
    }

    func testAuthenticationDidSucceed() {
        // given
        let mockLoginViewController = MockLoginViewController()
        let mockSessionHandler = MockSessionHandler()
        let mockLoginViewModel = MockLoginViewModel(delegate: mockLoginViewController,
                                                    session: mockSessionHandler)

        // when
        mockLoginViewModel.authenticate()

        // then
        XCTAssertEqual(mockLoginViewModel.authenticationRequiredCallCount, 0)
        XCTAssertEqual(mockLoginViewController.didSucceed, true)
        XCTAssertEqual(mockSessionHandler.didStoreSession, true)
    }

}

class MockSessionHandler: SessionHandler {
    var didStoreSession: Bool = false
    var isSessionValid: Bool = true
    func authenticationDidSucceed(session: GuestSession) {
        didStoreSession = true
    }
}

class MockLoginViewController: AuthenticationDelegate {
    var didSucceed: Bool = false
    var didFail: Bool = false

    func authenticationDidFail() {
        didFail = true
    }

    func authenticationDidSucceed() {
        didSucceed = true
    }
}

class MockLoginViewModel: AuthenticationViewModel {

    var authenticationRequiredCallCount: Int = 0

    var isSessionValid: Bool {
        return sessionHandler.isSessionValid
    }

    weak var authenticationDelegate: AuthenticationDelegate?

    let sessionHandler: SessionHandler

    init(delegate: AuthenticationDelegate? = nil,
         session: SessionHandler = MockSessionHandler()) {
        self.authenticationDelegate = delegate
        self.sessionHandler = session
    }

    func authenticate() {
        if sessionHandler.isSessionValid {
            authenticationDelegate?.authenticationDidSucceed()
            sessionHandler.authenticationDidSucceed(session: GuestSession(statusMessage: "Success",
                                                                          statusCode: 200,
                                                                          success: true,
                                                                          expiresAt: "",
                                                                          guestID: ""))
        } else {
            authenticationDelegate?.authenticationDidFail()
            authenticationRequired()
        }
    }

    func authenticationRequired() {
        authenticationRequiredCallCount += 1
    }


}
