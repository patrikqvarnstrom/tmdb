//
//  LargeListCell.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-07.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

class LargeListCell: UICollectionViewCell {

    lazy var poster: UIImageView = {
        return UIImageView(image: nil)
    }()

    lazy var genreLabel: UILabel = {
        let genreLabel = UILabel()
        genreLabel.numberOfLines = 0
        genreLabel.font = UIFont.systemFont(ofSize: 12)
        genreLabel.adjustsFontSizeToFitWidth = true
        return genreLabel
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()

    lazy var releaseDateLabel: UILabel = {
        let releaseDateLabel = UILabel()
        releaseDateLabel.numberOfLines = 0
        releaseDateLabel.font = UIFont.systemFont(ofSize: 12)
        releaseDateLabel.adjustsFontSizeToFitWidth = true
        return releaseDateLabel
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupViews() {
        stackView.addArrangedSubview(poster)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(genreLabel)
        stackView.addArrangedSubview(releaseDateLabel)
        addSubview(stackView)
    }

}
