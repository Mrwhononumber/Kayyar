//
//  KayyarTableViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/21/21.
//

import UIKit
import CoreLocation
import Firebase

class KayyarTableViewController: UIViewController {
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    var spots: Spots!
    var currentUserLocation: CLLocation!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        spots = Spots()
        myTableView.delegate = self
        myTableView.dataSource = self
     
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationServices()
        self.showMySpinner()
        spots.loadData {
            self.sortBasedOnSegmentPressed()
            self.myTableView.reloadData()
            print("😅\(self.spots.spotArray.count)")
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        removeMySpenner()
        
    }
    
    
    //MARK: - SignOut
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
     showSignOutAlert()
        
    }
    
    func showSignOutAlert(){
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "sign out", style: .destructive, handler: { action in
            // pereform the signing out
            self.signOutUser()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        // present the alert
        present(alert, animated: true, completion: nil)
        
    }
    
    func signOutUser(){
        let firebaseAuth = Auth.auth()
    do {
        // sign out the user
      try firebaseAuth.signOut()
       // Navigate to the initial viewcontroller
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "InitialScreen") as! HomeViewController
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated:true, completion:nil)

        
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
        
    }
    
    
    
    
    
    //MARK: - Segmented Control Implementation
    
    @IBAction func mySegmentedControlPressed(_ sender: UISegmentedControl) {
        sortBasedOnSegmentPressed()
        
    }
    
    func sortBasedOnSegmentPressed(){
        
        switch mySegmentedControl.selectedSegmentIndex {
        case 0: // Recent
        
            spots.spotArray.sort(by: {$0.submitionDateObject.compare($1.submitionDateObject) == .orderedDescending})
            
        case 1: // Distance
            spots.spotArray.sort(by: {$0.spotLocation.distance(from: currentUserLocation) < $1.spotLocation.distance(from: currentUserLocation)})
        case 2: // Kayyar Level
            spots.spotArray.sort(by: {$0.dangerLevel > $1.dangerLevel})
        default:
            print ("error occured, check segmented control for an error")
        }
        myTableView.reloadData()
        
        
    }
    

    
    
    
    
}

//MARK: - TableView Datasource and Delegate Methods

extension KayyarTableViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return spots.spotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myTableViewCell
        if let currentUserLocation = currentUserLocation {
            cell.userCurrentLocation = currentUserLocation
        }
        cell.cellSpot = spots.spotArray[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let destination = segue.destination as! SpotDetailViewController
            let selectedIndexPath = myTableView.indexPathForSelectedRow!
            destination.detailSpot = spots.spotArray[selectedIndexPath.row]
        }
        
        
    }
    
    
}

//MARK: - Current user location

extension KayyarTableViewController: CLLocationManagerDelegate {
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            SetupLocationMAnager()
            checkLocationAuthorization()
            // initiate tracking
        } else {
            // alert: please enable location sevices
            myOneButtonAlert(title: "cannot access your location", message: "Go to Settings -> Location")
        }
    }
    
    func SetupLocationMAnager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        // Do Map Stuff
        
        case .denied:
            // Show alert showing the user how to turn on location permission
            myOneButtonAlert(title: "cannot access your location", message: "Go to Settings -> Location")
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
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentUserLocation = locations.last
                
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationServices()
    }
    
}
