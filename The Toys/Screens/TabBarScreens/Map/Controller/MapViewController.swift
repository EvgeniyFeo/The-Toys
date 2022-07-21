//
//  MapViewController.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
//    MARK: - Variables -
    
    private let locationManager = CLLocationManager()
    
    private var shopsDatabase: [ShopOnMap] = [
        ShopOnMap(latitude: 53.91472, longitude: 27.57447, name: "Машерова 14", workingHours: "10:00 - 22:00"),
        ShopOnMap(latitude: 53.90462, longitude: 27.56175, name: "Интернациональная 36", workingHours: "09:00 - 21:00"),
        ShopOnMap(latitude: 53.90009, longitude: 27.65652, name: "Ваупшасова 15/2", workingHours: "11:00 - 23:00")
    ]
        
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        
        return mapView
    }()
    
    //    MARK: - ViewController LifeCycle -

    override func loadView() {
        super.loadView()
        
        self.view.addSubview(mapView)
        self.setConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addMarkers()
    }
    
    //    MARK: - Set ViewController -

    
    private func setConstraints() {
        
        NSLayoutConstraint.activate(
            [
                self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ]
        )
    }
    
    private func addMarkers() {

        for shop in shopsDatabase {
            let pin = MKPointAnnotation()
            pin.title = shop.name
            pin.subtitle = shop.workingHours
            pin.coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
            
            locationManager.requestAlwaysAuthorization()
            let location = CLLocation(latitude: 53.9000000, longitude: 27.5666700)
            self.mapView.centerToLocation(location)
            self.mapView.addAnnotation(pin)
        }
    }
}

//    MARK: - ViewController Extensions -


extension MapViewController: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            
        default: break
        }
    }
    
    public func showRegion(location: CLLocation) {
        
        var region = MKCoordinateRegion()
        region.center = location.coordinate
        region.span.latitudeDelta = 0.5
        region.span.longitudeDelta = 0.5
        
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifire = "shop"
        var view: MKMarkerAnnotationView
        
        let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
        
        if let dequueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifire) as? MKMarkerAnnotationView {
            dequueView.annotation = annotation
            return dequueView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifire)
            view.calloutOffset = CGPoint(x: 0, y: 0)
            view.canShowCallout = true
            view.markerTintColor = .purple
            view.rightCalloutAccessoryView = mapsButton
        }
        return view
    }
}

extension MKMapView {
    public func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 10000) {
        
        let coordinate = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: regionRadius,
                                            longitudinalMeters: regionRadius)
        setRegion(coordinate, animated: true)
        setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: coordinate), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 50000)
        setCameraZoomRange(zoomRange, animated: true)
    }
}
