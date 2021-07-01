//
//  LocationDetailsViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 01/07/2021.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var locationNameLabel: UILabel!
    @IBOutlet private weak var locationDescriptionLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    
    //MARK: - Public properties
    
    var location: Location?
    
    //MARK: - Private properties
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extensions -

private extension LocationDetailsViewController {
    
    //MARK: - Setup and configuration
    
    private func setupView() {
        configureBackgroundView()
        setLocationDetails()
        configureMap()
    }
    
    private func configureBackgroundView() {
        backgroundView.layer.cornerRadius = 15
    }
    
    private func setLocationDetails() {
        guard let location = location else { return }
        locationNameLabel.text = location.name
        locationDescriptionLabel.text = location.description
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
