//
//  ListViewModel.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-06.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

enum ListLayout {
    case largeImages
    case largeImagesWithSearch
}

protocol ListViewModel: class {
    var fetchableDelegate: Fetchable? { get set }
    var listItems: [ListItem] { get }
    var listLayout: ListLayout { get }
    var sections: Int { get }
    func destination(for indexPath: IndexPath) -> Destination?
    func fetchData()
    func tmdb()
    func search(with query: String)
}
