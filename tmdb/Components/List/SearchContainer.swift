//
//  SearchContainer.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-08.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

class SearchContainer: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        return button
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search .."
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        return searchBar
    }()

    lazy var hStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.sizeToFit()
        return hStack
    }()

    private func setupConstraints() {
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupViews() {
        hStack.addArrangedSubview(searchBar)
        hStack.addArrangedSubview(dismissButton)
        addSubview(hStack)
    }

}
