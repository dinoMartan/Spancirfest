//
//  AdminDashboardLocationCollectionViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 30/06/2021.
//

import UIKit

class AdminDashboardLocationCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var locationTitleLabel: UILabel!
    @IBOutlet private weak var locationDescriptionLabel: UILabel!
    
    //MARK: - Public properties
    
    static let identifier = "AdminDashboardLocationCollectionViewCell"
    
    //MARK: - Public methods
    
    func configureCell(location: Location) {
        locationTitleLabel.text = location.name
        locationDescriptionLabel.text = location.description
    }

}
