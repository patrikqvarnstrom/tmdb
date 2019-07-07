//
//  UpcomingListController.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import UIKit

import SDWebImage
import SnapKit

class ListViewController: UITableViewController {

    private var viewModel: ListViewModel?

    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel?.fetchableDelegate = self
        viewModel?.fetchData()
    }

    func setup(with viewModel: ListViewModel) {
        self.viewModel = viewModel
    }

    private func setupViews() {
        title = "Upcoming"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LargeListCell.self, forCellReuseIdentifier: LargeListCell.reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel?.listItems[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LargeListCell.reuseIdentifier, for: indexPath) as? LargeListCell else { return UITableViewCell() }
        
        cell.genreLabel.text = item.genres.description
        cell.releaseDateLabel.text = item.releaseDate
        cell.titleLabel.text = item.originalTitle

        if let imageUrl = Router(.image(path: item.posterPath ?? "")).asURLRequest()?.url {
            cell.poster.sd_setImage(with: imageUrl)
        }

        return cell
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

extension ListViewController: Fetchable {
    func fetched() {
        tableView.reloadData()
    }
}
