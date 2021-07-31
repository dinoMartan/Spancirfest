//
//  LocationEditorViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 01/07/2021.
//

import UIKit
import MapKit
import SDWebImage

class LocationEditorViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var locationImageView: UIImageView!
    @IBOutlet private weak var locationTitleTextField: UITextField!
    @IBOutlet private weak var locationDescriptionTextField: UITextField!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private var tapGuesture: UITapGestureRecognizer!
    @IBOutlet private weak var activityView: UIView!
    
    //MARK: - Public properties
    
    var location: Location?
    weak var delegate: LocationEditorViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var coordinates: CLLocationCoordinate2D?
    private let imagePickerController = UIImagePickerController()
    private var didChanges = false
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if didChanges { delegate?.didChanges() }
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
    
    //MARK: - Activity indicator
    
    private func showActivityIndicator() {
        activityView.layer.opacity = 0.9
        activityView.isHidden = false
    }
    
    private func hideActivityIndicator() {
        activityView.isHidden = true
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
        var locationId: String
        if location == nil { locationId = String.randomString(length: 20) }
        else { locationId = location!.locationId }
        
        showActivityIndicator()
        
        prepareLocation(locationId: locationId) { newLocation in
            guard let newLocation = newLocation else {
                Alerter.showOneButtonAlert(on: self, title: .error, message: .dataFetchingFailed, actionTitle: .ok, handler: nil)
                self.hideActivityIndicator()
                return
            }
            
            if self.location != nil {
                DatabaseHandler.shared.updateLocation(location: newLocation) { didUpdate in
                    if !didUpdate {
                        Alerter.showOneButtonAlert(on: self, title: .error, message: .updateFailed, actionTitle: .ok, handler: nil)
                        self.hideActivityIndicator()
                    }
                    else { self.delegate?.didChanges() }
                    self.hideActivityIndicator()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else {
                DatabaseHandler.shared.addData(data: [newLocation], collection: .locations) {
                    self.delegate?.didChanges()
                    self.hideActivityIndicator()
                    self.dismiss(animated: true, completion: nil)
                } failure: { error in
                    Alerter.showOneButtonAlert(on: self, title: .error, message: .updateFailed, actionTitle: .ok, handler: nil)
                    self.hideActivityIndicator()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func prepareLocation(locationId: String, completion: @escaping ((Location?) -> Void)) {
        guard let coordinates = coordinates,
              let title = locationTitleTextField.text,
              let description = locationDescriptionTextField.text
        else {
            Alerter.showOneButtonAlert(on: self, title: .error, message: .checkFields, actionTitle: .ok, handler: nil)
            completion(nil)
            return
        }
        
        ImageUpdater.shared.updateImage(currentImageView: locationImageView, oldImageUrl: location?.image, imagePath: .locationImage, imageQuality: .low) { response in
            var location = Location(locationId: locationId, name: title, description: description, longitude: coordinates.longitude, latitude: coordinates.latitude, image: nil)
            switch response {
            case .noImage:
                location.image = nil
            case .newImageUploaded(let url):
                location.image = url
            case .imageUpdated(let url):
                location.image = url
            case .imageNotChanged(let url):
                location.image = url
            case .error(_):
                Alerter.showOneButtonAlert(on: self, title: .error, message: .updateFailed, actionTitle: .ok, handler: nil)
                completion(nil)
            }
            completion(location)
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
