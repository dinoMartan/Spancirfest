//
//  DatePickerViewControllerDelegate.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/07/2021.
//

import Foundation

protocol DatePickerViewControllerDelegate: AnyObject {
    
    func didSetDate(eventDate: EventDate)
    
}
