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

    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.target(forAction: #selector(dismissSearch), withSender: self)
        return button
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
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

    @objc private func dismissSearch() {
        coordinator?.navigate(to: .upcoming)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.width.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }

    private func setupSearch() {
        guard let listLayout = viewModel?.listLayout else { return }
        switch listLayout {
        case .largeImagesWithSearch:
            hStack.addArrangedSubview(searchBar)
            hStack.addArrangedSubview(dismissButton)
            view.addSubview(hStack)
            hStack.snp.makeConstraints { make in
                make.width.leading.trailing.equalToSuperview().inset(24)
                make.top.equalToSuperview().offset(55)
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

    @objc private func tmdb() {
        viewModel?.tmdb()
    }

    @objc private func search() {
        coordinator?.navigate(to: .search)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            self?.viewModel?.search(with: searchText)
        })
    }
}

extension MovieListViewController: Fetchable {
    func fetched() {
        tableView.reloadData()
    }
}
