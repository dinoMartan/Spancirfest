//
//  EventDisplayTableViewCellDelegate.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/07/2021.
//

import Foundation

protocol EventDisplayTableViewCellDelegate: AnyObject {
    
    func presentEvent(event: Event)
    
}
