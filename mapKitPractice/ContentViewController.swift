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
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        kayyarButton.layer.cornerRadius = kayyarButton.bounds.height*0.5
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateAdressLabel(_:)), name: NSNotification.Name("Helloz"), object: nil)
            
//            self.adressLabel.text = AddressSingelton.shared.address!
    
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
