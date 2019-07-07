//
//  MovieViewController.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-07.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import Foundation
import UIKit

class MovieViewController: UIViewController {

    private var viewModel: MovieViewModel?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    lazy var largeImageView: MovieImageView = {
        return MovieImageView()
    }()

    override func viewDidLoad() {
        setupViews()
        setupConstraints()
        viewModel?.fetchData()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.bottom.equalToSuperview()
        }
        largeImageView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
        }
    }

    private func setupFields() {
        guard let movie = viewModel?.movie else { return }
        navigationItem.title = movie.originalTitle
        let genres = movie.genres.compactMap { $0.name }

        largeImageView.overviewLabel.text = movie.overview ?? ""
        largeImageView.genreLabel.text = genres.joined(separator: ", ")
        largeImageView.titleLabel.text = movie.originalTitle
        largeImageView.releaseDateLabel.text = "Release date: \(movie.releaseDate)"

        if let imageUrl = Router(.image(path: movie.posterPath ?? "")).asURLRequest()?.url {
            self.largeImageView.poster.sd_setImage(with: imageUrl)
        }
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        largeImageView.overviewLabel.isHidden = false
        scrollView.addSubview(largeImageView)
    }

    func setup(with viewModel: MovieViewModel) {
        self.viewModel = viewModel
    }

}

extension MovieViewController: Fetchable {
    func fetched() {
        setupFields()
    }
}
