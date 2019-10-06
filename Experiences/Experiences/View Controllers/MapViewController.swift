//
//  MapViewController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    let experienceController = ExperienceTempController.shared

    let locationManager = CLLocationManager()

    private lazy var dateFormatter: DateFormatter = {
         let result = DateFormatter()
         result.dateStyle = .short
         result.timeStyle = .short
         return result
     }()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserCurrentLocation()
        loadExperiences()
    }

    @IBAction func currentLocationTapped(_ sender: UIButton) {
        mapView.showsUserLocation.toggle()
        getUserCurrentLocation()
    }

    func loadExperiences() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(experienceController.experiences)
        if let firstExperience = experienceController.experiences.first {
            let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
            let region = MKCoordinateRegion(center: firstExperience.coordinate, span: span)

            mapView.setRegion(region, animated: true)
        }
    }

    func getUserCurrentLocation() {
        guard let userCurrentLocation = mapView.userLocation.location else { return }
        let coordinate = userCurrentLocation.coordinate
        let coordinateCenter = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinateCenter, span: span)
        mapView.setRegion(region, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? ExperienceTemp else { return nil }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView") as? MKMarkerAnnotationView else { fatalError("Incorrect view is registered") }

        annotationView.glyphImage = UIImage(systemName: "doc.richtext")
        annotationView.markerTintColor = .systemPink

        annotationView.canShowCallout = true
        let detailView = ExperienceMapDetailView(frame: .zero)
        detailView.experience = experience
        annotationView.detailCalloutAccessoryView = detailView

        return annotationView
    }
}
