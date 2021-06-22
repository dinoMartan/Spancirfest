//
//  HomeViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit

enum HomeEventSortType {
    
    case category(data: HomeViewControllerEventsByCategory)
    case location(data: HomeViewControllerEventsByLocation)
}


struct HomeViewControllerEventsByCategory {
    
    let category: EventCategory
    var events: [Event]
    
}

struct HomeViewControllerEventsByLocation {
    
    let location: Location
    var events: [Event]
    
}

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Private properties
    
    private var allEvents: [Event] = []
    private var eventsByCategory: [HomeViewControllerEventsByCategory] = []
    private var eventsByLocation: [HomeViewControllerEventsByLocation] = []
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setListenerOnSegmentedControl()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData {
            //
        }
    }
    
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
                var eventsByCategory = HomeViewControllerEventsByCategory(category: category, events: [])
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
    
    private func sortEventByLocation(completion: @escaping (() -> Void)) {
        eventsByLocation.removeAll()
        DatabaseHandler.shared.getData(type: Location.self, collection: .locations) { locations in
            for location in locations {
                var eventsByLocation = HomeViewControllerEventsByLocation(location: location, events: [])
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
    
    private func setListenerOnSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(self.didChangeValue(_:)), for: .valueChanged)
    }
    
    @objc func didChangeValue(_ sender: UISegmentedControl) {
        fetchData {
            let index = self.segmentedControl.selectedSegmentIndex
            
            if index == 0 { // daily
                // to do - add starting and ending date of the festival
                // for every day of the festival, get events and display them
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
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HomeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.identifier)
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = segmentedControl.selectedSegmentIndex
        
        if index == 0 { // daily
            return 0
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier) as? HomeTableViewCell else { return UITableViewCell() }
        let index = segmentedControl.selectedSegmentIndex
        
        if index == 0 { }
        else if index == 1 { cell.configureCell(data: .category(data: eventsByCategory[indexPath.row])) }
        else if index == 2 { cell.configureCell(data: .location(data: eventsByLocation[indexPath.row])) }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
}

extension HomeViewController: HomeTableViewCellDelegate {
    
    func presentEvent(event: Event) {
        guard let eventDisplayViewController = UIStoryboard.getViewController(viewControllerType: EventDisplayViewController.self, from: .Event) as? EventDisplayViewController else { return }
        eventDisplayViewController.event = event
        present(eventDisplayViewController, animated: true, completion: nil)
    }
    
}

