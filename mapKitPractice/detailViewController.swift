//
//  detailViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/25/21.
//

import UIKit
import MapKit

class detailViewController: UIViewController {

    @IBOutlet weak var detailMapView: MKMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
  
    
   
    var detailSpot: Spot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showMySpinner()
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeMySpenner()
    }
    
 
    
    func updateUI(){
        addressLabel.text = detailSpot.address
        
        setupDetailMaViewMap()
        self.title = detailSpot.city
    }
    
    
    
    
    //MARK: - DetailView Map setup
    
    func setupDetailMaViewMap(){
        
        let mySpotLocation = CLLocationCoordinate2D(latitude: detailSpot.latitude, longitude: detailSpot.longitude)
        let myRegion = MKCoordinateRegion(center: mySpotLocation, latitudinalMeters: 650, longitudinalMeters: 650)
        detailMapView.setRegion(myRegion, animated: true)
        
        // Add Pin
        let pin = MKPointAnnotation()
        pin.coordinate = mySpotLocation
        pin.title = detailSpot.kayyarMessage
        pin.subtitle = detailSpot.address
        detailMapView.addAnnotation(pin)

    }
    
  



}
