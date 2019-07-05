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

class LoginViewModel {

    weak var authenticationDelegate: AuthenticationDelegate?

    var isAuthenticationValid: Bool {
        return SessionManager.isAuthenticationValid
    }

    private let tmdbService: TMDBService

    init(authenticationDelegate: AuthenticationDelegate? = nil,
         tmdbService: TMDBService = TMDBService()) {
        self.authenticationDelegate = authenticationDelegate
        self.tmdbService = tmdbService
    }

    func authenticationRequired() {
        tmdbService.authenticateGuest(completionHandler: { [weak self] result, err in
            if let sesssion = result {
                SessionManager.authenticationDidSucceed(session: sesssion)
                self?.authenticationDelegate?.authenticationDidSucceed()
            } else {
                self?.authenticationDelegate?.authenticationDidFail()
            }
        })
    }
    

}
