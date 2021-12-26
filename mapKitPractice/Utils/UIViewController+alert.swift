//
//  UIViewController+alert.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/26/21.
//

import UIKit

extension UIViewController {
    
    func myOneButtonAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true)
        
        
    }
    
}


