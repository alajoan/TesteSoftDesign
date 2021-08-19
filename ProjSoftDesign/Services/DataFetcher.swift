//
//  DataFetcher.swift
//  ProjSoftDesign
//
//  Created by Admin on 10/08/21.
//

import Foundation
import Alamofire

class DataFetcher {
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


