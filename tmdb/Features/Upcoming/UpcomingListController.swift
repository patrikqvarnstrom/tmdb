//
//  UpcomingListController.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import UIKit

class UpcomingListController: UITableViewController {

    lazy var viewModel: UpcomingViewModel = {
        return UpcomingViewModel()
    }()

    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.fetchableDelegate = self
        viewModel.fetchData()
    }

    private func setupViews() {
        title = "Upcoming"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.listItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = item.title
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listItems.count
    }

}

extension UpcomingListController: Fetchable {
    func fetched() {
        tableView.reloadData()
    }
}

extension UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
