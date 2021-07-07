//
//  EventDisplayViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 21/06/2021.
//

import UIKit
import SDWebImage
import BraintreeDropIn
import Braintree

protocol EventDetailsViewControllerDelegate: AnyObject {
    
    func didMakeChanges()
    
}

class EventDetailsViewController: UIViewController {
    
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
    @IBOutlet private weak var buyTicketsButton: UIButton!
    
    //MARK: - Public properties
    
    var event: Event?
    weak var delegate: EventDetailsViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var eventCategory: EventCategory?
    private var location: Location?
    private var eventFollowing: EventFollowing?
    private var userIsFollowingEvent: Bool?
    private var didFollowUnfollowEvent = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if didFollowUnfollowEvent { delegate?.didMakeChanges() }
    }
    
}

//MARK: - Private extensions -

private extension EventDetailsViewController {
    
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
        configureBuyButton()

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
    
    private func configureBuyButton() {
        guard let userId = CurrentUser.shared.getCurrentUserId(),
              let event = event,
              let paidUsers = event.paidUsers
        else { return }
        var didBuyTicket = false
        for paidUserId in paidUsers {
            if paidUserId == userId {
                didBuyTicket = true
                break
            }
        }
        
        if didBuyTicket {
            buyTicketsButton.isUserInteractionEnabled = false
            buyTicketsButton.setTitle("Tickets purchased", for: .normal)
            buyTicketsButton.tintColor = .systemGray
        }
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

extension EventDetailsViewController {
    
    @IBAction func didTapShowLocationDetailsButton(_ sender: Any) {
        guard let location = event?.location,
              let locationViewController = UIStoryboard.getViewController(viewControllerType: LocationDetailsViewController.self, from: .LocationDetails)
        else { return }
        locationViewController.location = location
        present(locationViewController, animated: true, completion: nil)
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
                self.didFollowUnfollowEvent = true
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
                self.didFollowUnfollowEvent = true
            } failure: { error in
                // to do - handle error
            }

        } failure: { error in
            // to do - handle error
        }
    }
    
    @IBAction func didTapBuyTicketsButton(_ sender: Any) {
        let tokenizationKey = "sandbox_v288kq6p_r63zxpwpvxyyvnsm"
        BTLogger().level = .none
        let request =  BTDropInRequest()
        request.paypalDisabled = true
        request.cardholderNameSetting = .required
        
        
        let dropIn = BTDropInController(authorization: tokenizationKey, request: request) { (controller, result, error) in
            if (error != nil) {
                // to do - handle error
            }
            else if let result = result {
                if let nonce = result.paymentMethod?.nonce {
                self.postNonceToServer(paymentMethodNonce: nonce)
                }
            }
            controller.dismiss(animated: true, completion: nil)
        }
        present(dropIn!, animated: true, completion: nil)
    }
    
    // to do - add API for handling transaction
    func postNonceToServer(paymentMethodNonce: String) {
        guard let event = event else { return }
        addEventToPaid()
        
        // when valid endpoint is created
        /*
        let paymentURL = URL(string: "https://your-server.example.com/payment-methods")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.httpBody = "amount=\(String(describing: event.price))".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if error == nil { self.addEventToPaid() }
        }.resume()
        */
    }
    
    func addEventToPaid() {
        guard var event = event,
              let userId = CurrentUser.shared.getCurrentUserId()
        else { return }
        if event.paidUsers == nil {
            event.paidUsers = [userId]
        }
        else { event.paidUsers?.append(userId) }
        DatabaseHandler.shared.updateEvent(event: event) { didComplete in
            if !didComplete {
                // to do - handle error
            }
            else {
                debugPrint("event updated!")
            }
        }
    }
    
}
