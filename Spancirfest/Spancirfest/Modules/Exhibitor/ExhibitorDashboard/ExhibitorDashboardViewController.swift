//
//  ExhibitorDashboardViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit

class ExhibitorDashboardViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Private properties
    
    private var currentUsersEvents: [Event] = []
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        configureTableView()
        fetchData()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: ExhibitorDashboardEventTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ExhibitorDashboardEventTableViewCell.identifier)
    }
    
    private func fetchData() {
        guard let userId = CurrentUser.shared.getCurrentUserId() else { return }
        DatabaseHandler.shared.getDataWhere(type: Event.self, whereField: .ownerId, isEqualTo: userId) { events in
            self.currentUsersEvents = events
            self.tableView.reloadData()
        } failure: { error in
            //
        }


    }
    
}

//MARK: - Delegate extensions -

extension ExhibitorDashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsersEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExhibitorDashboardEventTableViewCell.identifier) as? ExhibitorDashboardEventTableViewCell else { return UITableViewCell() }
        cell.configureCell(event: currentUsersEvents[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let eventViewController = UIStoryboard.getViewController(viewControllerType: EventViewController.self, from: .Event) else { return }
        eventViewController.currentEvent = currentUsersEvents[indexPath.row]
        navigationController?.pushViewController(eventViewController, animated: true)
    }
    
}

//MARK: - IBActions -

extension ExhibitorDashboardViewController {
    
    @IBAction func didTapAddNewEventButton(_ sender: Any) {
        guard let eventViewController = UIStoryboard.getViewController(viewControllerType: EventViewController.self, from: .Event) else { return }
        navigationController?.pushViewController(eventViewController, animated: true)
    }
    
}
