//
//  DetailViewController.swift
//  ProjSoftDesign
//
//  Created by Admin on 12/08/21.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController {
    var detailEvents: EventsRoot?
    
    private lazy var eventDescription: UITextView = {
        let event = UITextView()
        guard let eventDescription = detailEvents?.description else {return UITextView()}
        event.text = eventDescription
        event.translatesAutoresizingMaskIntoConstraints = false
        event.textColor = .lightGray
        //event.numberOfLines = 0
        return event
    }()
    
    private lazy var eventImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var eventMap: MKMapView = {
        let map = MKMapView()
        map.mapType = MKMapType.standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    private lazy var eventDate: UILabel = {
        let event = UILabel()
        guard let eventDate = detailEvents?.date else {return UILabel()}
        let dateConverted = Date.init(milliseconds: Int64(eventDate))
        
        let date = dateConverted
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a 'em' dd MMM, yyyy"
        let todaysDate = dateFormatter.string(from: date)
        event.text = "Data do evento: \(todaysDate)"
        event.adjustsFontSizeToFitWidth = true
        event.translatesAutoresizingMaskIntoConstraints = false
        event.textColor = .lightGray
        event.textAlignment = .center
        return event
    }()
    
    private lazy var checkinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check-in", for: .normal)
        button.backgroundColor = .systemTeal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let titleName = detailEvents?.title else {return}
        self.title = "\(titleName)"
        view.backgroundColor = .white
        
        addViews()
        addConstraints()
        
        setImage()
        
        let range = NSMakeRange(eventDescription.text?.count ?? 0 - 1, 0)
        eventDescription.scrollRangeToVisible(range)
        
        setMapCoordinates()
    }
    
    func addViews(){
        view.addSubview(eventDescription)
        view.addSubview(eventImage)
        view.addSubview(eventMap)
        view.addSubview(eventDate)
        view.addSubview(checkinButton)
    }
    
    func addConstraints(){
        constraintsEventImage()
        constraintsDescription()
        constraintsMap()
        constraintsDate()
        constraintsButton()
    }
    
    func constraintsEventImage(){
        let constraint = [
            eventImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            eventImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventImage.heightAnchor.constraint(equalToConstant: 150),
            eventImage.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsDescription() {
        let constraint = [
            eventDescription.topAnchor.constraint(equalTo: eventImage.bottomAnchor, constant: 10),
            eventDescription.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            eventDescription.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            eventDescription.bottomAnchor.constraint(equalTo: eventMap.topAnchor, constant: -10),
            eventDescription.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsMap() {
        let constraint = [
            eventMap.topAnchor.constraint(equalTo: eventDescription.bottomAnchor),
           // eventMap.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            eventMap.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            eventMap.heightAnchor.constraint(equalToConstant: 150),
            eventMap.widthAnchor.constraint(equalToConstant: 400),
            eventMap.bottomAnchor.constraint(equalTo: eventDate.topAnchor, constant: -20)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsDate() {
        let constraint = [
            eventDate.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            eventDate.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    func constraintsButton() {
        let constraint = [
            checkinButton.heightAnchor.constraint(equalToConstant: 50),
            checkinButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            checkinButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            checkinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    @objc func buttonAction() {
        let controller = CheckinViewController()
        controller.eventID = detailEvents?.people[0].eventId
        self.show(controller, sender: self)
    }
    
    
    func setImage() {
        guard let imageURL = detailEvents?.image else {return}
        DataFetcher.fetchImage(URL: imageURL) { (images) in
            self.eventImage.image = images
        }
    }
    
    func setMapCoordinates() {
        
        let annotation = MKPointAnnotation()
        
        guard let eventLatitude: Float = detailEvents?.latitude else {return}
        guard let eventLongitude: Float = detailEvents?.longitude else {return}
        
        var location = CLLocationCoordinate2D()
        location.latitude = CLLocationDegrees(eventLatitude)
        location.longitude = CLLocationDegrees(eventLongitude)
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        eventMap.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 600, longitudinalMeters: 500)
        eventMap.setRegion(region, animated: true)
        
    }
}
