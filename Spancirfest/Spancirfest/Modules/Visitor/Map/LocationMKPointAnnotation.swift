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
    }
    
    func getLocation() -> Location {
        return location
    }
    
}
