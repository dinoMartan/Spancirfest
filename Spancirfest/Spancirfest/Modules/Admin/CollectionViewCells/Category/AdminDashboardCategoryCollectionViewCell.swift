//
//  AdminDashboardCategoryCollectionViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 30/06/2021.
//

import UIKit
import SDWebImage

class AdminDashboardCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet private weak var darkenView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    
    //MARK: - Public properties
    
    static let identifier = "AdminDashboardCategoryCollectionViewCell"
    
    //MARK: - Public methods
    
    func configureCell(eventCategory: EventCategory) {
        layer.cornerRadius = frame.height / 2
        categoryTitleLabel.text = eventCategory.description
        darkenView.layer.opacity = 0.5
        guard let image = eventCategory.image else { return }
        imageView.sd_setImage(with: URL(string: image), completed: nil)
    }

}
