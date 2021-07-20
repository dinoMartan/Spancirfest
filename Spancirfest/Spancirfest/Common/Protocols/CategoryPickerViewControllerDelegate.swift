//
//  CategoryPickerViewControllerDelegate.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/07/2021.
//

import Foundation

protocol CategoryPickerViewControllerDelegate: AnyObject {
    
    func didSetCategory(eventCategory: EventCategory)
    
}
