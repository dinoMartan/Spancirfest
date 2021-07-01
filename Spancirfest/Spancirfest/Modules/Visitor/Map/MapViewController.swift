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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData {
            self.setPins()
        }
    }

}

//MARK: - Private extensions -

private extension MapViewController {
    
    //MARK: - Setup
    
    private func setupView() {
        configureMap()
    }
    
    //MARK: - Map configuration
    
    private func configureMap() {
        mapView.delegate = self
        var centerCoordinate = CLLocationCoordinate2D()
        centerCoordinate.latitude = 46.306572
        centerCoordinate.longitude = 16.335350
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func setPins() {
        mapView.removeAnnotations(mapView.annotations)
        for location in locations {
            let annotation = LocationMKPointAnnotation(location: location)
            mapView.addAnnotation(annotation)
        }
    }
    
    //MARK: - Data
    
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

//MARK: - MKMapView Delegate -

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? LocationMKPointAnnotation,
              let mapLocationEventsViewController = UIStoryboard.getViewController(viewControllerType: MapLocationEventsViewController.self, from: .Map)
        else { return }
        mapLocationEventsViewController.location = annotation.getLocation()
        present(mapLocationEventsViewController, animated: true, completion: nil)
    }
    
}
