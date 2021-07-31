//
//  LocationPickerViewControllerDelegate.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/07/2021.
//

import Foundation

protocol LocationPickerViewControllerDelegate: AnyObject {
    
    func didSetLocation(location: Location)
    
}
