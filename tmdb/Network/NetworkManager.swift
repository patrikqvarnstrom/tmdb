//
//  NetworkManager.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
    case success(T?)
    case failure(Error)
}

class NetworkManager {

    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func loadData<T: Decodable>(from request: URLRequest?,
                                model: T.Type,
                                completionHandler: @escaping (NetworkResult<T>) -> Void) {

        loadData(from: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return completionHandler(.failure(NSError(domain: "data was nil", code: 500, userInfo: nil)))}
                do {
                    let value = try JSONDecoder().decode(T.self, from: data)
                    return completionHandler(.success(value))
                } catch {
                    return completionHandler(.failure(error))
                }
            case .failure(let error):
                print("ERROR: \(error)")
                return completionHandler(.failure(error))
            }
        }
    }

    func loadData(from request: URLRequest?,
                  completionHandler: @escaping (NetworkResult<Data>) -> Void) {

        guard let request = request else { return DispatchQueue.main.async { completionHandler(.failure(NSError(domain: "nil response", code: 500, userInfo: nil))) } }
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                return DispatchQueue.main.async { completionHandler(.failure(error ?? NSError(domain: "nil response", code: 500, userInfo: ["request": request]))) }
            }

            if let error = error {
                return DispatchQueue.main.async { completionHandler(.failure(error)) }
            }

            guard let data = data else { return DispatchQueue.main.async { completionHandler(.failure(error ?? NSError(domain: "response data was nil", code: httpResponse.statusCode, userInfo: ["request": request, "response": httpResponse])))} }

            return DispatchQueue.main.async { completionHandler(.success(data)) }
        }
        task.resume()
    }

}
