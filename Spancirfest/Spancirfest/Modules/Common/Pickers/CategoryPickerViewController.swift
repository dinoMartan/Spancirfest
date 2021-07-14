//
//  CategoryPickerViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/06/2021.
//

import UIKit

protocol CategoryPickerViewControllerDelegate: AnyObject {
    
    func didSetCategory(eventCategory: EventCategory)
    
}

class CategoryPickerViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet private weak var categoryPickerView: UIPickerView!
    @IBOutlet private weak var miniView: UIView!
    
    //MARK: - Public properties
    
    weak var delegate: CategoryPickerViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var eventCategories: [EventCategory] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

//MARK: - Private extension -

private extension CategoryPickerViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        configureView()
        configurePickerView()
        fetchData()
    }
    
    private func configurePickerView() {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
    }
    
    private func configureView() {
        miniView.layer.cornerRadius = 15
    }
    
    //MARK: - Data fetching
    
    private func fetchData() {
        DatabaseHandler.shared.getData(type: EventCategory.self, collection: .eventCategory) { eventCategories in
            self.eventCategories = eventCategories
            self.categoryPickerView.reloadAllComponents()
        } failure: { error in
            Alerter.showOneButtonAlert(on: self, title: .error, message: .updateFailed, actionTitle: .ok, handler: nil)
        }
    }
    
}

//MARK: - DataSource/Delegate extension -

extension CategoryPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventCategories[row].description
    }
    
}

//MARK: - IBActions -

extension CategoryPickerViewController {
    
    @IBAction func didTapSetLocationButton(_ sender: Any) {
        let index = categoryPickerView.selectedRow(inComponent: 0)
        delegate?.didSetCategory(eventCategory: eventCategories[index])
        dismiss(animated: true, completion: nil)
    }
    
}
