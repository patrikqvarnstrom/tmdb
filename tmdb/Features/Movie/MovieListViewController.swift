//
//  MovieListViewController.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import UIKit

import SDWebImage
import SnapKit

class MovieListViewController: UIViewController {

    lazy var searchContainer: SearchContainer = {
        let searchContainer = SearchContainer()
        searchContainer.backgroundColor = .white
        searchContainer.dismissButton.addTarget(self, action: #selector(dismissSearch), for: .touchUpInside)
        searchContainer.searchBar.delegate = self
        return searchContainer
    }()

    lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .plain)
    }()

    private var viewModel: ListViewModel?

    weak var coordinator: Coordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupSearch()
        viewModel?.fetchableDelegate = self
        viewModel?.fetchData()
    }

    func setup(with viewModel: ListViewModel) {
        self.viewModel = viewModel
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.width.equalToSuperview()
            make.top.equalToSuperview()
        }
    }

    private func setupSearch() {
        guard let listLayout = viewModel?.listLayout else { return }
        switch listLayout {
        case .largeImagesWithSearch:
            view.addSubview(searchContainer)
            searchContainer.snp.makeConstraints { make in
                make.width.leading.trailing.equalToSuperview().inset(24)
                make.top.equalToSuperview().offset(55)
            }
            tableView.snp.remakeConstraints { make in
                make.bottom.leading.trailing.width.equalToSuperview()
                make.top.equalToSuperview().offset(100)
            }
        default:
            break
        }
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MovieLargeListCell.self, forCellReuseIdentifier: MovieLargeListCell.reuseIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "tmdb-logo"), style: .plain, target: self, action: #selector(tmdb))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(search))
    }

    @objc private func dismissSearch() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func search() {
        viewModel?.search(nil)
    }

    @objc private func tmdb() {
        viewModel?.tmdb()
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel?.listItems[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieLargeListCell.reuseIdentifier, for: indexPath) as? MovieLargeListCell else { return UITableViewCell() }

        cell.largeImageView.genreLabel.text = item.genres.genreNames.joined(separator: ", ")
        cell.largeImageView.releaseDateLabel.text = "Release date: \(item.releaseDate)"
        cell.largeImageView.titleLabel.text = item.originalTitle

        if let posterUrl = Router(.image(path: item.posterPath ?? "")).asURLRequest()?.url {
            cell.largeImageView.poster.sd_setImage(with: posterUrl)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = viewModel?.destination(for: indexPath) else { return }
        coordinator?.navigate(to: destination)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = viewModel?.listItems.count else { return }
        if indexPath.row == count - 1 { viewModel?.fetchData() }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.listItems.count ?? 0
    }

}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { [weak self] in
            self?.viewModel?.search(searchText)
        })
    }
}

extension MovieListViewController: Fetchable {
    func fetched() {
        tableView.reloadData()
    }
}
