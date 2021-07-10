//
//  EventApproveal.swift
//  Spancirfest
//
//  Created by Dino Martan on 08/07/2021.
//

import UIKit

struct EventStatus {
    
    var text: String
    var color: UIColor
    
}

struct EventApproveal: Codable {
    
    let event: Event
    var approved: Bool
    var approvedBy: String?
    let creationDate: Date
    var approvedDate: Date?
    var comment: String?
    
    func getStatus() -> EventStatus {
        var eventStatus = EventStatus(text: "Default", color: .secondaryLabel)
        if self.approvedDate == nil {
            eventStatus.text = "Awaiting feedback"
            eventStatus.color = .systemYellow
        }
        else if self.approved {
            eventStatus.text = "Approved"
            eventStatus.color = .systemGreen
        }
        else if !self.approved {
            eventStatus.text = "Denied"
            eventStatus.color = .systemRed
        }
        return eventStatus
    }
    
}
