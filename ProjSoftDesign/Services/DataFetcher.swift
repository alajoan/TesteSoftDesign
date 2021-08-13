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
                    
                    for n in 0...event.count - 1 {
                        if event[n].people.count > 0 {
                            events.append(event[n])
                        }
                    }
                    
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
    
    static func fetchImage(URL: String, completionHandler: @escaping(UIImage) -> Void) {
            
            var tempImage: UIImage = UIImage()
            
            _ = AF.request(URL, method: .get).response{ (response) in
                switch response.result {
                case .success(let responseData):
                    tempImage = UIImage(data: responseData!, scale: 1) ?? tempImage
                    completionHandler(tempImage)
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            
        }
}


