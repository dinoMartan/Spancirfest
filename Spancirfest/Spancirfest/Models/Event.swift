//
//  Event.swift
//  Spancirfest
//
//  Created by Dino Martan on 17/06/2021.
//

import Foundation

struct Event: Codable {
    
    let ownerId: String
    var eventCategory: EventCategory
    let name: String
    let startDate: Date
    let endDate: Date
    let price: Float?
    var location: Location
    let numberOfPeople: Int?
    let image: String?
    let eventId: String
    var paidUsers: [String]?
    
    func equals(event: Event) -> Bool {
        if
            self.ownerId != event.ownerId ||
            self.eventCategory.categoryId != event.eventCategory.categoryId ||
            self.name != event.name ||
            self.startDate != event.startDate ||
            self.endDate != event.endDate ||
            self.price != event.price ||
            self.location.locationId != event.location.locationId ||
            self.numberOfPeople != event.numberOfPeople ||
            self.image != event.image ||
            self.eventId != event.eventId ||
            self.paidUsers != event.paidUsers
        { return false }
        else { return true }
    }
    
    func isPaidUser(idUser: String) -> Bool {
        guard let paidUsers = self.paidUsers else { return false }
        for user in paidUsers {
            if user == idUser { return true }
        }
        return false
    }
    
}
