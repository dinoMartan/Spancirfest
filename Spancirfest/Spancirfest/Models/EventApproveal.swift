//
//  EventApproveal.swift
//  Spancirfest
//
//  Created by Dino Martan on 08/07/2021.
//

import Foundation

struct EventApproveal: Codable {
    
    let event: Event
    var approved: Bool
    var approvedBy: String?
    let creationDate: Date
    var approvedDate: Date?
    var comment: String?
    
}
