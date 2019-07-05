//
//  SessionManager.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

struct GuestSession: Codable {
    let statusMessage: String?
    let statusCode: Int?
    let success: Bool
    let expiresAt: String?
    let guestID: String?

    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_message"
        case statusCode = "status_code"
        case expiresAt = "expires_at"
        case guestID = "guest_session_id"
    }
}

class SessionManager {

    static let shared = SessionManager()

    static private let sessionExpiration = "sessionExpiration"
    static private var sessionType: SessionType? = .unauthorized

    enum SessionType {
        case guest
        case unauthorized
    }

    static var isAuthenticationValid: Bool {
        guard let storedValue = UserDefaults.standard.value(forKey: sessionExpiration) as? String else { return false }
        guard let expirationDate = DateFormatter().date(from: storedValue) else { return true }
        return expirationDate > Date()
    }

    static func authenticationDidSucceed(session: GuestSession) {
        SessionManager.sessionType = .guest
        UserDefaults.standard.set(session.expiresAt, forKey: sessionExpiration)
    }

}
