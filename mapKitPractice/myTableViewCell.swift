//
//  myTableViewCell.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/21/21.
//

import UIKit
import CoreLocation

class myTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var userCurrentLocation: CLLocation!
    var cellSpot: Spot! {
        didSet {
            cityLabel.text = cellSpot.city
            streetLabel.text = cellSpot.address
            guard let userCurrentLocation = userCurrentLocation else {
                distanceLabel.text = "N/a"
                return
            }
            let distanceInMeters = cellSpot.spotLocation.distance(from: userCurrentLocation)
            let distanceInKiloMetre =  String(format:"%.1f",(distanceInMeters / 1000))
            distanceLabel.text = "\(distanceInKiloMetre) Km away"
        }
    }
    
   
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
