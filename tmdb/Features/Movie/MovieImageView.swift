//
//  LargeImageView.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-07.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

class MovieImageView: UIView {

    lazy var poster: UIImageView = {
        let poster = UIImageView(image: nil)
        poster.contentMode = .scaleAspectFit
        return poster
    }()

    lazy var backdrop: UIImageView = {
        let backdrop = UIImageView(image: nil)
        backdrop.contentMode = .scaleAspectFit
        backdrop.isHidden = true
        return backdrop
    }()

    lazy var genreLabel: UILabel = {
        let genreLabel = UILabel()
        genreLabel.textAlignment = .center
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
        releaseDateLabel.textAlignment = .center
        releaseDateLabel.numberOfLines = 0
        releaseDateLabel.font = UIFont.systemFont(ofSize: 12)
        releaseDateLabel.adjustsFontSizeToFitWidth = true
        return releaseDateLabel
    }()

    lazy var overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.textAlignment = .center
        overviewLabel.numberOfLines = 0
        overviewLabel.font = UIFont.systemFont(ofSize: 12)
        overviewLabel.adjustsFontSizeToFitWidth = true
        overviewLabel.isHidden = true
        return overviewLabel
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    lazy var spacer: UIView = {
        return UIView()
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
            make.edges.equalToSuperview().inset(24)
        }

        poster.snp.makeConstraints { make in
            make.height.equalTo(500)
        }

        backdrop.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(440)
        }

        spacer.snp.makeConstraints { make in
            make.height.equalTo(8)
        }
    }

    private func setupViews() {
        stackView.addArrangedSubview(backdrop)
        stackView.addArrangedSubview(poster)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(genreLabel)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.addArrangedSubview(spacer)
        addSubview(stackView)
    }

}
