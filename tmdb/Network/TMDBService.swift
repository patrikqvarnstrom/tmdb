//
//  TMDBService.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

struct ListRequest {
    let page: String
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

    private func guestSessionAuthentication(onCompletion: @escaping (NetworkResult<GuestSession>) -> Void) {
        networkManager.loadData(from: Router(.authenticate).asURLRequest(), model: GuestSession.self) { result in
            onCompletion(result)
        }
    }

    private func getUpcoming(listRequest: ListRequest, onCompletion: @escaping (NetworkResult<Page>) -> Void) {
        networkManager.loadData(from: Router(.upcoming(page: listRequest.page)).asURLRequest(), model: Page.self) { result in
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

    func fetchUpcoming(page: String = "1", completionHandler: @escaping (_ page: Page?, _ error: Error?) -> Void) {
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

}






