//
//  DetailViewController.swift
//  ProjSoftDesign
//
//  Created by Admin on 12/08/21.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    //var detalhesEvento: EventsRoot?
    var detalheViewModel: DetailViewModel?
    
    private lazy var descricaoEvento: UITextView = {
        let evento = UITextView()
        guard let descricaoEventos = detalheViewModel?.detalhesEvento else {return UITextView()}
        evento.text = descricaoEventos.description
        evento.translatesAutoresizingMaskIntoConstraints = false
        evento.textColor = .lightGray
        return evento
    }()
    
    private lazy var imagemEvento: UIImageView = {
        let imagem = UIImageView()
        imagem.translatesAutoresizingMaskIntoConstraints = false
        return imagem
    }()
    
    private lazy var mapaEvento: MKMapView = {
        let mapa = MKMapView()
        mapa.mapType = MKMapType.standard
        mapa.isZoomEnabled = true
        mapa.isScrollEnabled = true
        mapa.translatesAutoresizingMaskIntoConstraints = false
        
        return mapa
    }()
    
    private lazy var dataEvento: UILabel = {
        let evento = UILabel()
        evento.text = "Data do evento: \(detalheViewModel?.formatarData())"
        evento.adjustsFontSizeToFitWidth = true
        evento.translatesAutoresizingMaskIntoConstraints = false
        evento.textColor = .lightGray
        evento.textAlignment = .center
        return evento
    }()
    
    private lazy var botaoCheckin: UIButton = {
        let button = UIButton()
        button.setTitle("Check-in", for: .normal)
        button.backgroundColor = .systemTeal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(detalheViewModel?.titulo)"
        
        view.backgroundColor = .white
        
        addViews()
        addConstraints()
        
        setImage()
        
        mapaEvento.addAnnotation(detalheViewModel?.coordenadasDoMapa() as! MKAnnotation)
        mapaEvento.setRegion(detalheViewModel?.regiaoDoMapa() ?? MKCoordinateRegion(), animated: true)
        
        let range = NSMakeRange(descricaoEvento.text?.count ?? 0 - 1, 0)
        descricaoEvento.scrollRangeToVisible(range)
        
    }
    
    func addViews(){
        view.addSubview(descricaoEvento)
        view.addSubview(imagemEvento)
        view.addSubview(mapaEvento)
        view.addSubview(dataEvento)
        view.addSubview(botaoCheckin)
    }
    
    func addConstraints(){
        constraintsEventImage()
        constraintsDescription()
        constraintsMap()
        constraintsDate()
        constraintsButton()
    }
    
    func constraintsEventImage(){
        let constraint = [
            imagemEvento.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imagemEvento.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagemEvento.heightAnchor.constraint(equalToConstant: 150),
            imagemEvento.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsDescription() {
        let constraint = [
            descricaoEvento.topAnchor.constraint(equalTo: imagemEvento.bottomAnchor, constant: 10),
            descricaoEvento.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            descricaoEvento.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            descricaoEvento.bottomAnchor.constraint(equalTo: mapaEvento.topAnchor, constant: -10),
            descricaoEvento.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsMap() {
        let constraint = [
            mapaEvento.topAnchor.constraint(equalTo: descricaoEvento.bottomAnchor),
            mapaEvento.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            mapaEvento.heightAnchor.constraint(equalToConstant: 150),
            mapaEvento.widthAnchor.constraint(equalToConstant: 400),
            mapaEvento.bottomAnchor.constraint(equalTo: dataEvento.topAnchor, constant: -20)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsDate() {
        let constraint = [
            dataEvento.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            dataEvento.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsButton() {
        let constraint = [
            botaoCheckin.heightAnchor.constraint(equalToConstant: 50),
            botaoCheckin.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            botaoCheckin.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            botaoCheckin.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    @objc func buttonAction() {
        let controller = CheckinViewController()
        controller.eventID = detalheViewModel?.detalhesEvento?.people[0].eventId
        self.show(controller, sender: self)
    }
    
    
    func setImage() {
        guard let imageURL = detalheViewModel?.detalhesEvento?.image else {return}
        DataFetcher.fetchImage(URL: imageURL) { (images) in
            self.imagemEvento.image = images
        }
    }
    
}
