//
//  NetworkServices.swift
//  ProjSoftDesign
//
//  Created by Admin on 17/08/21.
//

import Foundation
import RxSwift
import Alamofire

// MARK: - Teste conectividade
struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}

class NetworkServices {

    // MARK: - funcao pegar api tableview
    func execute<T: Decodable>() -> Observable<T> {
        return Observable.create { (observer) -> Disposable in
            
            let url = "https://5f5a8f24d44d640016169133.mockapi.io/api/events"
            
            let request = AF.request(url)
            
            request.responseDecodable(of: T.self) { (response) in
              guard let event = response.value else { return }
              observer.onNext(event)
              observer.onCompleted()
              
            }
            
            return Disposables.create {
                AF.cancelAllRequests()
            }
            
        }
        
    }
    
    // MARK: - Post funcao
    func post (idEvento: String, nome: String, email: String, vc: CheckinViewController){
        
        let parametros: [String: Any] = [
            "eventId" : idEvento,
            "name" : nome,
            "email" : email,
        ]
        
        AF.request("http://5f5a8f24d44d640016169133.mockapi.io/api/checkin", method: .post, parameters: parametros, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    let alert = UIAlertController(title: "O check-in foi feito com sucesso!", message: "Seu check-in no evento foi realizado com sucesso!", preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        
                        vc.retornarAoComeco()
                    }))

                    vc.present(alert, animated: true, completion: nil)
                    break
                case .failure( _):
                   
                            let alert = UIAlertController(title: "O check-in falhou", message: "Infelizmente houve uma falha no seu check-in pois o servidor está desabilitado", preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

                    vc.present(alert, animated: true, completion: nil)
                }
            }
    }
    
    
}
