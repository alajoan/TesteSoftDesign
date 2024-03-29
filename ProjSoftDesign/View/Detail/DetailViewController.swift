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
    lazy var contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200)
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentSize = contentSize
        scroll.frame = view.safeAreaLayoutGuide.layoutFrame
        return scroll
    } ()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = contentSize
        return view
    } ()
    
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(descricaoEvento)
        contentView.addSubview(imagemEvento)
        contentView.addSubview(mapaEvento)
        contentView.addSubview(dataEvento)
        contentView.addSubview(valorEvento)
        contentView.addSubview(botaoCheckin)
    }
    
    func adicionarConstraints(){
        constraintsScrollView()
        constraintsContentView()
        constraintsImagemEvento()
        constraintsDescricaoEvento()
        constraintsMapa()
        constraintsDataEvento()
        constraintsValorEvento()
        constraintsBotao()
    }
    // MARK: - Constraints
    
    func constraintsScrollView(){
        let constraint = [
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsContentView(){
        let constraint = [
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor,constant: 200),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
        
    func constraintsImagemEvento(){
        let constraint = [
            imagemEvento.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imagemEvento.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imagemEvento.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 1/4),
            imagemEvento.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 10)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsDescricaoEvento() {
        let constraint = [
            descricaoEvento.topAnchor.constraint(equalTo: imagemEvento.bottomAnchor, constant: 5),
            descricaoEvento.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descricaoEvento.bottomAnchor.constraint(equalTo: mapaEvento.topAnchor, constant: -10),
            descricaoEvento.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 1/3),
            descricaoEvento.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10 )
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsMapa() {
        let constraint = [
            mapaEvento.topAnchor.constraint(equalTo: descricaoEvento.bottomAnchor, constant: 5),
            mapaEvento.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            mapaEvento.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 1/4),
            mapaEvento.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10),
            mapaEvento.bottomAnchor.constraint(equalTo: dataEvento.topAnchor, constant: -20)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsDataEvento() {
        let constraint = [
            dataEvento.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            dataEvento.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            dataEvento.bottomAnchor.constraint(equalTo: valorEvento.topAnchor, constant: -10)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsValorEvento() {
        let constraint = [
            valorEvento.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            valorEvento.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsBotao() {
        let constraint = [
            botaoCheckin.heightAnchor.constraint(equalToConstant: 50),
            botaoCheckin.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            botaoCheckin.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            botaoCheckin.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
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
