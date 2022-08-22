//
//  ListViewController.swift
//  NearbyCafe
//
//  Created by user on 10.08.2022.
//

import UIKit

final class ListViewController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    var places = [PlaceModel]()
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
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
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as! ListTableViewCell
        
        let place = places[indexPath.row]
        cell.configure(with: place)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Fileprivate extensions

private extension String {
    static let navigationTitle = "List"
}
