//
//  MapLocationEventsViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 27/06/2021.
//

import UIKit

class MapLocationEventsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var backgroundView: UIView!
    
    //MARK: - Public properties
    
    var location: Location?
    
    //MARK: - Private properties
    
    private var events: [Event] = []
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extensions -

private extension MapLocationEventsViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        configureCollectionView()
        getEvents()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: EventDisplayCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: EventDisplayCollectionViewCell.identifier)
        collectionView.layer.cornerRadius = 15
        backgroundView.layer.cornerRadius = 15
        
    }
    
    //MARK: - Fetching data
    
    private func getEvents() {
        guard let location = location else { return }
        DatabaseHandler.shared.getDataWhere(type: Event.self, collection: .events, whereField: .eventLocationId, isEqualTo: location.locationId) { events in
            self.events = events
            self.collectionView.reloadData()
        } failure: { error in
            // to do - handle error
        }
    }
    
}

//MARK: - CollectionView Delegate and DataSource

extension MapLocationEventsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDisplayCollectionViewCell.identifier, for: indexPath) as? EventDisplayCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(event: events[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(130)
        let height = CGFloat(150)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let eventViewController = UIStoryboard.getViewController(viewControllerType: EventDetailsViewController.self, from: .Event) else { return }
        eventViewController.event = events[indexPath.row]
        present(eventViewController, animated: true, completion: nil)
    }
    
}
