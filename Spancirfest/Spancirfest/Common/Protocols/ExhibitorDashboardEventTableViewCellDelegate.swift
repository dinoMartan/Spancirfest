//
//  ExhibitorDashboardEventTableViewCellDelegate.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/07/2021.
//

import Foundation

protocol ExhibitorDashboardEventTableViewCellDelegate: AnyObject {
    
    func didTapScanButton(event: Event)
    
}
