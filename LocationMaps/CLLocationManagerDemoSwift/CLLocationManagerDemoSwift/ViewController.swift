//
//  ViewController.swift
//  CLLocationManagerDemoSwift
//
//  Created by Ancil on 10/4/15.
//  Copyright © 2015 Ancil Marshall. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var lonLabel:UILabel!
    @IBOutlet weak var latLabel:UILabel!
    @IBOutlet weak var markLabel:UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  !CLLocationManager.locationServicesEnabled() {
            return
        }
        locationManager.delegate = self
        beginLocationUpdatesIfPossible()
    }
    
    
    func beginLocationUpdatesIfPossible() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .Denied, .Restricted:
            return
            
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
            
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            break
        }
        
        locationManager.startUpdatingLocation()
    }

}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        beginLocationUpdatesIfPossible()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        lonLabel.text = "\(location.coordinate.longitude)"
        latLabel.text = "\(location.coordinate.latitude)"
    }
}

