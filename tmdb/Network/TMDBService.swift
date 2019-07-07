//
//  TMDBService.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

struct SearchRequest {
    let query: String
}

struct ListRequest {
    let page: String
}

struct MovieRequest {
    let movie: String
}

class TMDBService {

    private let networkManager: NetworkManager
    private let urlSession: URLSession

    private var dataTask: URLSessionDataTask?

    init(networkManager: NetworkManager = NetworkManager(),
         urlSession: URLSession = URLSession(configuration: .default)) {
        self.networkManager = networkManager
        self.urlSession = urlSession
    }

    private func getSearchResult(searchRequest: SearchRequest, onCompletion: @escaping (NetworkResult<MoviePage>) -> Void) {
        networkManager.loadData(from: Router(.search(query: searchRequest.query)).asURLRequest(), model: MoviePage.self) { result in
            onCompletion(result)
        }
    }

    private func getMovie(movieRequest: MovieRequest, onCompletion: @escaping (NetworkResult<Movie>) -> Void) {
        networkManager.loadData(from: Router(.movie(id: movieRequest.movie)).asURLRequest(), model: Movie.self) { result in
            onCompletion(result)
        }
    }

    private func guestSessionAuthentication(onCompletion: @escaping (NetworkResult<GuestSession>) -> Void) {
        networkManager.loadData(from: Router(.authenticate).asURLRequest(), model: GuestSession.self) { result in
            onCompletion(result)
        }
    }

    private func getUpcoming(listRequest: ListRequest, onCompletion: @escaping (NetworkResult<MoviePage>) -> Void) {
        networkManager.loadData(from: Router(.upcoming(page: listRequest.page)).asURLRequest(), model: MoviePage.self) { result in
                onCompletion(result)
        }
    }

    func authenticateGuest(completionHandler: @escaping (_ guestSession: GuestSession?, _ error: Error?) -> Void) {
        guestSessionAuthentication(onCompletion: { result in
            switch result {
            case .failure(let error):
                completionHandler(nil, error)
            case .success(let session):
                completionHandler(session, nil)
            }
        })
    }

    func fetchUpcoming(page: String = "1", completionHandler: @escaping (_ page: MoviePage?, _ error: Error?) -> Void) {
        getUpcoming(listRequest: ListRequest(page: page), onCompletion: { result in
            switch result {
            case .failure(let error):
                print(error)
                completionHandler(nil, error)
            case .success(let page):
                completionHandler(page, nil)
            }
        })
    }

    func fetchMovie(with id: String, completionHandler: @escaping (_ movie: Movie?, _ error: Error?) -> Void) {
        getMovie(movieRequest: MovieRequest(movie: id), onCompletion: { result in
            switch result {
            case .failure(let error):
                print(error)
                completionHandler(nil, error)
            case .success(let movie):
                completionHandler(movie, nil)
            }
        })
    }

    func fetchSearchResults(query: String, completionHandler: @escaping (_ searchPage: MoviePage?, _ error: Error?) -> Void) {
        getSearchResult(searchRequest: SearchRequest(query: query), onCompletion: { result in
            switch result {
            case .failure(let error):
                print(error)
                completionHandler(nil, error)
            case .success(let searchPage):
                completionHandler(searchPage, nil)
            }
        })
    }

}






