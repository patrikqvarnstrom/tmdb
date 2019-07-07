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

class MovieListViewController: UITableViewController {

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search .."
        searchBar.sizeToFit()
        return searchBar
    }()

    private var viewModel: ListViewModel?

    weak var coordinator: Coordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSearch()
        viewModel?.fetchableDelegate = self
        viewModel?.fetchData()
    }

    func setup(with viewModel: ListViewModel) {
        self.viewModel = viewModel
    }

    private func setupSearch() {
        guard let listLayout = viewModel?.listLayout else { return }
        switch listLayout {
        case .largeImagesWithSearch:
            tableView.tableHeaderView = searchBar
            searchBar.snp.makeConstraints { make in
                make.leading.trailing.top.width.equalToSuperview()
            }
        default:
            break
        }
    }

    private func setupViews() {
        title = "Upcoming"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MovieLargeListCell.self, forCellReuseIdentifier: MovieLargeListCell.reuseIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "tmdb-logo"), style: .plain, target: self, action: #selector(tmdb))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(search))
    }

    @objc private func tmdb() {
        viewModel?.tmdb()
    }

    @objc private func search() {
        coordinator?.navigate(to: .search)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel?.listItems[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieLargeListCell.reuseIdentifier, for: indexPath) as? MovieLargeListCell else { return UITableViewCell() }

        cell.largeImageView.genreLabel.text = item.genres.genreNames.joined(separator: ", ")
        cell.largeImageView.releaseDateLabel.text = "Release date: \(item.releaseDate)"
        cell.largeImageView.titleLabel.text = item.originalTitle

        if let imageUrl = Router(.image(path: item.posterPath ?? "")).asURLRequest()?.url {
            cell.largeImageView.poster.sd_setImage(with: imageUrl)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = viewModel?.destination(for: indexPath) else { return }
        coordinator?.navigate(to: destination)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = viewModel?.listItems.count else { return }
        if indexPath.row == count - 1 { viewModel?.fetchData() }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.listItems.count ?? 0
    }

}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { [weak self] in
            self?.viewModel?.search(with: searchText)
        })
    }
}

extension MovieListViewController: Fetchable {
    func fetched() {
        tableView.reloadData()
    }
}
