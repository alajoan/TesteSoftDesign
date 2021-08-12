//
//  Events.swift
//  ProjSoftDesign
//
//  Created by Admin on 10/08/21.
//

import Foundation

struct EventsRoot: Decodable {
    var people = [EventsPeople]()
    var date = Double()
    var description = String()
    var image = String()
    var longitude = Float()
    var latitude = Float()
    var price = Float()
    var title = String()
    var id = String()
}

struct EventsPeople: Decodable {
    var id = String()
    var eventId = String()
    var name = String()
    var picture = String()
}
