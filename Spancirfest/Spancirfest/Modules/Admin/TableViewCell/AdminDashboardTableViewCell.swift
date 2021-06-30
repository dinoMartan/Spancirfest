//
//  AdminDashboardTableViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 30/06/2021.
//

import UIKit

protocol AdminDashboardTableViewCellDelegate: AnyObject {
    
    func didTapAddNewLocationButton()
    func didTapAddNewCategoryButton()
    func didTapShowLocationDetails(location: Location)
    func didTapShowCategoryDetails(category: EventCategory)
    
}

class AdminDashboardTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addNewButton: UIButton!
    
    //MARK: - Public properties
    
    static let identifier = "AdminDashboardTableViewCell"
    weak var delegate: AdminDashboardTableViewCellDelegate?
    
    //MARK: - Private properties
    
    private var data: AdminDashboardTableData?
    
    //MARK: - Public methods
    
    func configureCell(data: AdminDashboardTableData) {
        self.data = data
        collectionView.dataSource = self
        collectionView.delegate = self
        switch data {
        case .locations(let title, let buttonText, _):
            titleLabel.text = title
            if buttonText != nil { addNewButton.setTitle(buttonText, for: .normal) }
            else { addNewButton.isHidden = true }
            collectionView.register(UINib(nibName: AdminDashboardLocationCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AdminDashboardLocationCollectionViewCell.identifier)
            collectionView.reloadData()
        case .categories(let title, let buttonText, _):
            titleLabel.text = title
            if buttonText != nil { addNewButton.setTitle(buttonText, for: .normal) }
            else { addNewButton.isHidden = true }
            collectionView.register(UINib(nibName: AdminDashboardCategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AdminDashboardCategoryCollectionViewCell.identifier)
            collectionView.reloadData()
        }
    }
    
}

//MARK: - IBActions -

extension AdminDashboardTableViewCell {
    
    @IBAction func didTapAddNewButton(_ sender: Any) {
        guard let data = data else { return }
        switch data {
        case .categories(_, _, _):
            delegate?.didTapAddNewCategoryButton()
        case .locations(_, _, _):
            delegate?.didTapAddNewLocationButton()
        }
    }
    
}

//MARK: - CollectionView DataSource and Delegate -

extension AdminDashboardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        switch data {
        case .locations(_, _, let locations):
            return locations.count
        case .categories(_, _, let categories):
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = data else { return UICollectionViewCell() }
        switch data {
        case .locations(_, _, let locations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminDashboardLocationCollectionViewCell.identifier, for: indexPath) as? AdminDashboardLocationCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(location: locations[indexPath.row])
            return cell
        case .categories(_, _, let categories):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdminDashboardCategoryCollectionViewCell.identifier, for: indexPath) as? AdminDashboardCategoryCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(eventCategory: categories[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let data = data else { return }
        switch data {
        case .locations(_, _, let locations):
            delegate?.didTapShowLocationDetails(location: locations[indexPath.row])
        case .categories(_, _, let categories):
            delegate?.didTapShowCategoryDetails(category: categories[indexPath.row])
        }
    }
    
}
