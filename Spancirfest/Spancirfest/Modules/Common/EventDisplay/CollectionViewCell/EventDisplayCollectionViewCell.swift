//
//  HomeCollectionViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 22/06/2021.
//

import UIKit
import SDWebImage

class EventDisplayCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var eventNameLabel: UILabel!
    
    //MARK: - Public properties
    
    static let identifier = "EventDisplayCollectionViewCell"
    
    //MARK: - Public methods
    
    func configureCell(event: Event) {
        if let image = event.image { imageView.sd_setImage(with: URL(string: image), completed: nil) }
        imageView.layer.cornerRadius = imageView.frame.height / 2
        eventNameLabel.text = event.name
    }

}
