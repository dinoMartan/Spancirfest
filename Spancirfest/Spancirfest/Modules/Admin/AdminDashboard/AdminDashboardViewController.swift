//
//  AdminDashboardViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit

enum AdminDashboardTableData {
    
    case locations (title: String, buttonText: String?, locations: [Location])
    case categories (title: String, buttonText: String?, categories: [EventCategory])
    case eventApproveal (title: String, approvealEvents: [EventApproveal])
    
}

class AdminDashboardViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Private properties
    
    private var tableData: [AdminDashboardTableData] = []
    
    //MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extensions -

private extension AdminDashboardViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: AdminDashboardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AdminDashboardTableViewCell.identifier)
    }
    
    //MARK: - Data
    
    private func fetchData() {
        tableData.removeAll()
        fetchLocations {
            self.fetchEventCategories {
                self.fetchEventApproveals {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func fetchLocations(completion: @escaping (() -> Void)) {
        DatabaseHandler.shared.getData(type: Location.self, collection: .locations) { locations in
            let locationsData = AdminDashboardTableData.locations(title: "Locations", buttonText: "Add new location", locations: locations)
            self.tableData.append(locationsData)
            completion()
        } failure: { error in
            // to do - handle error
            completion()
        }
    }
    
    private func fetchEventCategories(completion: @escaping (() -> Void)) {
        DatabaseHandler.shared.getData(type: EventCategory.self, collection: .eventCategory) { eventCategories in
            let categoriesData = AdminDashboardTableData.categories(title: "Categories", buttonText: "Add new category", categories: eventCategories)
            self.tableData.append(categoriesData)
            completion()
        } failure: { error in
            // to do - handle error
            completion()
        }
    }
    
    private func fetchEventApproveals(completion: @escaping (() -> Void)) {
        DatabaseHandler.shared.getDataWhere(type: EventApproveal.self, collection: .eventApproveal, whereField: .approved, isEqualTo: false) { eventApproveals in
            let eventApprovealData = AdminDashboardTableData.eventApproveal(title: "Event Approveals", approvealEvents: eventApproveals)
            self.tableData.append(eventApprovealData)
            completion()
        } failure: { error in
            // to do - handle error
            completion()
        }

    }
    
}

//MARK: - TableView Datasource and Delegate -

extension AdminDashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AdminDashboardTableViewCell.identifier) as? AdminDashboardTableViewCell else { return UITableViewCell() }
        cell.configureCell(data: tableData[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = tableData[indexPath.row]
        switch data {
        case .categories(_, _, _):
            return 230
        case .locations(_, _, _):
            return 230
        case .eventApproveal(_, _):
            return 230
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - TableViewCellDelegate -

extension AdminDashboardViewController: AdminDashboardTableViewCellDelegate {
    
    func didTapAddNewLocationButton() {
        guard let locationEditorViewController = UIStoryboard.getViewController(viewControllerType: LocationEditorViewController.self, from: .LocationDetails) else { return }
        present(locationEditorViewController, animated: true, completion: nil)
    }
    
    func didTapAddNewCategoryButton() {
        guard let eventCategoryViewController = UIStoryboard.getViewController(viewControllerType: EventCategoryViewController.self, from: .EventCategory) else { return }
        present(eventCategoryViewController, animated: true, completion: nil)
    }
    
    func didTapShowLocationDetails(location: Location) {
        guard let locationEditorViewController = UIStoryboard.getViewController(viewControllerType: LocationEditorViewController.self, from: .LocationDetails) else { return }
        locationEditorViewController.location = location
        present(locationEditorViewController, animated: true, completion: nil)
    }
    
    func didTapShowCategoryDetails(category: EventCategory) {
        guard let eventCategoryViewController = UIStoryboard.getViewController(viewControllerType: EventCategoryViewController.self, from: .EventCategory) else { return }
        eventCategoryViewController.eventCategory = category
        present(eventCategoryViewController, animated: true, completion: nil)
    }
    
    func didTapShowEventApprovealDetails(eventApproveal: EventApproveal) {
        guard let eventApprovealViewController = UIStoryboard.getViewController(viewControllerType: ApprovealViewController.self, from: .Approveal) else { return }
        eventApprovealViewController.eventApproveal = eventApproveal
        present(eventApprovealViewController, animated: true, completion: nil)
    }
    
}

//MARK: - EventDetails Delegate -

extension AdminDashboardViewController: EventDetailsViewControllerDelegate {
    
    func didMakeChanges() {
        fetchData()
    }
    
}
