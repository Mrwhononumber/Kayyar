//
//  detailViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/25/21.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
   
    @IBOutlet weak var reviewTableview: UITableView!
    
    
    @IBOutlet weak var detailMapView: MKMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
   
    var detailSpot: Spot!
    var reviews = Reviews()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        setupTableView()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showMySpinner()
        reviews.loadReviewData(spot: detailSpot) {
            self.reviewTableview.reloadData() 
        }
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeMySpenner()
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ReviewViewController
        destination.spot = detailSpot
    }
    
  
}

//MARK: - TableView




extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView(){
        reviewTableview.delegate = self
        reviewTableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableview.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewTableViewCell
        cell.review = reviews.reviewArray[indexPath.row]
        
        return cell
    }
    
    
    
    
    
}


