//
//  YourLocationViewController.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/4/7.
//  Copyright © 2020 Rabbit. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class YourLocationViewController: ViewController, CLLocationManagerDelegate {
    lazy var location: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        return manager
    }()
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        
        map.showsUserLocation = true
        
        return map
    }()
    
    let locationDetailTableViewController = LocationDetailTableViewController()
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastPosition = locations.last {
            let region = MKCoordinateRegion(center: lastPosition.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            locationDetailTableViewController.location = lastPosition
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            location.startUpdatingLocation()
            
        default:
            location.stopUpdatingLocation()
            
            let alert = UIAlertController(title: "No Permission", message: "No Permission to access your location", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Your Location"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        location.requestWhenInUseAuthorization()
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.trailing.equalTo(view)
            make.leading.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.6)
        }
        
        let tableView = locationDetailTableViewController.view!
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(mapView.snp.bottom)
            make.trailing.equalTo(view)
            make.leading.equalTo(view)
        }
        
        view.backgroundColor = .systemBackground
    }
}
