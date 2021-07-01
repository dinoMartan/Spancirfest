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
    var location: Location
    let numberOfPeople: Int?
    let image: String?
    let eventId: String
    
    func equals(event: Event) -> Bool {
        if self.ownerId != event.ownerId { return false }
        if self.eventCategory.categoryId != event.eventCategory.categoryId { return false }
        if self.name != event.name { return false }
        if self.startDate != event.startDate { return false }
        if self.endDate != event.endDate { return false }
        if self.price != event.price { return false }
        if self.location.locationId != event.location.locationId { return false }
        if self.numberOfPeople != event.numberOfPeople { return false }
        if self.image != event.image { return false }
        if self.eventId != event.eventId { return false }
        else { return true }
    }
    
}
