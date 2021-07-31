//
//  EventApproveal.swift
//  Spancirfest
//
//  Created by Dino Martan on 08/07/2021.
//

import UIKit

enum ApprovealStatus {
    
    case approved
    case denied
    case awaiting
    
}

struct EventStatus {
    
    var text: String
    var color: UIColor
    var status: ApprovealStatus
    
}

struct EventApproveal: Codable {
    
    let event: Event
    var approved: Bool
    var approvedBy: String?
    let creationDate: Date
    var approvedDate: Date?
    var comment: String?
    
    func getStatus() -> EventStatus {
        var eventStatus = EventStatus(text: "Default", color: .secondaryLabel, status: .awaiting)
        if self.approvedDate == nil {
            eventStatus.text = "Awaiting feedback"
            eventStatus.color = .systemYellow
            eventStatus.status = .awaiting
        }
        else if self.approved {
            eventStatus.text = "Approved"
            eventStatus.color = .systemGreen
            eventStatus.status = .approved
        }
        else if !self.approved {
            eventStatus.text = "Denied"
            eventStatus.color = .systemRed
            eventStatus.status = .denied
        }
        return eventStatus
    }
    
}
