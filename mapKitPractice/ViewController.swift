//
//  ViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/14/21.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtudeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeter: Double = 5000
    var previousLocation: CLLocation?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
        checkLocationServices()
       
    }

    
    
    func checkLocationServices(){
        
        if CLLocationManager.locationServicesEnabled() {
            // setup location manager
            setupLocationManager()
            checkLocationAuthorization()
           
        } else {
            // show alert letting the user know they need to turn this on
        }
    }
    
    func setupLocationManager () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func centerViewOnUserLocaion() {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            myMapView.setRegion(region, animated: true)
        }
        
    }
    
    
    
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            // Do Map Stuff
          startTrackingUserLocation()
        case .denied:
            // Show alert showing the user how to turn on location permission
             break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // show alert letting user know what's up
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func startTrackingUserLocation() {
        myMapView.showsUserLocation = true
        centerViewOnUserLocaion()
        locationManager.startUpdatingLocation()
        previousLocation = getCentreLocation(for: myMapView)
    }
    
    
    
    func getCentreLocation(for mapview: MKMapView) -> CLLocation {
        //  Get the centre coordinates of the map
        let latitude = myMapView.centerCoordinate.latitude
        let longitude = myMapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    
    
    
    
}






extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        guard let location = locations.last else {return}
//        // Get current (last) coordinates of the user
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        // Create the region surrounding the user
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
//        // Update the map view
//        myMapView.setRegion(region, animated: true)
        
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let centre = getCentreLocation(for: myMapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = previousLocation else { return }
        
        
        // check if the map has been moved more than 50 meters to proceed with the geoCoder request
        guard centre.distance(from: previousLocation) > 50 else {return}
        // update previous location to the current centre location
        self.previousLocation = centre
        
        geoCoder.reverseGeocodeLocation(centre) { [weak self](placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
                // To Do: show aler letting the user know that there is an error
            }
            guard let placemark = placemarks?.first else {
                // To Do: show alert informing the user
                return
            }
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            DispatchQueue.main.async {
                self.adressLabel.text = "\(streetNumber)-\(streetName)"
                self.latitudeLabel.text =  String(self.myMapView.centerCoordinate.latitude)
                self.longtudeLabel.text = String (self.myMapView.centerCoordinate.longitude)
            }
            
        }
        
    }
    
    
    
}

