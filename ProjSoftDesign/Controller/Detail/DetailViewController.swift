//
//  DetailViewController.swift
//  ProjSoftDesign
//
//  Created by Admin on 12/08/21.
//

import Foundation
import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let titleName = detailEvents?.title else {return}
        self.title = "\(titleName)"
        view.backgroundColor = .white
        
        addViews()
       
        constraintsEventImage()
        constraintsDescription()
        
        setImage()
        
        let range = NSMakeRange(eventDescription.text?.count ?? 0 - 1, 0)
        eventDescription.scrollRangeToVisible(range)
    }
    
    func addViews(){
        view.addSubview(eventDescription)
        view.addSubview(eventImage)
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
            eventDescription.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            eventDescription.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            eventDescription.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ]
        
        constraint.forEach { (item) in
            item.isActive = true
        }
    }
    
    
    func setImage() {
        guard let imageURL = detailEvents?.image else {return}
        DataFetcher.fetchImage(URL: imageURL) { (images) in
            self.eventImage.image = images
        }
    }
}
