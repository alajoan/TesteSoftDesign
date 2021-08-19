//
//  DetailViewModel.swift
//  ProjSoftDesign
//
//  Created by Admin on 17/08/21.
//

import Foundation
import MapKit

class DetailViewModel {
    
    var detalhesEvento: EventsRoot?
    
    // MARK: - Formatar data e titulo
    var titulo: String {
        get {
            guard let title = detalhesEvento?.title else {return String()}
            return title
        }
    }
    
    func formatarData() -> String {
        guard let diaEvento = detalhesEvento?.date else {return String()}
        let dataConvertida = Date.init(milissegundos: Int64(diaEvento))
        let formatadorData = DateFormatter()
        formatadorData.locale = Locale(identifier: "pt-BR")
        formatadorData.timeZone = .current
        formatadorData.dateFormat = "hh:mm a 'em' dd 'de' MMMM 'de' yyyy"
        let dataAtual = formatadorData.string(from: dataConvertida)
        return dataAtual
    }
    
    // MARK: - Métodos de anotacao no mapa
    func coordenadasDoMapa() -> MKPointAnnotation {
        
        let anotacao = MKPointAnnotation()
        
        guard let latitudeEvento: Float = detalhesEvento?.latitude else {return MKPointAnnotation()}
        guard let longitudeEvento: Float = detalhesEvento?.longitude else {return MKPointAnnotation()}
        
        var local = CLLocationCoordinate2D()
        local.latitude = CLLocationDegrees(latitudeEvento)
        local.longitude = CLLocationDegrees(longitudeEvento)
        
        anotacao.coordinate = CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude)
        
        return anotacao
    }
    
    
    func regiaoDoMapa() -> MKCoordinateRegion {
        let regiao = MKCoordinateRegion(center: coordenadasDoMapa().coordinate, latitudinalMeters: 600, longitudinalMeters: 500)
        return regiao
    }
}
