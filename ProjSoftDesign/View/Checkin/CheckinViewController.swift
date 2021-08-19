//
//  CheckinViewController.swift
//  ProjSoftDesign
//
//  Created by Admin on 13/08/21.
//

import Foundation
import UIKit
import Alamofire
import RxSwift

class CheckinViewController: UIViewController {
    
    // MARK: - Variaveis
    var idEvento: String?
    
    var checkinViewModel: CheckinViewModel?
    
    let disposeBag = DisposeBag()
    
    var networkService = NetworkServices()
    
    // MARK: - criacao de UI
    private lazy var labelNome: UILabel = {
        let nome = UILabel()
        nome.translatesAutoresizingMaskIntoConstraints = false
        nome.textColor = .black
        nome.text = "Nome"
        nome.textAlignment = .left
        return nome
    }()
    
    private lazy var labelEmail: UILabel = {
        let nome = UILabel()
        nome.translatesAutoresizingMaskIntoConstraints = false
        nome.textColor = .black
        nome.text = "E-mail"
        nome.textAlignment = .left
        return nome
    }()
    
    private lazy var nomeErrorLabel: UILabel = {
        let nome = UILabel()
        nome.translatesAutoresizingMaskIntoConstraints = false
        nome.textColor = .systemRed
        nome.text = "Nome precisa ter ao menos 2 letras"
        nome.font = nome.font.withSize(10)
        nome.textAlignment = .right
        return nome
    }()
    
    private lazy var emailErrorLabel: UILabel = {
        let nome = UILabel()
        nome.translatesAutoresizingMaskIntoConstraints = false
        nome.textColor = .systemRed
        nome.text = "E-mail precisa seguir o padrão exemplo@servidor.com"
        nome.textAlignment = .right
        nome.font = nome.font.withSize(10)
        return nome
    }()
    
    public lazy var textfieldName: UITextField = {
       let textfield = UITextField()
        textfield.placeholder = "Digite seu nome"
        textfield.font = UIFont.systemFont(ofSize: 15)
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = UIReturnKeyType.done
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    public lazy var textfieldEmail: UITextField = {
       let textfield = UITextField()
        textfield.placeholder = "Digite seu email"
        textfield.font = UIFont.systemFont(ofSize: 15)
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = UIReturnKeyType.done
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var botaoCheckin: UIButton = {
        let botao = UIButton()
        botao.setTitle("Check-in", for: .normal)
        botao.backgroundColor = .systemTeal
        botao.translatesAutoresizingMaskIntoConstraints = false
        botao.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return botao
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        guard let titulo = checkinViewModel?.titulo else {return}
        self.title = titulo
        self.view.backgroundColor = .white
        
        adicionarViews()
        adicionarConstraints()
        
        textfieldName.delegate = self
        textfieldEmail.delegate = self
        
        textfieldName.becomeFirstResponder()
        
        guard let nome = checkinViewModel?.nomePublishSubject else {return}
        guard let email = checkinViewModel?.emailPublishSubject else {return}
        
        textfieldName.rx.text.map { $0 ?? "" }.bind(to: nome).disposed(by: disposeBag)
        textfieldEmail.rx.text.map { $0 ?? "" }.bind(to: email).disposed(by: disposeBag)
        
        checkinViewModel?.ativarBotao().bind(to: botaoCheckin.rx.isUserInteractionEnabled).disposed(by: disposeBag)
        
        checkinViewModel?.ativarBotao().map { $0 ? 1 : 0.3 }.bind(to: botaoCheckin.rx.alpha).disposed(by: disposeBag)
        
        checkinViewModel?.ativarErroNome().map { $0 ? 1 : 0}.bind(to: nomeErrorLabel.rx.alpha)
            .disposed(by: disposeBag)
        
        checkinViewModel?.ativarErroEmail().map { $0 ? 1 : 0}.bind(to: emailErrorLabel.rx.alpha)
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Adicionar views e constraints
    func adicionarViews(){
        view.addSubview(labelNome)
        view.addSubview(labelEmail)
        view.addSubview(textfieldName)
        view.addSubview(textfieldEmail)
        view.addSubview(botaoCheckin)
        view.addSubview(nomeErrorLabel)
        view.addSubview(emailErrorLabel)
    }
    
    func adicionarConstraints(){
        constraintsNameErrorLabel()
        constraintsNameLabel()
        constraintsTextfieldName()
        constraintsEmailErrorLabel()
        constraintsEmailLabel()
        constraintsTextfieldEmail()
        constraintsBotao()
    }
    
    // MARK: - Constraints
    func constraintsNameLabel() {
        let constraint = [
            labelNome.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            labelNome.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40),
            labelNome.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsNameErrorLabel() {
        let constraint = [
            nomeErrorLabel.centerYAnchor.constraint(equalTo: labelNome.centerYAnchor),
            nomeErrorLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsTextfieldName() {
        let constraint = [
            textfieldName.topAnchor.constraint(equalTo: labelNome.bottomAnchor, constant: 5),
            textfieldName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textfieldName.heightAnchor.constraint(equalToConstant: 40),
            textfieldName.widthAnchor.constraint(equalToConstant: 350)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsEmailLabel() {
        let constraint = [
            labelEmail.topAnchor.constraint(equalTo: textfieldName.bottomAnchor, constant: 20),
            labelEmail.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40),
            labelEmail.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsEmailErrorLabel() {
        let constraint = [
            emailErrorLabel.centerYAnchor.constraint(equalTo: labelEmail.centerYAnchor),
            emailErrorLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsTextfieldEmail() {
        let constraint = [
            textfieldEmail.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 5),
            textfieldEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textfieldEmail.heightAnchor.constraint(equalToConstant: 40),
            textfieldEmail.widthAnchor.constraint(equalToConstant: 350)
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
    
    // MARK: - Acoes do botao
    func  retornarAoComeco() {
        let controller = ViewController()
        self.show(controller, sender: self)
    }
    
    @objc func buttonAction() {
        guard let id = idEvento else {return}
        guard let nome = labelNome.text else {return}
        guard let email = labelEmail.text else {return}
        
        if(Connectivity.isConnectedToInternet){
            networkService.post(idEvento: id, nome: nome, email: email, vc: self)
        } else {
            
            print("Sem net")
            let alert = UIAlertController(title: "Celular sem internet", message: "O celular não está conectado à internet!", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:nil))
            
            self.present(alert, animated: true, completion: nil)
        }
         
    }
}

// MARK: - Delegate
extension CheckinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(true)
            return true
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if(textField.text != "") {
                return true
            } else {
                textField.placeholder = "Enter your name"
                return false
            }
        }
}
