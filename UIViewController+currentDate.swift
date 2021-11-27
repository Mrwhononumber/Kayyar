//
//  UIViewController+currentDate.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/26/21.
//

import UIKit

extension UIViewController {
    
    func currentDateAndTimeString() -> String {
        
        // Get the current date and time
        let currentDateTime = Date()
        
        // Initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy h:mm a"
        
//        formatter.timeStyle = .short
//        formatter.dateStyle = .short
        
        // Get the date and time String from the date object
        let dateTimeString = formatter.string(from: currentDateTime)
        
        
        return dateTimeString
    }
}
