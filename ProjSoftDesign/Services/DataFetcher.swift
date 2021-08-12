//
//  DataFetcher.swift
//  ProjSoftDesign
//
//  Created by Admin on 10/08/21.
//

import Foundation
import Alamofire

class DataFetcher {
    static func fetchEvents(completionHandler: @escaping([EventsRoot]) -> Void){
           
           var events: [EventsRoot] = []
           
           let url = "https://5f5a8f24d44d640016169133.mockapi.io/api/events"
           
           let request = AF.request(url)
           
           request.responseJSON { (response) in
               
               switch response.result {
               
               case .success:
                   do {
                       events.removeAll()
                       let event = try JSONDecoder().decode([EventsRoot].self, from: response.data!)
                    events.append(contentsOf: event)
                       completionHandler(events)
                    print("Events:  \(events)")
                       
                   } catch DecodingError.keyNotFound(let key, let context) {
                       Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                   } catch DecodingError.valueNotFound(let type, let context) {
                       Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                   } catch DecodingError.typeMismatch(let type, let context) {
                       Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                   } catch DecodingError.dataCorrupted(let context) {
                       Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                   } catch let error as NSError {
                       NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                   }
                   break
                   
               case .failure(let error):
                   print("Deu erro: \(error.localizedDescription) \(String(describing: error.failedStringEncoding))")
               break
               }
               
           }
       }
}


