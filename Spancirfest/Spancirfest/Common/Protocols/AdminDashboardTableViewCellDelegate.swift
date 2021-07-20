//
//  AdminDashboardTableViewCellDelegate.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/07/2021.
//

import Foundation

protocol AdminDashboardTableViewCellDelegate: AnyObject {
    
    func didTapAddNewLocationButton()
    func didTapAddNewCategoryButton()
    func didTapShowLocationDetails(location: Location)
    func didTapShowCategoryDetails(category: EventCategory)
    func didTapShowEventApprovealDetails(eventApproveal: EventApproveal)
    
}
