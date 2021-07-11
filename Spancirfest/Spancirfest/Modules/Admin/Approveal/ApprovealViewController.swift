//
//  ApprovealViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 09/07/2021.
//

import UIKit

protocol ApprovealViewControllerDelegate: AnyObject {
    
    func didMakeChanges()
    
}

class ApprovealViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var backgroundView: UIView!
    
    //MARK: - Public properties
    
    var eventApproveal: EventApproveal?
    weak var delegate: ApprovealViewControllerDelegate?
    
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extensions -

private extension ApprovealViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        guard eventApproveal != nil else {
            // to do - handle error
            dismiss(animated: true, completion: nil)
            return
        }
        backgroundView.layer.cornerRadius = 15
    }
    
}

//MARK: - IBActions -

extension ApprovealViewController {
    
    @IBAction func didTapShowEventButton(_ sender: Any) {
        guard let event = eventApproveal?.event,
              let eventDetailsViewController = UIStoryboard.getViewController(viewControllerType: EventDetailsViewController.self, from: .Event)
        else { return }
        eventDetailsViewController.event = event
        present(eventDetailsViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapApproveButton(_ sender: Any) {
        guard let eventApproveal = prepareEventApproveal(approved: true) else { return }
        updateEventApproveal(eventApproveal: eventApproveal) {
            self.addEvent(event: eventApproveal.event) {
                self.delegate?.didMakeChanges()
                self.dismiss(animated: true, completion: nil)
            } failure: { error in
                // to do - handle error
            }
        } failure: {
            // to do - handle error
        }
    }
    
    @IBAction func didTapDenyButton(_ sender: Any) {
        guard let eventApproveal = prepareEventApproveal(approved: false) else { return }
        updateEventApproveal(eventApproveal: eventApproveal) {
            self.delegate?.didMakeChanges()
            self.dismiss(animated: true, completion: nil)
        } failure: {
            // to do - handle error
        }
    }
    
    private func prepareEventApproveal(approved: Bool) -> EventApproveal? {
        guard var eventApproveal = eventApproveal,
              let userId = CurrentUser.shared.getCurrentUserId()
        else { return nil }
        eventApproveal.comment = commentTextView.text
        eventApproveal.approvedBy = userId
        eventApproveal.approvedDate = Date()
        eventApproveal.approved = approved
        return eventApproveal
    }
    
    private func updateEventApproveal(eventApproveal: EventApproveal, success: @escaping (() -> Void), failure: @escaping (() -> Void)) {
        DatabaseHandler.shared.updateEventApproveal(eventApproveal: eventApproveal) { completion in
            if !completion { failure() }
            else { success() }
        }
    }
    
    private func addEvent(event: Event, success: @escaping (() -> Void), failure: @escaping ((Error?) -> Void)) {
        DatabaseHandler.shared.addData(data: [event], collection: .events) {
            success()
        } failure: { error in
            failure(error)
        }
    }
    
}
