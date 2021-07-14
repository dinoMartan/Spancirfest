//
//  LocationPickerViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/06/2021.
//

import UIKit

protocol LocationPickerViewControllerDelegate: AnyObject {
    
    func didSetLocation(location: Location)
    
}

class LocationPickerViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var locationPickerView: UIPickerView!
    @IBOutlet private weak var miniView: UIView!
    
    //MARK: - Public properties
    
    weak var delegate: LocationPickerViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var locations: [Location] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extension -

private extension LocationPickerViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        configureView()
        configurePickerView()
        fetchData()
    }
    
    private func configurePickerView() {
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
    }
    
    private func configureView() {
        miniView.layer.cornerRadius = 15
    }
    
    //MARK: - Data fetching
    
    private func fetchData() {
        DatabaseHandler.shared.getData(type: Location.self, collection: .locations) { locations in
            self.locations = locations
            self.locationPickerView.reloadAllComponents()
        } failure: { error in
            Alerter.showOneButtonAlert(on: self, title: .error, message: .dataFetchingFailed, actionTitle: .ok, handler: nil)
        }
    }
    
}

//MARK: - DataSource/Delegate extension -

extension LocationPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row].name
    }
    
}

//MARK: - IBActions -

extension LocationPickerViewController {
    
    @IBAction func didTapSetLocationButton(_ sender: Any) {
        let index = locationPickerView.selectedRow(inComponent: 0)
        delegate?.didSetLocation(location: locations[index])
        dismiss(animated: true, completion: nil)
    }
    
}
