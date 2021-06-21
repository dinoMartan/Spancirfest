//
//  EventDisplayViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 21/06/2021.
//

import UIKit
import SDWebImage

class EventDisplayViewController: UIViewController {
    
    //MARK: - IBOutlets

    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!
    @IBOutlet private weak var numberOfPeopleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var imageBackgroundView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    
    //MARK: - Public properties
    
    var event: Event?
    
    //MARK: - Private properties
    
    private var eventCategory: EventCategory?
    private var location: Location?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

//MARK: - Private extensions -

private extension EventDisplayViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        checkIfEventIsSet()
        configureUI()
        setEventCategoryAndLocation()
    }
    
    private func checkIfEventIsSet() {
        guard event != nil else {
            // to do - handle error, dissmiss view
            return
        }
    }
    
    private func configureImageLayout() {
        eventImage.layer.cornerRadius = 15
        imageBackgroundView.layer.cornerRadius = 15
    }
    
    private func configureBackgroundLayout() {
        backgroundView.layer.cornerRadius = 15
    }
    
    private func configureUI() {
        guard let event = event else { return }
        
        configureImageLayout()
        configureBackgroundLayout()

        if let image = event.image { eventImage.sd_setImage(with: URL(string: image), completed: nil) }
        titleLabel.text = event.name
        startDateLabel.text = event.startDate.toString(style: .style1)
        endDateLabel.text = event.endDate.toString(style: .style1)
        if let numberOfPeople = event.numberOfPeople { numberOfPeopleLabel.text = String(numberOfPeople) }
        if let price = event.price { priceLabel.text = String(price) }
        locationLabel.text = event.location.name
        categoryLabel.text = event.eventCategory.description
    }

    private func setEventCategoryAndLocation() {
        guard let event = event else { return }
        eventCategory = event.eventCategory
        location = event.location
    }
    
}

//MARK: - IBActions -

extension EventDisplayViewController {
    
    
    @IBAction func didTapShowLocationDetailsButton(_ sender: Any) {
    }
    
    @IBAction func didTapShowCategoryDetailsButton(_ sender: Any) {
    }
    
    @IBAction func didTapAddToFavouritesButton(_ sender: Any) {
    }
    
    @IBAction func didTapBuyTicketsButton(_ sender: Any) {
    }
    
}
