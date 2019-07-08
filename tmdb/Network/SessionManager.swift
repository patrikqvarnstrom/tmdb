//
//  SessionManager.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

struct GuestSession: Codable {
    let success: Bool
    let expiresAt: String?
    let guestID: String?

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case guestID = "guest_session_id"
    }
}

protocol SessionHandler {
    var isSessionValid: Bool { get }
    func authenticationDidSucceed(session: GuestSession)
}

class SessionManager: SessionHandler {

    private let sessionExpiration = "sessionExpiration"
    private var sessionType: SessionType? = .unauthorized

    enum SessionType {
        case guest
        case unauthorized
    }

    var isSessionValid: Bool {
        guard let storedValue = UserDefaults.standard.value(forKey: sessionExpiration) as? String else { return false }
        guard let expirationDate = DateFormatter().date(from: storedValue) else { return true }
        return expirationDate > Date()
    }

    func authenticationDidSucceed(session: GuestSession) {
        sessionType = .guest
        UserDefaults.standard.set(session.expiresAt, forKey: sessionExpiration)
    }

}
