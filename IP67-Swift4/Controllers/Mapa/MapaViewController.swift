//
//  MapaViewController.swift
//  IP67-Swift4
//
//  Created by Nando on 31/12/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapaViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let dao = ContatoDao.shared
    fileprivate let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        
        setupLocationPermissions()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        
        mapView.addAnnotations(dao.findAll())
    }

    override func viewWillDisappear(_ animated: Bool) {
        mapView.removeAnnotations(dao.findAll())
    }
    
    private func setupLocationPermissions(){
        locationManager.requestWhenInUseAuthorization()
    }
}


extension MapaViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pin = getPin(by: "pino", and: annotation) as! MKPinAnnotationView
        
        pin.pinTintColor = .blue
        
        guard let contato = annotation as? Contato else {
            return pin
        }
        
        
        guard let image = contato.foto else {
            return pin
        }
        
        pin.canShowCallout = true
        
        let frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let imageView = UIImageView(frame: frame)
        
        imageView.image = image
        
        
        pin.leftCalloutAccessoryView = imageView
        
        return pin
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
        
        var span = mapView.region.span
       
        span.latitudeDelta *= 0.5
        span.longitudeDelta *= 0.5
        
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    private func getPin(by id:String, and annotation: MKAnnotation) -> MKAnnotationView {
        guard let _ = mapView.dequeueReusableAnnotationView(withIdentifier: id) else {
            return MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
        }
                
        return mapView.dequeueReusableAnnotationView(withIdentifier: id, for: annotation)
    }
    
}
