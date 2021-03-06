//
//  AdminDashboardLocationCollectionViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 30/06/2021.
//

import UIKit
import SDWebImage

class AdminDashboardLocationCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var background: UIView!
    @IBOutlet private weak var locationTitleLabel: UILabel!
    @IBOutlet private weak var locationImageView: UIImageView!
    @IBOutlet private weak var darkenView: UIView!
    
    //MARK: - Public properties
    
    static let identifier = "AdminDashboardLocationCollectionViewCell"
    
    //MARK: - Public methods
    
    func configureCell(location: Location) {
        layer.cornerRadius = frame.height / 2
        darkenView.layer.opacity = 0.5
        locationTitleLabel.text = location.name
        guard let image = location.image else { return }
        locationImageView.sd_setImage(with: URL(string: image), completed: nil)
    }

}
