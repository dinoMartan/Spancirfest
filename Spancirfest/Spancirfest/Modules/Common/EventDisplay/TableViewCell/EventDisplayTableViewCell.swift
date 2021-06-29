//
//  HomeTableViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 22/06/2021.
//

import UIKit

protocol EventDisplayTableViewCellDelegate: AnyObject {
    
    func presentEvent(event: Event)
    
}

class EventDisplayTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionTitleLabel: UILabel!
    
    //MARK: - Public properties
    
    static let identifier = "EventDisplayTableViewCell"
    weak var delegate: EventDisplayTableViewCellDelegate?
    
    //MARK: - Private properties
    
    private var events: [Event] = []
    
    //MARK: - Public methods
    
    func configureCell(data: EventSortType) {
        switch data {
        case .date(let categoryDates):
            collectionTitleLabel.text = categoryDates.date.getDate(style: .medium)
            events = categoryDates.events
            collectionView.reloadData()
            
        case .category(let categoryEvents):
            collectionTitleLabel.text = categoryEvents.category.description
            events = categoryEvents.events
            collectionView.reloadData()
            
        case .location(let locationEvents):
            collectionTitleLabel.text = locationEvents.location.name
            events = locationEvents.events
            collectionView.reloadData()
            
        case .profile(let profileEvents):
            collectionTitleLabel.text = profileEvents.title
            events = profileEvents.events
            collectionView.reloadData()
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: EventDisplayCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: EventDisplayCollectionViewCell.identifier)
    }
    
}

//MARK: - CollectionView Delegates/DataSource -

extension EventDisplayTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDisplayCollectionViewCell.identifier, for: indexPath) as? EventDisplayCollectionViewCell else { return UICollectionViewCell() }
        
        let event = events[indexPath.row]
        cell.configureCell(event: event)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(130)
        let height = CGFloat(150)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let event = events[indexPath.row]
        delegate?.presentEvent(event: event)
    }

}
