//
//  Utils.swift
//  ProjSoftDesign
//
//  Created by Admin on 11/08/21.
//

import Foundation
import UIKit


extension Date {
    var milisegundosDesde1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milissegundos:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milissegundos) * 1000 / 1000)
    }
    
    
}
