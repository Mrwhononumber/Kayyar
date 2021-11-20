//
//  KayyarTableViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/21/21.
//

import UIKit
import CoreLocation

class KayyarTableViewController: UIViewController {
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    var spots: Spots!
    var currentUserLocation: CLLocation!
    let locationManager = CLLocationManager()
    var viewController = ViewController()
    
    
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
    
    //MARK: - Segmented Control Implementation
    
    func sortBasedOnSegmentPressed(){
        
        switch mySegmentedControl.selectedSegmentIndex {
        case 0: // Recent
        
            spots.spotArray.sort(by: {$0.submitionDateObject.compare($1.submitionDateObject) == .orderedDescending})
           
//            spots.spotArray.sort{$0.submitionDateString.compare($1.submitionDateString, options: .numeric) == .orderedDescending}
//            print("sort func got triggered")
            
        case 1: // Distance
            spots.spotArray.sort(by: {$0.spotLocation.distance(from: currentUserLocation) < $1.spotLocation.distance(from: currentUserLocation)})
        case 2: // Kayyar Level
            spots.spotArray.sort(by: {$0.dangerLevel > $1.dangerLevel})
        default:
            print ("error occured, check segmented control for an error")
        }
        myTableView.reloadData()
        
        
    }
    
    @IBAction func mySegmentedControlPressed(_ sender: UISegmentedControl) {
        sortBasedOnSegmentPressed()
        
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
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentUserLocation = locations.last
        
//        print ("current user location in tableview is \(currentUserLocation)")
        
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    
}
