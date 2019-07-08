//
//  URLOpener.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-08.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//
//  http://swiftyjimmy.com/mock-uiapplication-swift/

import Foundation
import UIKit


protocol URLOpenerProtocol {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

struct URLOpener {
    private let application: URLOpenerProtocol

    init(application: URLOpenerProtocol = UIApplication.shared) {
        self.application = application
    }

    func openWebsite(url: URL, completion: ((Bool) -> Void)?) {
        if application.canOpenURL(url) {
            application.open(url, options: [:], completionHandler: completion)
        } else {
            completion?(false)
        }
    }
}
