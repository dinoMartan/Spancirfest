//
//  ApprovealDetailsViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 10/07/2021.
//

import UIKit


class ApprovealDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var creationDateLabel: UILabel!
    @IBOutlet private weak var feedbackDateLabel: UILabel!
    @IBOutlet private weak var commentTextView: UITextView!
    
    //MARK: - Public properties
    
    var eventApproveal: EventApproveal?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extensions -

private extension ApprovealDetailsViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        configureUI()
    }
    
    private func configureUI() {
        guard let eventApproveal = eventApproveal else { return }
        creationDateLabel.text = eventApproveal.creationDate.toString(style: .style1)
        feedbackDateLabel.text = eventApproveal.approvedDate?.toString(style: .style1)
        commentTextView.text = eventApproveal.comment
        setStatus()
    }
    
    private func setStatus() {
        guard let eventApproveal = eventApproveal else { return }
        let eventStatus = eventApproveal.getStatus()
        statusLabel.text = eventStatus.text
        statusLabel.textColor = eventStatus.color
    }
    
}

//MARK: - IBActions -

extension ApprovealDetailsViewController {
    
    @IBAction func didTapShowEventButton(_ sender: Any) {
        guard let event = eventApproveal?.event,
              let eventViewController = UIStoryboard.getViewController(viewControllerType: EventDetailsViewController.self, from: .Event)
        else { return }
        eventViewController.event = event
        present(eventViewController, animated: true, completion: nil)
    }
    
}
