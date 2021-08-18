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
    
    var titulo: String {
        get {
            guard let title = detalhesEvento?.title else {return String()}
            return title
        }
    }
    
    func formatarData() -> String {
        guard let eventDate = detalhesEvento?.date else {return String()}
        let dataConvertida = Date.init(milliseconds: Int64(eventDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a 'em' dd MMM, yyyy"
        let todaysDate = dateFormatter.string(from: dataConvertida)
        return todaysDate
    }
    
    func coordenadasDoMapa() -> MKPointAnnotation {
        
        let annotation = MKPointAnnotation()
        
        guard let eventLatitude: Float = detalhesEvento?.latitude else {return MKPointAnnotation()}
        guard let eventLongitude: Float = detalhesEvento?.longitude else {return MKPointAnnotation()}
        
        var location = CLLocationCoordinate2D()
        location.latitude = CLLocationDegrees(eventLatitude)
        location.longitude = CLLocationDegrees(eventLongitude)
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        return annotation
    }
    
    func regiaoDoMapa() -> MKCoordinateRegion {
        let region = MKCoordinateRegion(center: coordenadasDoMapa().coordinate, latitudinalMeters: 600, longitudinalMeters: 500)
        return region
    }
}
