//
//  ListViewController.swift
//  NearbyCafe
//
//  Created by user on 10.08.2022.
//

import UIKit

final class ListViewController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    var places = [PlaceModel]()
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List"
        setupTableView()
    }
    
    // MARK: - Methods
    
    private func setupTableView() {
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: ListTableViewCell.cellID)
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.cellID, for: indexPath) as! ListTableViewCell
        
        let place = places[indexPath.row]
        cell.setPlace(place: place)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
