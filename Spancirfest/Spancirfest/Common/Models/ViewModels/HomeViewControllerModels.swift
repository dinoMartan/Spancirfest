//
//  HomeViewControllerModels.swift
//  Spancirfest
//
//  Created by Dino Martan on 12/07/2021.
//

import Foundation

enum EventSortType {
    
    case date(date: EventsByDate)
    case category(data: EventsByCategory)
    case location(data: EventsByLocation)
    case profile(data: ProfileViewControllerTableData)
    
}

struct EventsByDate {
    
    let date: Date
    var events: [Event]
    
}

struct ProfileViewControllerTableData {
    
    let title: String
    let events: [Event]
    
}

struct EventsByCategory {
    
    let category: EventCategory
    var events: [Event]
    
}

struct EventsByLocation {
    
    let location: Location
    var events: [Event]
    
}
