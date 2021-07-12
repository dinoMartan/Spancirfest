//
//  HomeViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Private properties
    
    private var allEvents: [Event] = []
    private var eventsByCategory: [EventsByCategory] = []
    private var eventsByLocation: [EventsByLocation] = []
    private var eventsByDate: [EventsByDate] = []
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData {
            //
        }
    }

}

//MARK: -  Private extensions -

private extension HomeViewController {
    
    //MARK: - View setup and configuration
    
    private func setupView() {
        setListenerOnSegmentedControl()
        configureTableView()
        fetchData {
            self.sortEventsByDate {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - SegmentedControl setup and configuration
    
    private func setListenerOnSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(self.didChangeValue(_:)), for: .valueChanged)
    }
    
    @objc func didChangeValue(_ sender: UISegmentedControl) {
        fetchData {
            let index = self.segmentedControl.selectedSegmentIndex
            
            if index == 0 { // daily
                self.sortEventsByDate {
                    self.tableView.reloadData()
                }
            }
            
            else if index == 1 { // category
                self.sortEventByCategory {
                    self.tableView.reloadData()
                }
            }
            
            else if index == 2 { // locations
                self.sortEventByLocation {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - TableView configuration
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: EventDisplayTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: EventDisplayTableViewCell.identifier)
    }
    
}

private extension HomeViewController {
    
    //MARK: - Data
    
    private func fetchData(completion: @escaping (() -> Void)) {
        DatabaseHandler.shared.getData(type: Event.self, collection: .events) { events in
            self.allEvents = events
            completion()
        } failure: { error in
             completion()
            // to do - handle error
        }
    }
    
    // sorting - far better implementation would be with proper API calls - DB should do all the sorting
    
    private func sortEventByCategory(completion: @escaping(() -> Void)) {
        eventsByCategory.removeAll()
        DatabaseHandler.shared.getData(type: EventCategory.self, collection: .eventCategory) { eventCategories in
            for category in eventCategories {
                var eventsByCategory = EventsByCategory(category: category, events: [])
                for event in self.allEvents {
                    if event.eventCategory.categoryId == category.categoryId { eventsByCategory.events.append(event) }
                }
                self.eventsByCategory.append(eventsByCategory)
            }
            completion()
        } failure: { error in
            completion()
            // to do - handle error
        }
    }
    
    private func sortEventsByDate(completion: @escaping (() -> Void)) {
        eventsByDate.removeAll()
        FestivalData.shared.getFestivalDetails { festivalDetails in
            let startDate = festivalDetails.startDate
            let endDate = festivalDetails.endDate
            let dates = Date.dates(from: startDate, to: endDate)
            
            for date in dates {
                var eventsByDate = EventsByDate(date: date, events: [])
                for event in self.allEvents {
                    if event.startDate.getDate(style: .short) == date.getDate(style: .short) { eventsByDate.events.append(event) }
                }
                if !eventsByDate.events.isEmpty { self.eventsByDate.append(eventsByDate) }
                else { continue }
            }
            completion()
            
        } failure: { error in
            // to do - handle error
            completion()
        }
    }
    
    private func sortEventByLocation(completion: @escaping (() -> Void)) {
        eventsByLocation.removeAll()
        DatabaseHandler.shared.getData(type: Location.self, collection: .locations) { locations in
            for location in locations {
                var eventsByLocation = EventsByLocation(location: location, events: [])
                for event in self.allEvents {
                    if event.location.locationId == location.locationId { eventsByLocation.events.append(event) }
                }
                self.eventsByLocation.append(eventsByLocation)
            }
            completion()
        } failure: { error in
            completion()
            // to do - handle error
        }
    }
    
}

//MARK: - TableView DataSource and Delegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = segmentedControl.selectedSegmentIndex
        
        if index == 0 { // daily
            return eventsByDate.count
        }
        
        else if index == 1 { // category
            return eventsByCategory.count
        }
        
        else if index == 2 { // locations
            return eventsByLocation.count
        }
        
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventDisplayTableViewCell.identifier) as? EventDisplayTableViewCell else { return UITableViewCell() }
        let index = segmentedControl.selectedSegmentIndex
        
        if index == 0 { cell.configureCell(data: .date(date: eventsByDate[indexPath.row])) }
        else if index == 1 { cell.configureCell(data: .category(data: eventsByCategory[indexPath.row])) }
        else if index == 2 { cell.configureCell(data: .location(data: eventsByLocation[indexPath.row])) }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
}

//MARK: - EventDisplayTableViewCell Delegate

extension HomeViewController: EventDisplayTableViewCellDelegate {
    
    func presentEvent(event: Event) {
        guard let eventDisplayViewController = UIStoryboard.getViewController(viewControllerType: EventDetailsViewController.self, from: .Event) else { return }
        eventDisplayViewController.event = event
        present(eventDisplayViewController, animated: true, completion: nil)
    }
    
}

