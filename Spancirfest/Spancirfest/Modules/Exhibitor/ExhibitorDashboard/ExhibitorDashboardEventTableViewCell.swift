//
//  ExhibitorDashboardEventTableViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 17/06/2021.
//

import UIKit

class ExhibitorDashboardEventTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!

    //MARK: - Public properties
    
    static let identifier = "ExhibitorDashboardEventTableViewCell"
    
    //MARK: - Public methods
    
    func configureCell(event: Event) {
        nameLabel.text = event.name
        locationLabel.text = event.locationId
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        startDateLabel.text = formatter.string(from: event.startDate)
        endDateLabel.text = formatter.string(from: event.endDate)
    }
    
}
