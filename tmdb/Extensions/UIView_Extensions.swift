//
//  UIView_Extensions.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-06.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
