//
//  ProfileViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Private properties
    
    private var tableData: [ProfileViewControllerTableData] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
}

//MARK: - Private extensions -

private extension ProfileViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: EventDisplayTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: EventDisplayTableViewCell.identifier)
    }
    
    //MARK: - Fetching data
    
    private func fetchData() {
        tableData.removeAll()
        fetchFavouriteEvents()
        fetchPaidEvents()
    }
    
    private func fetchFavouriteEvents() {
        guard let userId = CurrentUser.shared.getCurrentUserId() else { return }
        DatabaseHandler.shared.getFollowingEventsForUser(userId: userId) { events in
            let profileViewControllerData = ProfileViewControllerTableData(title: TitlesConstants.favouriteEvents.rawValue, events: events)
            self.tableData.append(profileViewControllerData)
            self.tableView.reloadData()
        } failure: { error in
            // to do - handle error
        }

    }
    
    private func fetchPaidEvents() {
        // to do - implement paid events in db
    }
    
}

//MARK: - TableView DataSource/Delegate -

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventDisplayTableViewCell.identifier) as? EventDisplayTableViewCell else { return UITableViewCell() }
        cell.configureCell(data: .profile(data: tableData[indexPath.row]))
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}

//MARK: - EventDisplayTableViewCell and EventDetailsViewController Delegates -

extension ProfileViewController: EventDisplayTableViewCellDelegate, EventDetailsViewControllerDelegate {
    
    func presentEvent(event: Event) {
        guard let eventDisplayViewController = UIStoryboard.getViewController(viewControllerType: EventDetailsViewController.self, from: .Event) else { return }
        eventDisplayViewController.event = event
        eventDisplayViewController.delegate = self
        present(eventDisplayViewController, animated: true, completion: nil)
    }
    
    func didMakeChanges() {
        fetchData()
    }
    
}

//MARK: - IBActions -

extension ProfileViewController {
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        guard let authenticationViewController = UIStoryboard.getViewController(viewControllerType: AuthenticationViewController.self, from: .Authentication) else { return }
        authenticationViewController.modalPresentationStyle = .fullScreen
        _ = CurrentUser.shared.signOut()
        present(authenticationViewController, animated: true, completion: nil)
    }
    
}

