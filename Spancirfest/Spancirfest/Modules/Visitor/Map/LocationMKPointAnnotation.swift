//
//  EventMapPin.swift
//  Spancirfest
//
//  Created by Dino Martan on 27/06/2021.
//

import MapKit
import Foundation

class LocationMKPointAnnotation: MKPointAnnotation {
    
    private let location: Location
    
    init(location: Location) {
        self.location = location
        super.init()
        self.title = location.name
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    func getLocation() -> Location {
        return location
    }
    
}
