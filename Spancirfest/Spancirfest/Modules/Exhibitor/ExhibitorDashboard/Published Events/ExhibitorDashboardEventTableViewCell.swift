//
//  ExhibitorDashboardEventTableViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 17/06/2021.
//

import UIKit
import SDWebImage

class ExhibitorDashboardEventTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!

    //MARK: - Public properties
    
    static let identifier = "ExhibitorDashboardEventTableViewCell"
    weak var delegate: ExhibitorDashboardEventTableViewCellDelegate?
    
    //MARK: - Private properties
    
    private var event: Event?
    
    //MARK: - Public methods
    
    func configureCell(event: Event) {
        self.event = event
        nameLabel.text = event.name
        locationLabel.text = event.location.name
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        startDateLabel.text = formatter.string(from: event.startDate)
        endDateLabel.text = formatter.string(from: event.endDate)
        
        eventImage.layer.cornerRadius = eventImage.frame.height / 2
        guard let image = event.image else { return }
        eventImage.sd_setImage(with: URL(string: image), completed: nil)
    }
    
}

//MARK: - IBActions -

extension ExhibitorDashboardEventTableViewCell {
    
    @IBAction func didTapScanButton(_ sender: Any) {
        guard let event = event else { return }
        delegate?.didTapScanButton(event: event)
    }
    
}
