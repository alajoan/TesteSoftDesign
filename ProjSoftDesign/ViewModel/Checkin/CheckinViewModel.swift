//
//  CheckinViewModel.swift
//  ProjSoftDesign
//
//  Created by Admin on 18/08/21.
//

import Foundation
import RxSwift

class CheckinViewModel {
    
    // MARK: - Variaveis
    var titulo: String {get { return "Check-in" }}
    
    var checkinViewController: CheckinViewController?
    
    let nomePublishSubject = PublishSubject<String>()
    let emailPublishSubject = PublishSubject<String>()
    
    // MARK: - Controle de estado
    func ativarBotao() -> Observable<Bool>{
        return Observable.combineLatest(nomePublishSubject.asObservable(),
                                        emailPublishSubject.asObservable()).map { nome, email in
                                            return nome.count >= 2 && email.contains("@") && email.contains(".com")
                                        }.startWith(false)
        
    }
    func ativarErroNome() -> Observable<Bool>{
        return Observable.combineLatest(nomePublishSubject.asObservable(),
                                        emailPublishSubject.asObservable()).map { nome, email in
                                            return nome.count <= 2
                                        }.startWith(false)
        
    }
    func ativarErroEmail() -> Observable<Bool>{
        return Observable.combineLatest(nomePublishSubject.asObservable(),
                                        emailPublishSubject.asObservable()).map { nome, email in
                                            return !email.contains("@") || !email.contains(".com")
                                        }.startWith(false)
        
    }
}
