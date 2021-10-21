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
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        kayyarButton.layer.cornerRadius = kayyarButton.bounds.height*0.5
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateAdressLabel(_:)), name: NSNotification.Name("Helloz"), object: nil)
            
//            self.adressLabel.text = AddressSingelton.shared.address!
    
    }
    
    @IBAction func kayyarButtonPressed(_ sender: UIButton) {
       
        // Create a spot object
        
        var spot = Spot()
        spot.address = adressLabel.text!
        spot.kayyarMessage = messageLabel.text!
        spot.saveData { success in
            if success { print("saved the spotto firestore successfuly!")
        } else {
            print { ("something happened while sabing the spot to firestore")}
        }
        
        
        
    }
    
    }
    
    
    
    @objc func updateAdressLabel(_ notification:Notification){
        if let myAddressLabel = notification.object as? String {
            DispatchQueue.main.async {
                self.adressLabel.text = myAddressLabel
                print(myAddressLabel)
            }
            
           
        }
    }
    



}
