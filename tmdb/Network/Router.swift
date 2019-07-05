//
//  Router.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import Alamofire

struct Router {

    let route: Route

    init(_ route: Route) {
        self.route = route
    }

    private var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }

    private var encoding: ParameterEncoding {
        switch route {
        default:
            return URLEncoding()
        }
    }

    private var method: HTTPMethod {
        switch route {
        default: return .get
        }
    }

    private var httpHeaders: [String: String]? {
        return [
            "User-Agent": "TMDB-iOS",
            "Accept": "application/json, text/plain, */*",
            "Content-Type": "application/json"
        ]
    }

    func asURLRequest() -> URLRequest? {
        let (path, parameters) = pathAndParameters()
        return try? encoding.encode(createURLRequest(path: path), with: parameters)
    }

    private func createURLRequest(path: String) -> URLRequest {
        guard let fullURL = URL(string: baseURL + path) else { fatalError("Unable to parse url for " + path)}
        var request = URLRequest(url: fullURL)
        request.httpMethod = method.rawValue
        return request
    }

    private func pathAndParameters() -> (path: String, parameters: [String: Any]?) {
        switch route {
        case .authenticate:
            return (route.path, nil)
        case .movie(let id):
            return (route.path, ["": id])
        case .upcoming(let page):
            return (route.path, ["&page=": page])
        }
    }

    enum Route {
        case authenticate
        case movie(id: String)
        case upcoming(page: String)

        var path: String {
            switch self {
            case .authenticate:
                return "authentication/guest_session/new?"
            case .movie:
                return "movie/"
            case .upcoming:
                return "movie/upcoming?"
            }
        }
    }
}
