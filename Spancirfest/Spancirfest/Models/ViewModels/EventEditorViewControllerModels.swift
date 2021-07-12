//
//  EventEditorModels.swift
//  Spancirfest
//
//  Created by Dino Martan on 12/07/2021.
//

import Foundation

enum EventDateType {
    
    case startDate
    case endDate
    
}

struct EventDate {
    
    let type: EventDateType
    let date: Date
    
}
