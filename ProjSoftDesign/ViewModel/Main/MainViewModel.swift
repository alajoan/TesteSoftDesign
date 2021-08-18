//
//  MainViewModel.swift
//  ProjSoftDesign
//
//  Created by Admin on 17/08/21.
//

import Foundation
import RxSwift
class MainViewModel {
    
     var titulo: String {get { return "Eventos" }}
    
    private let chamada = NetworkServices()
    
    func pegarChamada() -> Observable<[EventsRoot]> {
        return chamada.execute()
    }
}
