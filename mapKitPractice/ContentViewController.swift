//
//  DetailViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/15/21.
//

import UIKit

class ContentViewController: UIViewController {
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var kayyarButton: UIButton!
    @IBOutlet weak var messageLabel: UITextField!
    
 var spots = Spots()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        kayyarButton.layer.cornerRadius = kayyarButton.bounds.height*0.5
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateAdressLabel(_:)), name: NSNotification.Name("Helloz"), object: nil)

    
    }
    
    @IBAction func kayyarButtonPressed(_ sender: UIButton) {
       
        // Create a spot object
        
        var spot = Spot()
        spot.address = adressLabel.text!
        spot.kayyarMessage = messageLabel.text!
        
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
        if let myAddressLabel = notification.object as? String {
            DispatchQueue.main.async {
                self.adressLabel.text = myAddressLabel
                print(myAddressLabel)
            }
            
           
        }
    }
    



}
