//
//  DatePickerViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/06/2021.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var miniView: UIView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    //MARK: - Public properties
    
    var eventDateType: EventDateType?
    weak var delegate: DatePickerViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var minimumDate: Date?
    private var maximumDate: Date?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setMinimumDate(date: Date) {
        minimumDate = date
    }
    
    func setMaximumDate(date: Date) {
        maximumDate = date
    }
    
}

//MARK: - Private extensions -

private extension DatePickerViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        configureView()
        setMinimumMaximumDates()
    }
    
    private func configureView() {
        miniView.layer.cornerRadius = 15
    }
    
    private func setMinimumMaximumDates() {
        guard let minimumDate = minimumDate,
              let maximumDate = maximumDate
        else { return }
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        debugPrint(datePicker.minimumDate)
    }
    
}

//MARK: - IBActions -

extension DatePickerViewController {
    
    @IBAction func didTapSetDateButton(_ sender: Any) {
        guard let eventDateType = eventDateType else { return }
        let eventDate = EventDate(type: eventDateType, date: datePicker.date)
        delegate?.didSetDate(eventDate: eventDate)
        self.dismiss(animated: true, completion: nil)
    }
    
}
