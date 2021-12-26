//
//  ViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/14/21.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var myFloatingView: UIView!
    @IBOutlet weak var newAddress: UILabel!
    @IBOutlet weak var newAddressDetail: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var spotsButton: UIButton!
    var userLocation: CLLocation?
    var spots = Spots()
    var myPlacemark: CLPlacemark?
    let locationManager = CLLocationManager()
    let regionInMeter: Double = 650
    var previousLocation: CLLocation?
 
 
    
    //MARK: - VC LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        checkLocationServices()
        setupUIElements()
        AddGestureRecognizer()
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
    
    //MARK: - Buttons Interactions
    
    @IBAction func confirmSpotButtonPressed(_ sender: UIButton) {
        
        guard newAddress.text != "" else {
        myOneButtonAlert(title: "Unvalid address ", message: "Please make sure to choose a valid address")
            return
        }
      showSpotConfirmationAlert()
    }
    
    //MARK: - Helper functions
    
    func setupUIElements() {
         setupSpotsButton()
         setupMyfloatingView()
    }
    
    func customizeNavigationController(){
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupMapView(){
        myMapView.delegate = self
    }
    
    func setupSpotsButton(){
        spotsButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        spotsButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        spotsButton.layer.shadowOpacity = 1.0
        spotsButton.layer.shadowRadius = 0.0
        spotsButton.layer.masksToBounds = false
        spotsButton.layer.cornerRadius = 4.0
    }


    func checkLocationServices(){
        
        if CLLocationManager.locationServicesEnabled() {
            // setup location manager
            setupLocationManager()
            checkLocationAuthorization()
           
        } else {
            // show alert letting the user know they need to turn this on
            myOneButtonAlert(title: "couldn't find your location", message: "make sure to turn on your location services")
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
            myOneButtonAlert(title: "cannot access your location", message: "Go to Settings -> Location")

             break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // show alert letting user know what's up
            myOneButtonAlert(title: "cannot access your location", message: "Access to your locarion is restricted")
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
            
            if error != nil {
                self.myOneButtonAlert(title: "Error", message: "Error happened while retriving location. please try again.")
            }
            guard let placemark = placemarks?.first else {
               
                self.myOneButtonAlert(title: "Error", message: "Error happened while retriving location. please try again.")
                return
            }
            self.myPlacemark = placemark
            let streetNumber = self.myPlacemark?.subThoroughfare ?? ""
            let streetName = self.myPlacemark?.thoroughfare ?? ""
            let city = self.myPlacemark?.locality ?? ""
            let name = self.myPlacemark?.name ?? ""

            DispatchQueue.main.async {
                self.newAddress!.text = "\(streetNumber) \(streetName)"
                self.newAddressDetail!.text = "\(name)-\(city)"
                // Notification to be used by whomever needs access to the user's chosen location
                // Replacing the notificationCenter with a closure to be considered
                NotificationCenter.default.post(name: NSNotification.Name("userPlacemarkNotification"), object: self.myPlacemark)
            }
            
        }
        
    }
    
}


//MARK: - My Custom floating panel

extension ViewController {

    func AddGestureRecognizer(){
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(animateMyFloatingView))
            swipeGesture.direction = [.up, .down, .left, .right]
        
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateMyFloatingView))
            view.addGestureRecognizer(swipeGesture)
            view.addGestureRecognizer(tapGesture)
    }
    
    
    
    
    @objc func animateMyFloatingView(){
        UIView.animate(withDuration: 0.2) {
            self.myFloatingView.transform = CGAffineTransform(translationX: 0, y: -140)
        }
    }
    
    func setupMyfloatingView(){
        myFloatingView.layer.cornerRadius = 30
        myFloatingView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        myFloatingView.isOpaque = false
        confirmButton.layer.cornerRadius = 20
    }
    
    //MARK: - Spot Confirmation Alert
    
   func showSpotConfirmationAlert() {
    let confirmationAlert = UIAlertController(title: "Almost there 🙌🏼", message: "please tell us briefly why you choose this spot?", preferredStyle: .alert)
        confirmationAlert.addTextField { textField in
        textField.placeholder = "Enter your message here"
        textField.returnKeyType = .done
    }
    
    confirmationAlert.addAction(UIAlertAction(title: "Publish", style: .default, handler: { handler  in
        // Read values from text field
        guard let textFields = confirmationAlert.textFields else {return}
        let messageField = textFields[0]
        guard let userMessage = messageField.text, userMessage.isEmpty == false else {return}
        // Create the new spot && Navigate to next VC
        self.createNewSpot(message: userMessage)
    }))
    confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(confirmationAlert, animated: true, completion: nil)
    }
    
    
    func createNewSpot(message: String){
       let spot = Spot()
        spot.address = newAddress.text!
        spot.kayyarMessage = message
        spot.city = myPlacemark?.locality ?? ""
        spot.latitude = (myPlacemark!.location?.coordinate.latitude) ?? 0.0
        spot.longitude = (myPlacemark!.location?.coordinate.longitude) ?? 0.0
        spot.submitionDateString = getCurrentDateAndTimeString()
        
        // Save the spot to Firebase && Navigate to next VC
        spot.saveData { success in
            if success {
                self.performSegue(withIdentifier: "VCToTV", sender: self)
                print("saved the spot to firestore successfuly!")
                
                print(self.spots.spotArray.count)
        } else {
            print { ("something happened while sabing the spot to firestore")}
        }
        
    }
                
    }
    
    
    
}




