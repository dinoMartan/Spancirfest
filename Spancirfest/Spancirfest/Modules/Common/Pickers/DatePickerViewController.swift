//
//  DatePickerViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 20/06/2021.
//

import UIKit

protocol DatePickerViewControllerDelegate: AnyObject {
    
    func didSetDate(eventDate: EventDate)
    
}

class DatePickerViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var miniView: UIView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    //MARK: - Public properties
    
    var eventDateType: EventDateType?
    weak var delegate: DatePickerViewControllerDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        configureView()
    }
    
    private func configureView() {
        miniView.layer.cornerRadius = 15
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
