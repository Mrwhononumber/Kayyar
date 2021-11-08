//
//  ViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/14/21.
//

import UIKit
import MapKit
import FloatingPanel



class ViewController: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!
  
    var userLocation: CLLocation?
    
    
    var myAdress:String = ""
    var spots = Spots()
    var myPlacemark: CLPlacemark?
    
    
  
    
    let locationManager = CLLocationManager()
    let regionInMeter: Double = 650
    var previousLocation: CLLocation?
 
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        checkLocationServices()
        setupFloatingPanel()
        
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        customizeNavigationController()
        showMySpinner()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        removeMySpenner()
    }
    
    func customizeNavigationController(){
        navigationController?.navigationBar.isHidden = true
    }
   
    func setupMapView(){
        myMapView.delegate = self
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
//        locationManager.distanceFilter = 1
        
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
        
//          userLocation = locations.last
//
//        print ("current location in view controller is \(userLocation)")
      
//            NotificationCenter.default.post(name: Notification.Name("userCurrentLocationNotification"), object: userLocation)
        
       
        // share the users current location
     
        
        
        
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
                
                self.myAdress = "\(streetNumber) \(streetName)"
                self.myPlacemark = placemark
                
                NotificationCenter.default.post(name: NSNotification.Name("userPlacemarkNotification"), object: self.myPlacemark)
                

                
               
                
                
            }
            
        }
        
    }
    
}

//MARK: - Floating Panel integration

extension ViewController: FloatingPanelControllerDelegate {
    
    func setupFloatingPanel (){
        
        // initialize a fp object
        let fpc = FloatingPanelController(delegate: self)

        fpc.layout = MyFloatingPanelLayout()
        fpc.delegate = self
        
        // inistantiate the content VC
        guard let contentVC = storyboard?.instantiateViewController(identifier: "fpc_content") as? ContentViewController else {return}
       
    //        contentVC.adressLabel.text = myAdress
        
        // add the content VC to the fp VC
        fpc.set(contentViewController: contentVC)
        
        
        // set fpc as a child to the viewcontroller (self)
        fpc.addPanel(toParent: self)
        
        
        
        let apperarance = SurfaceAppearance()
        apperarance.cornerRadius = 40
        apperarance.borderColor = .blue
        apperarance.backgroundColor = .black
        
        fpc.surfaceView.appearance = apperarance

               
    }
    
    
}




