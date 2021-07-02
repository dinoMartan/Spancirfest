//
//  Location.swift
//  Spancirfest
//
//  Created by Dino Martan on 17/06/2021.
//

import Foundation

struct Location: Codable {
    
    let locationId: String
    let name: String
    let description: String
    let longitude: Double
    let latitude: Double
    var image: String?
    
}
