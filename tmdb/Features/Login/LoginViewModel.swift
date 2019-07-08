//
//  LoginViewModel.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

protocol AuthenticationDelegate: class {
    func authenticationDidFail()
    func authenticationDidSucceed()
}

protocol AuthenticationViewModel {
    var isSessionValid: Bool { get }
    func authenticate()
    func authenticationRequired()
}

class LoginViewModel: AuthenticationViewModel {

    weak var authenticationDelegate: AuthenticationDelegate?

    var isSessionValid: Bool {
        return sessionHandler.isSessionValid
    }

    private let tmdbService: TMDBService
    private let sessionHandler: SessionHandler

    init(authenticationDelegate: AuthenticationDelegate? = nil,
         tmdbService: TMDBService = TMDBService(),
         sessionHandler: SessionHandler = SessionManager()) {
        self.authenticationDelegate = authenticationDelegate
        self.tmdbService = tmdbService
        self.sessionHandler = sessionHandler
    }

    func authenticate() {
        isSessionValid ? authenticationDelegate?.authenticationDidSucceed() : authenticationRequired()
    }

    func authenticationRequired() {
        tmdbService.authenticateGuest(completionHandler: { [weak self] result, err in
            if let sesssion = result {
                self?.sessionHandler.authenticationDidSucceed(session: sesssion)
                self?.authenticationDelegate?.authenticationDidSucceed()
            } else {
                self?.authenticationDelegate?.authenticationDidFail()
            }
        })
    }
    

}
