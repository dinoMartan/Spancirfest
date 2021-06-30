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
    
}

class AdminDashboardViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Private properties
    
    private var tableData: [AdminDashboardTableData] = []
    
    //MARK: - Lifecycle
    
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
        fetchData()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: AdminDashboardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AdminDashboardTableViewCell.identifier)
    }
    
    //MARK: - Data
    
    private func fetchData() {
        fetchLocations {
            self.fetchEventCategories {
                self.tableView.reloadData()
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
        return 210
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - TableViewCellDelegate -

extension AdminDashboardViewController: AdminDashboardTableViewCellDelegate {
    
    func didTapAddNewLocationButton() {
        // to do - add new location
    }
    
    func didTapAddNewCategoryButton() {
        // to do - add new category
    }
    
    func didTapShowLocationDetails(location: Location) {
        // to do - show location details
    }
    
    func didTapShowCategoryDetails(category: EventCategory) {
        // to do - show event category details
    }
    
}
