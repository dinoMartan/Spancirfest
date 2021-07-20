//
//  AdminDashboardTableViewCell.swift
//  Spancirfest
//
//  Created by Dino Martan on 30/06/2021.
//

import UIKit

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
        case .eventApproveal(let title, _):
            titleLabel.text = title
            addNewButton.isHidden = true
            collectionView.register(UINib(nibName: EventDisplayCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: EventDisplayCollectionViewCell.identifier)
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
        case .eventApproveal(_, _):
            return
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
        case .eventApproveal(_, let approvealEvents):
        return approvealEvents.count
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
        case .eventApproveal(_, let approvealEvents):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDisplayCollectionViewCell.identifier, for: indexPath) as? EventDisplayCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(event: approvealEvents[indexPath.row].event)
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
        case .eventApproveal(_, let approvealEvents):
            delegate?.didTapShowEventApprovealDetails(eventApproveal: approvealEvents[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(130)
        let height = CGFloat(150)
        return CGSize(width: width, height: height)
    }
    
}
