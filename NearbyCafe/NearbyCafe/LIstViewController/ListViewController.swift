//
//  ListViewController.swift
//  NearbyCafe
//
//  Created by user on 10.08.2022.
//

import UIKit

class ListViewController: UIViewController {
    
    private let cellID = "ListTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List"
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ListTableViewCell
        
        let place = places[indexPath.row]
        cell.setPlace(place: place)
        
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
