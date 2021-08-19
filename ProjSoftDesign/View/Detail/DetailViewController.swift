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
    
    var detalheViewModel: DetailViewModel?
    
    // MARK: - Criacao de ui
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
    
    private lazy var valorEvento: UILabel = {
        let evento = UILabel()
        guard let valor = detalheViewModel?.detalhesEvento?.price else {return UILabel()}
        evento.text = "Preço da entrada:  R$\(valor)"
        evento.adjustsFontSizeToFitWidth = true
        evento.translatesAutoresizingMaskIntoConstraints = false
        evento.textColor = .lightGray
        evento.textAlignment = .center
        return evento
    }()
    
    private lazy var dataEvento: UILabel = {
        let evento = UILabel()
        guard let dataEvento = detalheViewModel?.formatarData() else {return UILabel()}
        evento.text = "Data do evento: \(dataEvento)"
        evento.adjustsFontSizeToFitWidth = true
        evento.translatesAutoresizingMaskIntoConstraints = false
        evento.textColor = .lightGray
        evento.textAlignment = .center
        return evento
    }()
    
    private lazy var botaoCheckin: UIButton = {
        let botao = UIButton()
        botao.setTitle("Check-in", for: .normal)
        botao.backgroundColor = .systemTeal
        botao.translatesAutoresizingMaskIntoConstraints = false
        botao.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return botao
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let coordenadas = detalheViewModel?.coordenadasDoMapa() else {return}
        guard let regiao = detalheViewModel?.regiaoDoMapa() else {return}
        guard let titulo = detalheViewModel?.titulo else {return}
        
        self.title = "\(titulo)"
        
        view.backgroundColor = .white
        
        adicionarViews()
        adicionarConstraints()
        
        setImage()
        
        mapaEvento.addAnnotation(coordenadas)
        mapaEvento.setRegion(regiao, animated: true)
       
        descricaoEvento.contentOffset = .zero
        
    }
    // MARK: - Adicionar views e constraints
    func adicionarViews(){
        view.addSubview(descricaoEvento)
        view.addSubview(imagemEvento)
        view.addSubview(mapaEvento)
        view.addSubview(dataEvento)
        view.addSubview(valorEvento)
        view.addSubview(botaoCheckin)
    }
    
    func adicionarConstraints(){
        constraintsImagemEvento()
        constraintsDescricaoEvento()
        constraintsMapa()
        constraintsDataEvento()
        constraintsValorEvento()
        constraintsBotao()
    }
    // MARK: - Constraints
    func constraintsImagemEvento(){
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
    
    func constraintsDescricaoEvento() {
        let constraint = [
            descricaoEvento.topAnchor.constraint(equalTo: imagemEvento.bottomAnchor, constant: 20),
            descricaoEvento.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            descricaoEvento.bottomAnchor.constraint(equalTo: mapaEvento.topAnchor, constant: -10),
            descricaoEvento.heightAnchor.constraint(equalToConstant: 150),
            descricaoEvento.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20 )
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsMapa() {
        let constraint = [
            mapaEvento.topAnchor.constraint(equalTo: descricaoEvento.bottomAnchor, constant: 10),
            mapaEvento.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            mapaEvento.heightAnchor.constraint(equalToConstant: 150),
            mapaEvento.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant:  -20),
            mapaEvento.bottomAnchor.constraint(equalTo: dataEvento.topAnchor, constant: -20)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsDataEvento() {
        let constraint = [
            dataEvento.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            dataEvento.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            dataEvento.bottomAnchor.constraint(equalTo: valorEvento.topAnchor, constant: -10)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsValorEvento() {
        let constraint = [
            valorEvento.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            valorEvento.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsBotao() {
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
    
    // MARK: - Metodos botao e imagem
    @objc func buttonAction() {
        let controller = CheckinViewController()
        let viewModel = CheckinViewModel()
        
        guard let idEvento = detalheViewModel?.detalhesEvento?.people[0].eventId else {return}
        controller.idEvento = idEvento
        controller.checkinViewModel = viewModel
        self.show(controller, sender: self)
    }
    
    
    func setImage() {
        guard let imageURL = detalheViewModel?.detalhesEvento?.image else {return}
        DataFetcher.fetchImage(URL: imageURL) { (images) in
            self.imagemEvento.image = images
        }
    }
    
}
