//
//  MyApprovealsTableViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 10/07/2021.
//

import UIKit
import SDWebImage

class MyApprovealsTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var eventNameLabel: UILabel!
    @IBOutlet private weak var eventStatusLabel: UILabel!

    //MARK: - Public properties
    
    static let identifier = "MyApprovealsTableViewCell"
    
    //MARK: - Public methods
    
    func configureCell(eventApproveal: EventApproveal) {
        eventNameLabel.text = eventApproveal.event.name
        let eventStatus = eventApproveal.getStatus()
        eventStatusLabel.text = eventStatus.text
        eventStatusLabel.textColor = eventStatus.color
        guard let image = eventApproveal.event.image else { return }
        eventImage.sd_setImage(with: URL(string: image), completed: nil)
        eventImage.layer.cornerRadius = eventImage.frame.height / 2
    }
    
}
