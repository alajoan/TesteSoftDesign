//
//  CheckinViewController.swift
//  ProjSoftDesign
//
//  Created by Admin on 13/08/21.
//

import Foundation
import UIKit
import Alamofire
class CheckinViewController: UIViewController {
    
    var eventID: String?
    
    private lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .black
        name.text = "Nome"
        name.textAlignment = .center
        return name
    }()
    
    private lazy var emailLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .black
        name.text = "E-mail"
        name.textAlignment = .center
        return name
    }()
    
    private lazy var textFieldName: UITextField = {
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
    
    private lazy var textFieldEmail: UITextField = {
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
    
    private lazy var checkinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check-in", for: .normal)
        button.backgroundColor = .systemTeal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Check-in"
        self.view.backgroundColor = .white
        
        addViews()
        addConstraints()
        
        textFieldName.delegate = self
        textFieldEmail.delegate = self
    }
    
    func addViews(){
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(textFieldName)
        view.addSubview(textFieldEmail)
        view.addSubview(checkinButton)
    }
    
    func addConstraints(){
        constraintsNameLabel()
        constraintsTextfieldName()
        constraintsEmailLabel()
        constraintsTextfieldEmail()
        constraintsButton()
    }
    
    func constraintsNameLabel() {
        let constraint = [
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsTextfieldName() {
        let constraint = [
            textFieldName.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            textFieldName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldName.heightAnchor.constraint(equalToConstant: 40),
            textFieldName.widthAnchor.constraint(equalToConstant: 350)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsEmailLabel() {
        let constraint = [
            emailLabel.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 60),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.heightAnchor.constraint(equalToConstant: 30),
            emailLabel.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsTextfieldEmail() {
        let constraint = [
            textFieldEmail.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 0),
            textFieldEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 40),
            textFieldEmail.widthAnchor.constraint(equalToConstant: 350)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsButton() {
        let constraint = [
            checkinButton.heightAnchor.constraint(equalToConstant: 50),
            checkinButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            checkinButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            checkinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func  returnToBeginning() {
        let controller = ViewController()
        self.show(controller, sender: self)
    }
    
    @objc func buttonAction() {
        let parameters: [String: Any] = [
            "eventId" : eventID ?? "0",
            "name" : textFieldName.text ?? "",
            "email" : textFieldEmail.text ?? "",
        ]

        AF.request("http://5f5a8f24d44d640016169133.mockapi.io/api/checkin", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    let alert = UIAlertController(title: "O check-in foi feito com sucesso!", message: "Seu check-in no evento foi realizado com sucesso!", preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        self.returnToBeginning()
                    }))

                    self.present(alert, animated: true, completion: nil)
                    break
                case .failure( _):
                   
                            let alert = UIAlertController(title: "O check-in falhou", message: "Infelizmente houve uma falha no seu check-in pois o servidor está desabilitado", preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

                            self.present(alert, animated: true, completion: nil)
                }
            }
    }
}

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
