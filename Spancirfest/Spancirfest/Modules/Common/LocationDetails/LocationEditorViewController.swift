//
//  LocationEditorViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 01/07/2021.
//

import UIKit
import MapKit

protocol LocationEditorViewControllerDelegate: AnyObject {
    
    func didMakeChanges()
    
}

class LocationEditorViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var locationTitleTextField: UITextField!
    @IBOutlet private weak var locationDescriptionTextField: UITextField!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private var tapGuesture: UITapGestureRecognizer!
    
    //MARK: - Public properties
    
    var location: Location?
    weak var delegate: LocationEditorViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var coordinates: CLLocationCoordinate2D?
    
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
        guard let location = location else { return }
        locationTitleTextField.text = location.name
        locationDescriptionTextField.text = location.description
        coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
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
        else { updateLocation() }
    }
    
    private func prepareLocation(locationId: String) -> Location? {
        guard let coordinates = coordinates,
              let title = locationTitleTextField.text,
              let description = locationDescriptionTextField.text
        else { return nil }
        let location = Location(locationId: locationId, name: title, description: description, longitude: coordinates.longitude, latitude: coordinates.latitude)
        return location
    }
    
    private func updateLocation() {
        guard let locationId = location?.locationId else { return }
        guard let location = prepareLocation(locationId: locationId) else { return }
        DatabaseHandler.shared.updateLocation(location: location) { _ in
            self.delegate?.didMakeChanges()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func createLocation() {
        let locationId = String.randomString(length: 20)
        guard let location = prepareLocation(locationId: locationId) else { return }
        DatabaseHandler.shared.addData(data: [location], collection: .locations) {
            self.delegate?.didMakeChanges()
            self.dismiss(animated: true, completion: nil)
        } failure: { error in
            // to do - handle error
        }
    }
    
}

