//
//  ListViewController.swift
//  tmdb
//
//  Created by Patrik Qvarnström on 2019-07-05.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    lazy var viewModel: ListViewModel = {
        return ListViewModel()
    }()

    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.fetchableDelegate = self
        viewModel.fetchData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listItems.count
    }

}

extension ListViewController: Fetchable {
    func fetched() {
        tableView.reloadData()
    }
}
