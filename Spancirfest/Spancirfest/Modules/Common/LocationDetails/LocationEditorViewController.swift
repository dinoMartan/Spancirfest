//
//  LocationEditorViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 01/07/2021.
//

import UIKit
import MapKit
import SDWebImage

protocol LocationEditorViewControllerDelegate: AnyObject {
    
    func didMakeChanges()
    
}

class LocationEditorViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var locationImageView: UIImageView!
    @IBOutlet private weak var locationTitleTextField: UITextField!
    @IBOutlet private weak var locationDescriptionTextField: UITextField!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private var tapGuesture: UITapGestureRecognizer!
    
    //MARK: - Public properties
    
    var location: Location?
    weak var delegate: LocationEditorViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var coordinates: CLLocationCoordinate2D?
    private let imagePickerController = UIImagePickerController()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

//MARK: - Private extensions -

private extension LocationEditorViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        if location != nil { setLocationDetails() }
    }
    
    private func setLocationDetails() {
        configureMap()
        configureImage()
        guard let location = location else { return }
        locationTitleTextField.text = location.name
        locationDescriptionTextField.text = location.description
        coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    private func configureImage() {
        locationImageView.layer.opacity = 0.9
        guard let image = location?.image else { return }
        locationImageView.sd_setImage(with: URL(string: image), completed: nil)
    }
    
    private func configureMap() {
        guard let location = location else { return }
        let pin = LocationMKPointAnnotation(location: location)
        mapView.addAnnotation(pin)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: pin.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

//MARK: - IBActions -

extension LocationEditorViewController {
    
    @IBAction func didTapSetImageButton(_ sender: Any) {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func didTapOutside(_ sender: Any) {
        locationTitleTextField.resignFirstResponder()
        locationDescriptionTextField.resignFirstResponder()
    }
    
    @IBAction func didTapOnMap(_ sender: Any) {
        let location = tapGuesture.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        coordinates = coordinate
        
        mapView.removeAnnotations(mapView.annotations)
        let pin = MKPointAnnotation()
        pin.title = locationTitleTextField.text
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        if location == nil { createLocation() }
        else {
            updateLocation {
                self.dismiss(animated: true, completion: nil)
            } failure: { error in
                // to do - handle error
            }

        }
    }
    
    private func prepareLocation(locationId: String) -> Location? {
        guard let coordinates = coordinates,
              let title = locationTitleTextField.text,
              let description = locationDescriptionTextField.text
        else { return nil }
        
        let location = Location(locationId: locationId, name: title, description: description, longitude: coordinates.longitude, latitude: coordinates.latitude, image: nil)
        return location
    }
    
    private func updateLocation(success: @escaping (() -> Void), failure: @escaping ((Error?) -> Void)) {
        guard let locationId = location?.locationId,
              var location = prepareLocation(locationId: locationId)
        else { return }

        let selectedImage = locationImageView.image
        
        // if image isn't set
        if selectedImage == nil {
            update(location: location) {
                debugPrint("Updated without image")
                success()
            }
        }
        else {
            // if old image doesn't exist
            if self.location!.image == nil {
                DatabaseHandler.shared.uploadImage(image: selectedImage!, path: .eventImage) { url in
                    location.image = url
                    self.update(location: location) {
                        debugPrint("updated with new image")
                        success()
                    }
                } failure: { error in
                    failure(error)
                }
            }
            // if old image exists, compare it to the new one
            else {
                UIImageView().sd_setImage(with: URL(string: self.location!.image!)) { (image, error, _, url) in
                    if error != nil || image == nil { failure(nil) }
                    // if new image is the same as old one
                    if image!.isEqualToImage(selectedImage!) {
                        location.image = self.location!.image!
                        self.update(location: location) {
                            debugPrint("updated with the same image")
                            success()
                        }
                    }
                    // if new image is different to old image
                    else {
                        DatabaseHandler.shared.uploadImage(image: selectedImage!, path: .eventImage) { url in
                            location.image = url
                            self.update(location: location) {
                                debugPrint("updated with new image over old one")
                                success()
                            }
                        } failure: { error in
                            failure(error)
                        }
                    }
                }
            }
        }
    }
    
    private func update(location: Location, completion: @escaping (() -> Void)) {
        DatabaseHandler.shared.updateLocation(location: location) { _ in
            self.delegate?.didMakeChanges()
            completion()
        }
    }
    
    private func createLocation() {
        let locationId = String.randomString(length: 20)
        guard var location = prepareLocation(locationId: locationId),
              let image = locationImageView.image?.getJpeg(quality: .low)
        else { return }
        
        DatabaseHandler.shared.uploadImage(image: image, path: .locationImage) { imageUrl in
            location.image = imageUrl
            DatabaseHandler.shared.addData(data: [location], collection: .locations) {
                self.delegate?.didMakeChanges()
                self.dismiss(animated: true, completion: nil)
            } failure: { error in
                // to do - handle error
            }
        } failure: { error in
            // to do - handle error
        }
    }
    
}

//MARK: - ImagePicker Delegate -

extension LocationEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { locationImageView.image = pickedImage }
        dismiss(animated: true, completion: nil)
    }
    
}
