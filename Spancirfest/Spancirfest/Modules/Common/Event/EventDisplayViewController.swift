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
    @IBOutlet private weak var followButton: UIButton!
    
    //MARK: - Public properties
    
    var event: Event?
    
    //MARK: - Private properties
    
    private var eventCategory: EventCategory?
    private var location: Location?
    private var eventFollowing: EventFollowing?
    private var userIsFollowingEvent: Bool?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

//MARK: - Private extensions -

private extension EventDisplayViewController {
    
    //MARK: - Setup
    
    private func setupView() {
        checkIfEventIsSet()
        configureUI()
        setEventCategoryAndLocation()
        checkIfUsersIsFollowingEvent {
            self.configureFollowButton()
        } failure: { error in
            // to do - handle error
        }

    }
    
    private func checkIfEventIsSet() {
        guard event != nil else {
            // to do - handle error, dissmiss view
            return
        }
    }
    
    private func setEventCategoryAndLocation() {
        guard let event = event else { return }
        eventCategory = event.eventCategory
        location = event.location
    }
    
    //MARK: - UI Configuration
    
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
    
    private func configureImageLayout() {
        eventImage.layer.cornerRadius = 15
        imageBackgroundView.layer.cornerRadius = 15
    }
    
    private func configureBackgroundLayout() {
        backgroundView.layer.cornerRadius = 15
    }
    
    private func configureFollowButton() {
        guard let userIsFollowing = self.userIsFollowingEvent else { return }
        if userIsFollowing {
           // self.followButton.setTitle(FollowButtonConstants.unfollow.rawValue, for: .normal)
            followButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
           // self.followButton.setTitle(FollowButtonConstants.follow.rawValue, for: .normal)
            followButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    //MARK: - Event following check
    
    private func checkIfUsersIsFollowingEvent(success: @escaping (() -> Void), failure: @escaping ((Error?) -> Void)) {
        CurrentUser.shared.getCurrentUserDetails { userDetails in
            guard let userId = CurrentUser.shared.getCurrentUserId(),
                  let event = self.event
            else {
                failure(nil)
                return
            }
            DatabaseHandler.shared.isUserFollowingEvent(userId: userId, eventId: event.eventId) { isFollowing in
                self.userIsFollowingEvent = isFollowing
                self.eventFollowing = EventFollowing(userId: userId, eventId: event.eventId)
                success()
            } failure: { error in
                failure(error)
            }
        }
    }
    
}

//MARK: - IBActions -

extension EventDisplayViewController {
    
    
    @IBAction func didTapShowLocationDetailsButton(_ sender: Any) {
    }
    
    @IBAction func didTapShowCategoryDetailsButton(_ sender: Any) {
    }
    
    @IBAction func didTapAddToFollowButton(_ sender: Any) {
        checkIfUsersIsFollowingEvent {
            guard let eventFollowing = self.eventFollowing,
                  let userIsFollowingEvent = self.userIsFollowingEvent
            else { return }
            
            if userIsFollowingEvent { self.unfollowEvent(eventFollowing: eventFollowing) }
            else { self.followEvent(eventFollowing: eventFollowing) }
        } failure: { error in
            // to do - handle error
        }
    }
    
    private func followEvent(eventFollowing: EventFollowing) {
        DatabaseHandler.shared.addData(data: [eventFollowing], collection: .eventFollowing) {
            self.checkIfUsersIsFollowingEvent {
                self.configureFollowButton()
            } failure: { error in
                // to do - handle error
            }

        } failure: { error in
            // to do - handle error
        }
    }
    
    private func unfollowEvent(eventFollowing: EventFollowing) {
        DatabaseHandler.shared.unfollowEvent(eventFollowing: eventFollowing) {
            self.checkIfUsersIsFollowingEvent {
                self.configureFollowButton()
            } failure: { error in
                // to do - handle error
            }

        } failure: { error in
            // to do - handle error
        }
    }
    
    @IBAction func didTapBuyTicketsButton(_ sender: Any) {
    }
    
}
