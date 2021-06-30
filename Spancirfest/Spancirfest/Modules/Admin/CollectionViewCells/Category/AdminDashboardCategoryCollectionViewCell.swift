//
//  AdminDashboardCategoryCollectionViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 30/06/2021.
//

import UIKit

class AdminDashboardCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet private weak var categoryTitleLabel: UILabel!
    
    //MARK: - Public properties
    
    static let identifier = "AdminDashboardCategoryCollectionViewCell"
    
    //MARK: - Public methods
    
    func configureCell(eventCategory: EventCategory) {
        categoryTitleLabel.text = eventCategory.description
    }

}
