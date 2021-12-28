//
//  myTableViewCell.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/21/21.
//

import UIKit
import CoreLocation
import MapKit

class MyTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var tableViewMap: MKMapView!
    @IBOutlet weak var kayyarLevelLabel: UILabel!
    
    var userCurrentLocation: CLLocation!
    var cellSpot: Spot! {
        didSet {
            cityLabel.text = cellSpot.city
            streetLabel.text = cellSpot.address
            guard let userCurrentLocation = userCurrentLocation else {
                distanceLabel.text = "N/a"
                return
            }
            kayyarLevelLabel.text = String (format:"%.0f",cellSpot.dangerLevel)
            let distanceInMeters = cellSpot.spotLocation.distance(from: userCurrentLocation)
            let distanceInKiloMetre =  String(format:"%.1f",(distanceInMeters / 1000))
            distanceLabel.text = "\(distanceInKiloMetre) Km away"
            setupTableViewMap()
        }
    }
    
    //MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK: - Helper Functions
    
    func setupTableViewMap(){
        let mySpotLocation = CLLocationCoordinate2D(latitude: cellSpot.latitude, longitude: cellSpot.longitude)
        let myRegion = MKCoordinateRegion(center: mySpotLocation, latitudinalMeters: 60000, longitudinalMeters: 60000)
        tableViewMap.setRegion(myRegion, animated: true)
        tableViewMap.layer.cornerRadius = 5
    }
}
