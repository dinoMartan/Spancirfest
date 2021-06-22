//
//  HomeTableViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 22/06/2021.
//

import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    
    func presentEvent(event: Event)
    
}

class HomeTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionTitleLabel: UILabel!
    
    //MARK: - Public properties
    
    static let identifier = "HomeTableViewCell"
    weak var delegate: HomeTableViewCellDelegate?
    
    //MARK: - Private properties
    
    private var events: [Event] = []
    
    //MARK: - Public methods
    
    func configureCell(data: HomeEventSortType) {
        switch data {
        case .category(let categoryEvents):
            collectionTitleLabel.text = categoryEvents.category.description
            events = categoryEvents.events
            collectionView.reloadData()
            
        case .location(let locationEvents):
            collectionTitleLabel.text = locationEvents.location.name
            events = locationEvents.events
            collectionView.reloadData()
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: HomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }
    
}

//MARK: - CollectionView Delegates/DataSource -

extension HomeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        
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
