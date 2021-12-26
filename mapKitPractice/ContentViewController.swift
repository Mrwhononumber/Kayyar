//
//  DetailViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/15/21.
//

import UIKit
import MapKit
import Firebase

class ContentViewController: UIViewController {
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var kayyarButton: UIButton!
    @IBOutlet weak var messageLabel: UITextField!
    
 var spots = Spots()
var  myPlacemarks: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        kayyarButton.layer.cornerRadius = kayyarButton.bounds.height*0.5
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateAdressLabel(_:)), name: NSNotification.Name("userPlacemarkNotification"), object: nil)
        
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
      
           
        
    }
    
    
    @IBAction func kayyarButtonPressed(_ sender: UIButton) {
       
        // Create a spot object
        
        let spot = Spot()
        spot.address = adressLabel.text!
        spot.kayyarMessage = messageLabel.text!
        spot.city = myPlacemarks!.locality ?? ""
        spot.latitude = (myPlacemarks?.location?.coordinate.latitude)!
        spot.longitude = (myPlacemarks?.location?.coordinate.longitude)!
        spot.submitionDateString = getCurrentDateAndTimeString()
        
        
        // Save the data
        spot.saveData { success in
            if success { print("saved the spot to firestore successfuly!")
                self.performSegue(withIdentifier: "detailToTable", sender: self)
              
                print(self.spots.spotArray.count)
        } else {
            print { ("something happened while sabing the spot to firestore")}
        }
        
        
        
    }
    
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination
//    }
    
    
    
    @objc func updateAdressLabel(_ notification:Notification){
        if let myPlacemark = notification.object as? CLPlacemark  {
            DispatchQueue.main.async {
                self.myPlacemarks = myPlacemark
                let streetNumber = myPlacemark.subThoroughfare ?? ""
                let streetName = myPlacemark.thoroughfare ?? ""
                self.adressLabel.text = "\(streetNumber) \(streetName)"
                print(self.adressLabel.text)
                print("first notification got triggered")
                
            }
            
           
        }
    }
    



}
