//
//  DatabaseFieldNameConstants.swift
//  Spancirfest
//
//  Created by Dino Martan on 18/06/2021.
//

import Foundation

enum DatabaseFieldNameConstants: String {
    
    case ownerId = "ownerId"
    case eventCategory = "categoryId"
    case eventId = "eventId"
    case userId = "userId"
    case eventLocationId = "location.locationId"
    case eventCategoryId = "eventCategory.categoryId"
    case eventPaidUsersArray = "paidUsers"
    case approved = "approved"
    case eventOwnerId = "event.ownerId"
    
}
