//
//  ViewController.swift
//  ProjSoftDesign
//
//  Created by Admin on 10/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    var events: [EventsRoot] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [self]
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Eventos"
        view.addSubview(tableView)
        
        DataFetcher.fetchEvents { (event) in
            self.events = event
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as? EventTableViewCell else {return EventTableViewCell()}
        if(events.capacity > 0) {
            if events[indexPath.row].people.count >= 0 {
                let title = events[indexPath.row].title
                cell.changeTitle(text: title)
            }
           
        }
          
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailViewController()
        controller.detailEvents = events[indexPath.row]
        self.show(controller, sender: self)
    }
    
}
