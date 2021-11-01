//
//  UIViewController+avtivityIndicator.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/23/21.
//

import UIKit

fileprivate var myActivityIndicatiorView: UIView?

extension UIViewController {
     
    func showMySpinner() {
        myActivityIndicatiorView = UIView(frame: self.view.bounds)
        myActivityIndicatiorView?.backgroundColor = UIColor.init(red: 0.25, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let myActivityIndicator = UIActivityIndicatorView(style: .large)
        myActivityIndicator.center = myActivityIndicatiorView!.center
        myActivityIndicator.color = .systemGray
        myActivityIndicator.startAnimating()
        myActivityIndicatiorView?.addSubview(myActivityIndicator)
        self.view.addSubview(myActivityIndicatiorView!)
        
    }
    
    func removeMySpenner() {
        myActivityIndicatiorView?.removeFromSuperview()
        myActivityIndicatiorView = nil
    }
    
    
    
    
    
    
    
    

    
    
}


