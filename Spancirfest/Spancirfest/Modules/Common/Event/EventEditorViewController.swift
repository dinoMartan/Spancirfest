//
//  EventViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 16/06/2021.
//

import UIKit
import SDWebImage

enum EventDateType {
    
    case startDate
    case endDate
    
}

struct EventDate {
    
    let type: EventDateType
    let date: Date
    
}

class EventEditorViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var eventNameTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var numberOfPeopleTextField: UITextField!
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var loadingAnimationView: UIView!
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var createEventButton: UIButton!
    @IBOutlet private weak var setImageButton: UIButton!
    
    //MARK: - Public properties
    
    var currentEvent: Event?
    
    //MARK: - Private properties
    
    private let imagePickerController = UIImagePickerController()
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    private var selectedLocation: Location?
    private var selectedCategory: EventCategory?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

//MARK: - Private extensions -

private extension EventEditorViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        stopLoadingAnimation()
        if currentEvent != nil { loadEventData() }
    }
    
    private func loadEventData() {
        createEventButton.setTitle("Update Event", for: .normal)
        setImageButton.isEnabled = false
        guard let event = currentEvent else { return }
        if event.image != nil { eventImage.sd_setImage(with: URL(string: event.image ?? ""), completed: nil) }
        eventNameTextField.text = event.name
        selectedStartDate = event.startDate
        selectedEndDate = event.endDate
        startDateLabel.text = event.startDate.toString(style: .style1)
        endDateLabel.text = event.endDate.toString(style: .style1)
        priceTextField.text = String(event.price ?? 0)
        numberOfPeopleTextField.text = String(event.numberOfPeople ?? 0)
        selectedLocation = event.location
        locationLabel.text = event.location.name
        selectedCategory = event.eventCategory
        categoryLabel.text = event.eventCategory.description
    }
    
    //MARK: - Loading animation
    
    private func startLoadingAnimation() {
        loadingAnimationView.isHidden = false
        loadingActivityIndicator.startAnimating()
    }
    
    private func stopLoadingAnimation() {
        loadingAnimationView.isHidden = true
        loadingActivityIndicator.stopAnimating()
    }
    
}

//MARK: - IBActions -

extension EventEditorViewController {
    
    @IBAction func didTapOutside(_ sender: Any) {
        locationLabel.resignFirstResponder()
        categoryLabel.resignFirstResponder()
        priceTextField.resignFirstResponder()
        eventNameTextField.resignFirstResponder()
        numberOfPeopleTextField.resignFirstResponder()
    }
    
    @IBAction func didTapSetImageButton(_ sender: Any) {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSetStartDateButton(_ sender: Any) {
        FestivalData.shared.getFestivalDetails { festivalDetails in
            debugPrint(festivalDetails)
            guard let datePickerViewController = UIStoryboard.getViewController(viewControllerType: DatePickerViewController.self, from: .Pickers) else { return }
            datePickerViewController.delegate = self
            datePickerViewController.eventDateType = .startDate
            datePickerViewController.setMinimumDate(date: festivalDetails.startDate)
            datePickerViewController.setMaximumDate(date: festivalDetails.endDate)
            self.present(datePickerViewController, animated: true, completion: nil)
        } failure: { error in
            // to do - handle error
        }
    }
    
    @IBAction func didTapSetEndDateButton(_ sender: Any) {
        FestivalData.shared.getFestivalDetails { festivalDetails in
            guard let datePickerViewController = UIStoryboard.getViewController(viewControllerType: DatePickerViewController.self, from: .Pickers) else { return }
            datePickerViewController.delegate = self
            datePickerViewController.eventDateType = .endDate
            datePickerViewController.setMinimumDate(date: festivalDetails.startDate)
            datePickerViewController.setMaximumDate(date: festivalDetails.endDate)
            self.present(datePickerViewController, animated: true, completion: nil)
        } failure: { error in
            // to do - handle error
        }
    }
    
    @IBAction func didTapSetLocationButton(_ sender: Any) {
        guard let locationPickerViewController = UIStoryboard.getViewController(viewControllerType: LocationPickerViewController.self, from: .Pickers) else { return }
        locationPickerViewController.delegate = self
        present(locationPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSetCategoryButton(_ sender: Any) {
        guard let categoryPickerViewController = UIStoryboard.getViewController(viewControllerType: CategoryPickerViewController.self, from: .Pickers) else { return }
        categoryPickerViewController.delegate = self
        present(categoryPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapCreateEventButton(_ sender: Any) {
        guard let name = eventNameTextField.text,
              let priceText = priceTextField.text,
              let price = Float(priceText),
              let numberOfPeopleText = numberOfPeopleTextField.text,
              let numberOfPeople = Int(numberOfPeopleText),
              let currentUserId = CurrentUser.shared.getCurrentUserId(),
              let startingDate = selectedStartDate,
              let endingDate = selectedEndDate,
              let location = selectedLocation,
              let category = selectedCategory,
              let image = eventImage.image?.getJpeg(quality: .low)
        else {
            // to do - handle error
            return
        }
        
        startLoadingAnimation()
        

        if currentEvent == nil {
            let eventId = String.randomString(length: 30)
            DatabaseHandler.shared.uploadImage(image: image) { imageUrl in
                let newEvent = Event(ownerId: currentUserId, eventCategory: category, name: name, startDate: startingDate, endDate: endingDate, price: price, location: location, numberOfPeople: numberOfPeople, image: imageUrl, eventId: eventId)
                
                DatabaseHandler.shared.addData(data: [newEvent], collection: .events) {
                    self.stopLoadingAnimation()
                    self.navigationController?.popToRootViewController(animated: true)
                } failure: { error in
                    self.stopLoadingAnimation()
                    // to do - handle error
                }

            } failure: { error in
                self.stopLoadingAnimation()
                // to do - handle error
            }
        }
        
        
        else {
            let eventId = currentEvent!.eventId // already cheched if currentEvent is nil
            let newEvent = Event(ownerId: currentUserId, eventCategory: category, name: name, startDate: startingDate, endDate: endingDate, price: price, location: location, numberOfPeople: numberOfPeople, image: currentEvent?.image, eventId: eventId)
            DatabaseHandler.shared.updateEvent(event: newEvent) { completion in
                if completion {
                    self.stopLoadingAnimation()
                    self.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    self.stopLoadingAnimation()
                    // to do - handle error
                }
            }
        }
        
        

        
    }
    
}

//MARK: - Delegate extensions -

//MARK: - Image Picker

extension EventEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    eventImage.image = pickedImage
                }

                dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Date Picker

extension EventEditorViewController: DatePickerViewControllerDelegate {
    
    func didSetDate(eventDate: EventDate) {
        switch eventDate.type {
        case .startDate:
            self.selectedStartDate = eventDate.date
            self.startDateLabel.text = eventDate.date.toString(style: .style1)
        
        case .endDate:
            self.selectedEndDate = eventDate.date
            self.endDateLabel.text = eventDate.date.toString(style: .style1)
        }
    }
    
}

//MARK: - Location Picker

extension EventEditorViewController: LocationPickerViewControllerDelegate {
    
    func didSetLocation(location: Location) {
        selectedLocation = location
        locationLabel.text = location.name
    }
    
}

//MARK: - Category Picker

extension EventEditorViewController: CategoryPickerViewControllerDelegate {
    
    func didSetCategory(eventCategory: EventCategory) {
        selectedCategory = eventCategory
        categoryLabel.text = eventCategory.description
    }
    
}
