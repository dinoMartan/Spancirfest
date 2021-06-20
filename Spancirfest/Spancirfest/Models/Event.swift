//
//  Event.swift
//  Spancirfest
//
//  Created by Dino Martan on 17/06/2021.
//

import Foundation

struct Event: Codable {
    
    let ownerId: String
    let eventCategory: EventCategory
    let name: String
    let startDate: Date
    let endDate: Date
    let price: Float?
    let locationId: String
    let numberOfPeople: Int?
    let image: String?
    
}
