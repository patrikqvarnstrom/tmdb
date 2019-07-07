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

    enum ImageWidth: String {
        case large = "w780"
    }

    private var apiKey: String {
        return ""
    }

    var suffix: String {
        return "api_key=\(apiKey)"
    }

    var suffixWithLanguage: String {
        return "api_key=\(apiKey)&language=en-US"
    }

    private var baseUrlForImages: String {
        return "https://image.tmdb.org/t/p/\(ImageWidth.large.rawValue)"
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
        switch route {
        case .image:
            guard let fullURL = URL(string: baseUrlForImages + path) else { fatalError("Unable to parse url for " + path)}
            var request = URLRequest(url: fullURL)
            request.httpMethod = method.rawValue
            return request
        default:
            guard let fullURL = URL(string: baseURL + path) else { fatalError("Unable to parse url for " + path)}
            var request = URLRequest(url: fullURL)
            request.httpMethod = method.rawValue
            return request
        }
    }

    private func pathAndParameters() -> (path: String, parameters: [String: Any]?) {
        switch route {
        case .authenticate:
            return (route.path + suffix, nil)
        case .search(let page, let query):
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return (route.path + suffix, nil)
            }
            return (route.path + suffix + "&query=\(encodedQuery)" + "&page=\(page)", nil)
        case .movie(let id):
            return (route.path + "\(id)?" + suffixWithLanguage, nil)
        case .upcoming(let page):
            return (route.path + suffixWithLanguage + "&page=\(page)", nil)
        case .image:
            return (route.path, nil)
        }
    }

    enum Route {
        case authenticate
        case image(path: String)
        case movie(id: String)
        case search(page: String, query: String)
        case upcoming(page: String)

        var path: String {
            switch self {
            case .authenticate:
                return "authentication/guest_session/new?"
            case .image(let path):
                return path
            case .movie:
                return "movie/"
            case .search:
                return "search/movie?"
            case .upcoming:
                return "movie/upcoming?"
            }
        }
    }
}
