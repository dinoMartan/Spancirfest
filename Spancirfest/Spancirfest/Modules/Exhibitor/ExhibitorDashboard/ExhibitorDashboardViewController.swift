//
//  ExhibitorDashboardViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit

enum ExhibitorDashboardData {
    
    case myEvents(events: [Event])
    case myApproveals(approveals: [EventApproveal])
    
}

class ExhibitorDashboardViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    //MARK: - Private properties

    private var tableData: ExhibitorDashboardData?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let segmentedIndex = segmentedControl.selectedSegmentIndex
        if segmentedIndex == 0 {
            fetchMyEvents()
        }
        else if segmentedIndex == 1 {
            fetchMyApproveals()
        }
    }
    
}

//MARK: - Private extensions -

private extension ExhibitorDashboardViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        configureTableView()
        configureSegmentedControl()
    }
    
    //MARK: - Segmented control configuration
    
    private func configureSegmentedControl() {
        setListenerOnSegmentedControl()
    }
    
    private func setListenerOnSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(self.didChangeValue(_:)), for: .valueChanged)
    }
    
    @objc func didChangeValue(_ sender: UISegmentedControl) {
        let index = self.segmentedControl.selectedSegmentIndex
        if index == 0 {
            fetchMyEvents()
        }
        else if index == 1 {
            fetchMyApproveals()
        }
    }
    
    //MARK: - TableView configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: ExhibitorDashboardEventTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ExhibitorDashboardEventTableViewCell.identifier)
        tableView.register(UINib(nibName: MyApprovealsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MyApprovealsTableViewCell.identifier)
    }
    
    //MARK: - Data
    
    private func fetchMyEvents() {
        guard let userId = CurrentUser.shared.getCurrentUserId() else { return }
        DatabaseHandler.shared.getDataWhere(type: Event.self, collection: .events, whereField: .ownerId, isEqualTo: userId) { events in
            self.tableData = .myEvents(events: events)
            self.tableView.reloadData()
        } failure: { error in
            //
        }
    }
    
    private func fetchMyApproveals() {
        guard let userId = CurrentUser.shared.getCurrentUserId() else { return }
        DatabaseHandler.shared.getDataWhere(type: EventApproveal.self, collection: .eventApproveal, whereField: .eventOwnerId, isEqualTo: userId){ eventApproveals in
            self.tableData = .myApproveals(approveals: eventApproveals)
            self.tableView.reloadData()
        } failure: { error in
            // to do - handle error
        }
    }
    
}

//MARK: - Delegate extensions -

extension ExhibitorDashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableData = tableData else { return 0 }
        switch tableData {
        case .myApproveals(let approveals):
            return approveals.count
        case .myEvents(let events):
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableData = tableData else { return UITableViewCell() }
        switch tableData {
        case .myEvents(let events):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExhibitorDashboardEventTableViewCell.identifier) as? ExhibitorDashboardEventTableViewCell else { return UITableViewCell() }
            cell.configureCell(event: events[indexPath.row])
            cell.delegate = self
            return cell
        case .myApproveals(let approveals):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyApprovealsTableViewCell.identifier) as? MyApprovealsTableViewCell else { return UITableViewCell() }
            cell.configureCell(eventApproveal: approveals[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let tableData = tableData else { return }
        switch tableData {
        case .myEvents(let events):
            guard let eventViewController = UIStoryboard.getViewController(viewControllerType: EventEditorViewController.self, from: .Event) else { return }
            eventViewController.currentEvent = events[indexPath.row]
            navigationController?.pushViewController(eventViewController, animated: true)
        case .myApproveals(let approveals):
            guard let approvealDetailsViewController = UIStoryboard.getViewController(viewControllerType: ApprovealDetailsViewController.self, from: .Approveal) else { return }
            approvealDetailsViewController.eventApproveal = approveals[indexPath.row]
            present(approvealDetailsViewController, animated: true, completion: nil)
        }
    }
    
}

//MARK: - IBActions -

extension ExhibitorDashboardViewController {
    
    @IBAction func didTapAddNewEventButton(_ sender: Any) {
        guard let eventViewController = UIStoryboard.getViewController(viewControllerType: EventEditorViewController.self, from: .Event) else { return }
        navigationController?.pushViewController(eventViewController, animated: true)
    }
    
}

//MARK: - ExhibitorDashboardEventTableViewCellDelegate -

extension ExhibitorDashboardViewController: ExhibitorDashboardEventTableViewCellDelegate {
    
    func didTapScanButton(event: Event) {
        guard let exhibitorEventQRScanViewController = UIStoryboard.getViewController(viewControllerType: ExhibitorEventQRScanViewController.self, from: .ExhibitorEventQRScan) else { return }
        exhibitorEventQRScanViewController.event = event
        navigationController?.pushViewController(exhibitorEventQRScanViewController, animated: true)
    }
    
}
