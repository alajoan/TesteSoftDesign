//
//  ViewController.swift
//  ProjSoftDesign
//
//  Created by Admin on 10/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - Parte visual
    private let mainViewModel = MainViewModel()
    private let bag = DisposeBag()
    
    private var eventos: [EventsRoot] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.viewControllers = [self]
        
        tableView.backgroundColor = .white
        
        self.title = mainViewModel.titulo
        
        view.addSubview(tableView)
        
        chamadaTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
}

// MARK: - Tableview delegates e métodos relacionados
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as? EventTableViewCell else {return EventTableViewCell()}
        
        return cell
    }
    
    func chamadaTableView() {
        mainViewModel.pegarChamada().bind(to: tableView.rx.items(cellIdentifier: EventTableViewCell.identifier, cellType: EventTableViewCell.self)) {(row,item,cell) in
            if(row == 4) {
                cell.isHidden = true
            }
            cell.changeTitle(text: item.title)
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(EventsRoot.self).subscribe(onNext: { item in
            let controller = DetailViewController()
            let viewModel = DetailViewModel()
            viewModel.detalhesEvento = item
            controller.detalheViewModel = viewModel
            self.show(controller, sender: self)
                }).disposed(by: bag)
    }
    
}
