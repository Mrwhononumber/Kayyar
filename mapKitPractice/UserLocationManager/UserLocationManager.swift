//
//  UserLocationManager.swift
//  mapKitPractice
//
//  Created by Basem El kady on 12/27/21.
//

import Foundation
import CoreLocation

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
 static let shared = UserLocationManager()
    var locationz:CLLocation!
   
    
    private override init() {
        super.init()
        requestLocationUpdates()
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    
    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // show alert
            break
        case .denied:
           // show alert
            break
        case .authorizedAlways:
            locationManager.stopUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()

        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()

        @unknown default:
            locationManager.stopUpdatingLocation()
            break
        }
    }
    
//    func fetchStuff(Completion:@escaping (CLLocation)->()){
//        var asd:CLLocation!
//    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            locationz = locations.last
        }
    }
  
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
            }
    
    
    
    
}
