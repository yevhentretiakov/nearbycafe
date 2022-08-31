//
//  ListViewController.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 10.08.2022.
//

import UIKit

final class ListViewController: UIViewController {
    // MARK: - Properties
    
    var presenter: ListViewPresenter!
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        presenter.viewDidLoad()
    }
    
    // MARK: - Methods
    
    private func setupNavigationBar() {
        title = .navigationTitle
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: ListTableViewCell.self))
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as! ListTableViewCell
        
        let place = presenter.getItem(at: indexPath.row)
        cell.configure(with: place)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.close()
    }
}

// MARK: - Private extensions

private extension String {
    static let navigationTitle = "List"
}

// MARK: - ListViewProtocol

extension ListViewController: ListView {
    func updateView() {
        tableView.reloadData()
    }
}
