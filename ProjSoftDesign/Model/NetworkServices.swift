//
//  NetworkServices.swift
//  ProjSoftDesign
//
//  Created by Admin on 17/08/21.
//

import Foundation
import RxSwift
import Alamofire

class NetworkServices {
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
}
