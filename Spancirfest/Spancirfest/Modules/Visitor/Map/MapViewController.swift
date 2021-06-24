//
//  MapViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 15/06/2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    
    //MARK: - Private properties
    
    private var locations: [Location] = []
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        configureMap()
        fetchData {
            self.setPins()
        }
    }
    
    private func configureMap() {
        var centerCoordinate = CLLocationCoordinate2D()
        centerCoordinate.latitude = 46.306572
        centerCoordinate.longitude = 16.335350
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func setPins() {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func fetchData(completion: @escaping (() -> Void)) {
        DatabaseHandler.shared.getData(type: Location.self, collection: .locations) { locations in
            self.locations = locations
            completion()
        } failure: { error in
            // to do - handle error
            completion()
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        debugPrint("YOOTOO")
    }
    
}
