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
    
    var detailSpot: Spot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(detailSpot.address)
        setupDetailMaViewMap()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showMySpinner()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeMySpenner()
    }
    
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
