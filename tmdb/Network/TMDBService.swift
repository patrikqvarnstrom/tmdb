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

    var apiKey: String {
        return "nottherealkey"
    }

    var suffix: String {
        return "api_key=\(apiKey)"
    }

    init(networkManager: NetworkManager,
         urlSession: URLSession = URLSession(configuration: .default)) {
        self.networkManager = networkManager
        self.urlSession = urlSession
    }

    private func getUpcoming(listRequest: ListRequest, onCompletion: @escaping (NetworkResult<[ListItem]>) -> Void) {
        networkManager.loadData(from: Router(.upcoming(page: listRequest.page)).asURLRequest(), model: [ListItem].self) { result in
                onCompletion(result)
        }
    }

    func fetchUpcoming(page: String = "1",
                          completionHandler: @escaping (_ listItems: [ListItem]?, _ error: Error?) -> Void) {
        getUpcoming(listRequest: ListRequest(page: page), onCompletion: { result in
            switch result {
            case .failure(let error):
                completionHandler(nil, error)
            case .success(let items):
                completionHandler(items, nil)
            }
        })
    }

}






